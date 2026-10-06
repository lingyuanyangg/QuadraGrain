# Quadra / Grain V2 技术说明

[English](TECHNICAL.en.md) | [简体中文](TECHNICAL.md)

本文根据当前主补丁、三个 `.gendsp`、`quadra_resample_ui.js` 和生成器编写。参数范围指基础 UI / Gen 参数，内部随机与组合运算可能产生不同的有效范围。

[返回项目说明](../README.md)

## 1. 系统分层

| 层 | 实现 | 职责 |
| --- | --- | --- |
| 宿主 UI | `live.dial`、`live.numbox`、`live.toggle`、`live.menu`、`live.drop` | 参数、自动化入口、路径状态 |
| 素材与页面 | Max `js` | 命名、载入、选区换算、pad 同步、状态显示 |
| 主颗粒 DSP | `quadra_resample_engine.gendsp` | 64 voice、四源读取、滤波、包络、混合 |
| Feedback DSP | `quadra_regrain_v3.gendsp` | 从临时 buffer 读取 32 voice 二次颗粒 |
| Freeze DSP | `quadra_audio_freeze.gendsp` | 捕获与循环最终混合音频 |
| MSP 路由 | `record~`、`clip~`、`send~`、`receive~`、`plugout~` | 记录、反馈返回、宿主输出 |

调度与每颗粒处理在 Gen 中逐采样执行。JS 处理界面和控制，不负责逐采样合成。两层活动数与扫描位置通过 `snapshot~ 100` 约每 100 ms 更新一次 UI。

## 2. 四源 morph

归一化坐标 `x,y∈[0,1]`，A / B 在上方，C / D 在下方：

| 角 | 坐标 | 权重 |
| --- | --- | --- |
| A | `(0,1)` | `sqrt((1−x)y) × levelA` |
| B | `(1,1)` | `sqrt(xy) × levelB` |
| C | `(0,0)` | `sqrt((1−x)(1−y)) × levelC` |
| D | `(1,0)` | `sqrt(x(1−y)) × levelD` |

Level 都为 0 dB 时，四个权重平方之和为 1；中心权重各为 0.5。这是针对不相关声音的恒功率混合关系，不能保证相关素材的总峰值或响度恒定。

每个活跃 grain 同时读取 A–D，再计算左右声道的加权和：

```text
grainL = AL·wA + BL·wB + CL·wC + DL·wD
grainR = AR·wA + BR·wB + CR·wC + DR·wD
```

Morph 权重在渲染阶段实时使用，没有在触发时锁定。X / Y 使用约 15 ms 一阶平滑，Level 使用约 10 ms 平滑。

`pictslider` 的 0–1000 坐标由 JS 换算为 0–1，更新 `live.numbox`。宿主自动化入口是 Morph X / Y；pad 自身 `parameter_enable=0`。

## 3. 主颗粒调度与 voice pool

主引擎使用 `Data voices(64,24)`。每个采样递减计数器；RUN 开启且计数器到期时，轮转扫描空闲 slot。空闲判定为 `age >= duration`，并要求编号小于 `floor(Grain Amount)`。

不会抢占正在播放的 grain。允许的 voice 都忙时，跳过当前触发，但仍重设计数器。Amount 是可分配 voice 上限，不是保证同时播放的数量。稳定运行、无随机时可粗略估计：

```text
重叠 voice ≈ Density[Hz] × Grain Size[ms] / 1000
```

降低 Amount 后，高编号中的已有 grain 自然结束。RUN 关闭停止新触发，已有 grain 完成包络。

### Voice 数据布局

| Data channel | 含义 |
| --- | --- |
| 0 / 1 | age / duration，输出采样帧 |
| 2 / 3 | 归一化起点 / 有符号读取速度 |
| 4 | pan，−1…1 |
| 5 / 6 | envelope shape / attack bias |
| 7 / 8 / 9 | 滤波系数 g / k / 模式 |
| 10 / 11 | 未使用的保留 channel |
| 12–15 | 左右滤波器各两个状态值 |
| 16–23 | A–D 各自的起止范围 |

触发时锁定：尺寸、起点、速度、方向、pan、包络、滤波系数、滤波模式、四个选区。实时使用：Morph 权重、源 Level、当前 buffer 内容和主层 Output。

### 触发与随机公式

以下 `r` 是一次 `noise()` 的 −1…1 随机值，不同调用分别取值。`Fs` 为输出采样率。

```text
durationSamples = max(5, size × (1+r×sizeJitter×0.95)) × Fs/1000
triggerInterval = max(1, Fs/density × (1+r×densityJitter×0.95))
startNormalized = wrap(position + scanPhase + r×positionJitter×0.5)
speed = rate × 2^((pitch+r×pitchJitter)/12) × direction
panPerGrain = clamp(pan+r×panSpread, −1, 1)
```

方向按随机值与 Reverse Probability 比较取 +1 / −1。尺寸扰动后只做 5 ms 下限，因此实际主层 grain 可超过 UI 的 1000 ms 上限。Density Randomness 扰动的是间隔；取倒数后的瞬时频率不是对称分布。

## 4. Sample 读取、选区与扫描

JS 将 waveform 的毫秒选区除以总时长，换算为 IN / OUT。Gen 在触发时排序端点，换算为每个 buffer 的帧区间：

```text
regionStart = min(IN,OUT) × bufferFrames
regionLength ≈ (max(IN,OUT)−min(IN,OUT)) × bufferFrames
readIndex = regionStart + wrap(
    startNormalized×regionLength
    + age×speed×sourceSampleRate/outputSampleRate,
    0, regionLength
)
```

实现有起点边界保护与最小 2 帧读取长度，正反向索引都在所选区域内循环。读取采用相邻两帧线性插值，邻帧也按选区环绕。

`info~` 发送四个 sample 的采样率到 `sra/srb/src/srd`，补偿源帧步进。单声道源的右声道回退到 channel 0，多声道素材只使用前两声道。高倍率线性插值没有提供带限重采样保证。

四源共享归一化起点，各自选区长度不同，不自动同步事件或周期。

扫描每采样执行：

```text
scanPhase[n+1] = wrap(scanPhase[n] + ScanSpeed/Fs)
scanPosition = wrap(Position + scanPhase)
```

Scan Speed 单位是归一化选区周期/秒。扫描持续运行，包括 RUN 关闭或 Freeze 开启期间。SCAN 显示叠加扫描相位后的值。

### 替换素材流程

`live.drop → prepend path <slot> → JS`：

1. 去掉消息类型前缀和成对引号，保留路径空格，忽略空值和 `none`。
2. 设置 `ready<slot>=0`，通过源增益平滑衰减该槽位。
3. 取消该槽位此前的待执行 Task，延后 50 ms 执行 `buffer~ replace`。
4. 非初始化阶段重置 IN / OUT 为 0 / 1。
5. 加载完成后重新绑定 waveform，恢复 ready 并刷新选区。

这不是双 buffer 切换；播放中的 grain 会读取新 buffer，不能保证所有热替换都无点击。

## 5. Macro Randomness 与 LFO

### Macro

`M∈[0,1]` 将基础随机量向最大值推进：

```text
effective = base + (maximum−base) × M
```

| 目标 | 最大值 |
| --- | --- |
| Position Jitter | 1 |
| Grain Size Jitter | 1 |
| Density Jitter | 1 |
| Pitch Jitter | 24 semitones |
| Pan Spread | 1 |

不写回五个基础旋钮。主层先计算 LFO 调制后的基础值，再计算 Macro；regrain 没有此计算。

### LFO

两组独立相位，Sine / Triangle / 上升 Ramp / 每周期更新一次的 S&H。Rate 为 0.01–20 Hz，Depth 为 0–1。在主 Gen 中，对目标参数计算：

```text
effectiveP = clamp(
    baseP + (selectedLFO1×depth1 + selectedLFO2×depth2) × (maxP−minP)/2,
    minP, maxP
)
```

指向同一目标时相加，到边界截断。LFO 不受 RUN 或 Freeze 控制，没有 transport 同步和相位复位。

菜单含 24 个目标，从 Morph X / Y 到 Filter Random。Feedback / Feedback Delay 的计算值没有传给 regrain，因此这两个内置目标当前无效。宿主直接改变对应控件仍可通过消息路由改变 regrain。

## 6. 包络、声像与滤波

### 包络

`u=age/max(1,duration−1)`，Bias `b∈[0.05,0.95]`：

```text
triangle = clamp(u<b ? u/b : (1−u)/(1−b), 0, 1)
hann = 0.5−0.5×cos(π×triangle)
trapezoid = min(1, triangle×4)
```

Shape 0…1 混合 triangle / hann；1…2 混合 hann / trapezoid。Shape=1、Bias=0.5 时对应常规对称 Hann。Bias 小则 attack 短、decay 长；它控制峰值位置，不是独立毫秒 ADSR。

### 声像

```text
leftGain  = cos((pan+1)×π/4)
rightGain = sin((pan+1)×π/4)
```

Stereo 输入时，这是左右各自加权，不把右通道内容交叉移到左侧，也不是宽度算法。

### 每 grain 滤波

左右独立状态的 TPT 状态变量滤波器，触发时计算：

```text
fc = clamp(cutoff×2^(r×filterRandom), 20, min(20000, Fs×0.4))
g = tan(π×fc/Fs)
k = 1/Q
a1 = 1/(1+g×(g+k))
a2 = g×a1
a3 = g×a2
```

模式为 Bypass / Lowpass / Bandpass / Highpass，状态使用 `fixdenorm`。滤波在每颗粒四源混合之后、包络和声像之前。Filter Random 单位为 octave。

此功能为时域滤波，无 FFT、逐频点 mask 或频谱冻结；regrain 没有同款滤波器。

## 7. 混合与增益

两层采用基于活动 voice 数的近似能量补偿：

```text
target = 1/sqrt(max(1, activeVoices×0.375))
normalization += (target−normalization)×0.001
```

这不是精确响度归一化。0.001 是固定逐采样系数，响应时间随采样率变化。

- 主层：`sum → normalization → tanh → dcblock → Output gain`。
- Regrain：`sum → normalization → tanh → Feedback gain`。

两个增益约 20 ms 平滑。源 Level 的 −70 dB 端点视为静音，其他值转为 `10^(dB/20)`；Output 的 −60 dB 仍为有限增益。

## 8. 临时 buffer 与递归 regrain

记录路径：

```text
primary + delayedRegrain → clip(−1,1) → record~ → temporary stereo buffer
```

`record~ @loop 1` 初始化开启。JS 将临时 buffer 设为 **524,288 帧、双声道**，覆盖对象初始的 4000 ms 配置。

| 采样率 | 实际时长 |
| --- | --- |
| 44.1 kHz | 约 11.89 s |
| 48 kHz | 约 10.92 s |
| 96 kHz | 约 5.46 s |

实例局部 `send~ / receive~` 为闭环提供 signal-vector 返回延迟，避免零延迟递归图。

Regrain 使用 `Data voices2(32,7)`：age、duration、起点、速度、pan、bias、shape。空闲分配、无抢占，32 voice 固定，不受 Grain Amount 控制。

```text
regrainSize = clamp(size×fbsize×(1+r×sizej×0.95), 5, 2000) ms
regrainInterval = max(1, Fs/(density×fbdensity) × (1+r×densityj×0.95))
regrainSpeed = rate×2^((pitch+fbpitch+r×pitchj)/12)×direction
nominalStart = wrap(internalWritePhase−fbdelay×Fs/1000)
```

使用共享旋钮基础值，附加 `fbsize/fbdensity/fbpitch`。触发条件为 RUN 开启、Feedback>0.0001、buffer 长度>2。

V3 的内部 `History writephase2` 每采样递增，未连接 `record~` 的 sync 输出。因此读写相位重置同步有待改进，Delay 是名义值。索引在整个临时 buffer 内环绕，读取线性插值。

Feedback 控制二次颗粒返回增益，返回音频又被记录，实现递归再颗粒化。没有主层的 Position Spray、Macro、内置 LFO 和逐颗粒滤波，也不写入磁盘文件。

## 9. 音频 Freeze

位于两层混合之后，使用 `Data capture(131072,2)`：

```text
captureFrames = min(131072, floor(Fs×0.25))
```

关闭且 crossfade 完成后循环写入；开启上升沿锁定长度和起点。未积累满 250 ms 时只使用已填充内容。

```text
p1 = wrap(phase, 0, length)
p2 = wrap(phase+length/2, 0, length)
w1 = 0.5−0.5×cos(2π×p1/length)
w2 = 1−w1
frozen = read(p1)×w1 + read(p2)×w2
output = mix(liveInput, frozen, freezeBlend)
```

`freezeBlend` 约 20 ms 线性切换。冻结期间停止写 capture，但主颗粒、scan、regrain 和反馈记录可以继续运行。解冻返回后台当前音频。

双窗降低边界突变，也会因两个半周期错位片段叠加而改变纹理；不是原始片段的逐位重复，也不是频谱冻结或单采样保持。

## 10. 参数参考

| 名称 / ID | 基础范围 | 默认 | 含义 |
| --- | --- | --- | --- |
| Morph X / `morphx` | 0–1 | 0.5 | 左→右 |
| Morph Y / `morphy` | 0–1 | 0.5 | 下→上 |
| Grain Size / `size` | 5–1000 ms | 120 | 基础时长 |
| Density / `density` | 0.5–150 Hz | 24 | 触发率 |
| Grain Amount / `amount` | 1–64 | 32 | 主层 voice 上限 |
| Pitch / `pitch` | −36…36 st | 0 | 音高指数 |
| Position / `position` | 0–1 | 0.25 | 扫描偏移 |
| Scan Speed / `scan` | −1…1 cyc/s | 0.03 | 区域周期/秒 |
| Position Jitter / `spray` | 0–1 | 0.05 | 起点扰动 |
| Size Random / `sizej` | 0–1 | 0.1 | 时长相对随机量 |
| Density Random / `densityj` | 0–1 | 0.1 | 间隔相对随机量 |
| Pitch Jitter / `pitchj` | 0–24 st | 0 | 对称音高抖动 |
| Playback Rate / `rate` | 0.125–4× | 1 | 与 Pitch 相乘 |
| Reverse Prob / `reverse` | 0–1 | 0 | 反向概率 |
| Envelope Shape / `shape` | 0–2 | 1 | triangle→hann→trapezoid |
| Attack Bias / `bias` | 0.05–0.95 | 0.5 | 峰值位置 |
| Pan / `pan` | −1…1 | 0 | 基础声像 |
| Pan Spread / `spread` | 0–1 | 0.25 | 声像随机量 |
| Macro Randomness / `macro` | 0–1 | 0 | 五目标宏 |
| Grain Cutoff / `cutoff` | 40–18000 Hz | 10000 | 基础截止频率 |
| Grain Q / `resonance` | 0.5–8 | 0.707 | 滤波 Q |
| Filter Random / `filterj` | 0–4 oct | 0 | 截止频率随机 |
| Feedback / `feedback` | 0–0.85 | 0 | 返回增益 |
| Feedback Delay / `fbdelay` | 50–2000 ms | 350 | 名义回看时长 |
| Regrain Size / `fbsize` | 0.25–4× | 1 | 尺寸倍率 |
| Regrain Density / `fbdensity` | 0.25–4× | 1 | 密度倍率 |
| Regrain Pitch / `fbpitch` | −24…24 st | 0 | 附加移调 |
| A–D Level / `<slot>level` | −70…6 dB | 0 | −70 静音 |
| IN / `<slot>start` | 0–1 | 0 | 区域起点 |
| OUT / `<slot>end` | 0–1 | 1 | 区域终点 |
| RUN / `run` | off/on | off | 两层触发开关 |
| Freeze / `freeze` | off/on | off | 音频冻结 |
| Output / `output` | −60…0 dB | −15 | 主层增益 |
| Filter Mode / `filtermode` | 四模式 | Lowpass | 主层滤波 |
| Input Capture / `inputgain` | 0–1 | 0 | 未实现 |
| LFO 1/2 Rate | 0.01–20 Hz | 0.13 / 0.07 | 自由运行频率 |
| LFO 1/2 Depth | 0–1 | 0 / 0 | 参数范围的一半为单位深度 |
| LFO 1/2 Target | Off + 24 目标 | Off | 见第 5 节限制 |
| LFO 1/2 Shape | 四波形 | Sine | 主层波形 |

## 11. Live 参数、状态与消息

连续控件设置 `parameter_enable=1`、`parameter_modmode=2`；菜单、RUN、Freeze、页面禁用连续调制模式。`live.drop` 用文件参数类型 4，以不可见宿主参数保存路径。

四组八参数 bank 为 Grain、Random、Tone、Morph，配合 `live.banks`。`autopattr @autorestore 1`、`live.thisdevice`、`loadbang → deferlow` 用于状态和初始化。

| 消息 | 接收方 / 效果 |
| --- | --- |
| `size 120` 等 | `prepend <id>` 传 Gen；共享参数另送 regrain |
| `a <bufferName>` 等 | 主 Gen 外部 Buffer 绑定 |
| `fbtemp <bufferName>` | 经 `route fbtemp` 绑定 regrain Buffer |
| `path a <filePath>` | JS 调度 A 的 replace |
| `selection a ...` | 换算 waveform 选区并更新 IN / OUT |
| `region a start <value>` | 更新 waveform 显示 |
| `active <n>` / `revoices <n>` | 两层计数 |
| `scanpos <value>` | SCAN 文本 |
| `page <index>` | 对象 hidden 属性切换 |

控制器 outlet 0 为 Gen 消息，outlet 1 为 waveform 范围消息。`guard` 防止选区和数值框循环更新。

JS 用时间戳和随机后缀生成 UID，给四源与临时 buffer 命名；反馈总线用 `#0` 实例局部名称，实现多实例资源隔离。

默认素材先查相邻 `media/`，再查相邻 `Quadra Grain Support/media/`。这只回退素材路径，不自动把 support 中的所有脚本加入 Max 搜索路径。Gen 和 JS 仍需可解析依赖。

## 12. 验证与可复现性

开发测试 `tools/build_final_test.py` 给主补丁添加 `sfrecord~ 5`：

| 通道 | 数据 | 还原 |
| --- | --- | --- |
| 1 / 2 | Freeze 后最终 L/R | 音频幅度 |
| 3 | 主 voice count × 0.015625 | 乘 64 |
| 4 | Regrain voice count × 0.03125 | 乘 32 |
| 5 | 阶段 marker | 0.1…0.6 |

测试依次执行播放、Freeze、停主层并静音素材、恢复主层并启反馈、静音素材观察反馈尾音、关闭 RUN / Feedback。

2026-09-19 留存的 V3 回归录音为 44.1 kHz、655,872 帧、五通道。Marker 0.3 的最终左右 RMS 约 0.00236 / 0.00273；marker 0.5 的 regrain 平均活动数约 0.881 voice。主 voice 遥测应乘 64，不能误用 32。

数据说明对应场景有有效音频与二次颗粒活动，未验证 Delay 的绝对时间精度、全部随机组合峰值、跨平台兼容性或实时 CPU 性能。

测试脚本与 `qgdiagnostics()` 包含开发机器绝对输出路径，移植前应调整。测试需要 Max DSP 开启，不是纯 Python 离线单元测试。

## 13. 扩展与维护

优先改进真实写指针同步、Feedback LFO 路由、输入捕获和最终总线增益。随后可增加 regrain 滤波、带限读取、双 buffer 替换、transport 同步及参数组合测试。

长期修改应同步到 `tools/build.py` 或 `tools/ui_source.js`。当前依赖为 `quadra_regrain_v3.gendsp`；旧 `quadra_regrain.gendsp` 和 Probe 不应混入发布包。
