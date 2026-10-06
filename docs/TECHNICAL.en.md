# Quadra / Grain V2 — Technical Documentation

[English](TECHNICAL.en.md) | [简体中文](TECHNICAL.md)

This document describes the current main patch, three `.gendsp` engines, `quadra_resample_ui.js`, and generator. Parameter ranges refer to base UI / Gen values; internal randomization and combined operations can produce different effective ranges.

[Back to the project overview](../README.md)

## 1. System layers

| Layer | Implementation | Responsibility |
| --- | --- | --- |
| Host UI | `live.dial`, `live.numbox`, `live.toggle`, `live.menu`, `live.drop` | Parameters, automation entry points, file-path state |
| Samples and pages | Max `js` | Naming, loading, region conversion, pad synchronization, status displays |
| Primary DSP | `quadra_resample_engine.gendsp` | 64 voices, four-source reading, filtering, envelopes, mixing |
| Feedback DSP | `quadra_regrain_v3.gendsp` | 32 regrain voices reading the temporary buffer |
| Freeze DSP | `quadra_audio_freeze.gendsp` | Capturing and looping the final mix |
| MSP routing | `record~`, `clip~`, `send~`, `receive~`, `plugout~` | Recording, feedback return, host output |

Scheduling and per-grain processing execute sample by sample in Gen. JavaScript handles control and UI tasks rather than sample-by-sample synthesis. Both voice counts and the scan position update the UI through `snapshot~ 100`, approximately every 100 ms.

## 2. Four-source morphing

Normalized coordinates are `x,y∈[0,1]`. A / B occupy the upper corners, and C / D occupy the lower corners:

| Corner | Coordinates | Weight |
| --- | --- | --- |
| A | `(0,1)` | `sqrt((1−x)y) × levelA` |
| B | `(1,1)` | `sqrt(xy) × levelB` |
| C | `(0,0)` | `sqrt((1−x)(1−y)) × levelC` |
| D | `(1,0)` | `sqrt(x(1−y)) × levelD` |

With all Levels at 0 dB, the squared weights sum to 1. At the center, each weight is 0.5. This provides a constant-power relationship for uncorrelated material, but cannot guarantee constant combined peaks or loudness for correlated sources.

Every active grain reads A–D and computes weighted sums for both channels:

```text
grainL = AL·wA + BL·wB + CL·wC + DL·wD
grainR = AR·wA + BR·wB + CR·wC + DR·wD
```

Morph weights are applied continuously during rendering rather than latched at grain onset. X / Y use approximately 15 ms first-order smoothing, and source Levels use approximately 10 ms smoothing.

JavaScript converts the `pictslider` coordinates from 0–1000 to 0–1 and updates the `live.numbox` controls. Morph X / Y are the host automation parameters; the pad itself has `parameter_enable=0`.

## 3. Primary scheduling and voice pool

The primary engine uses `Data voices(64,24)`. A counter decrements each sample. When RUN is enabled and the counter expires, the engine searches idle slots in round-robin order. A voice is idle when `age >= duration`, and its index must be below `floor(Grain Amount)`.

Active grains are never stolen. If every eligible slot is busy, the current trigger is skipped and the scheduling counter is still reset. Amount limits allocatable voices; it does not guarantee that many simultaneous grains. In steady operation without randomness:

```text
approximate overlapping voices ≈ Density[Hz] × Grain Size[ms] / 1000
```

After Amount is reduced, existing grains in higher-numbered slots finish naturally. Disabling RUN prevents new triggers while existing grains complete their envelopes.

### Voice data layout

| Data channel | Contents |
| --- | --- |
| 0 / 1 | Age / duration, in output sample frames |
| 2 / 3 | Normalized start position / signed read speed |
| 4 | Pan, −1…1 |
| 5 / 6 | Envelope shape / attack bias |
| 7 / 8 / 9 | Filter coefficients g / k / mode |
| 10 / 11 | Unused reserved channels |
| 12–15 | Two filter state values per stereo channel |
| 16–23 | Start and end boundaries for A–D |

Latched at onset: duration, start position, speed, direction, pan, envelope, filter coefficients, filter mode, and four source regions. Applied continuously: morph weights, source Levels, current buffer contents, and primary Output gain.

### Trigger and randomization formulas

Here, `r` is one random value from `noise()` in −1…1. Separate calls draw separate values. `Fs` is the output sample rate.

```text
durationSamples = max(5, size × (1+r×sizeJitter×0.95)) × Fs/1000
triggerInterval = max(1, Fs/density × (1+r×densityJitter×0.95))
startNormalized = wrap(position + scanPhase + r×positionJitter×0.5)
speed = rate × 2^((pitch+r×pitchJitter)/12) × direction
panPerGrain = clamp(pan+r×panSpread, −1, 1)
```

Direction is +1 or −1 according to a random draw compared with Reverse Probability. Randomized duration has only a 5 ms lower bound, so actual primary grains can exceed the UI's 1000 ms upper limit. Density Randomness varies the interval; the resulting reciprocal instantaneous frequency distribution is not symmetric.

## 4. Sample reading, regions, and scanning

JavaScript divides waveform selection times in milliseconds by the sample duration to obtain normalized IN / OUT values. At onset, Gen sorts the endpoints and converts them to each buffer's frame interval:

```text
regionStart = min(IN,OUT) × bufferFrames
regionLength ≈ (max(IN,OUT)−min(IN,OUT)) × bufferFrames
readIndex = regionStart + wrap(
    startNormalized×regionLength
    + age×speed×sourceSampleRate/outputSampleRate,
    0, regionLength
)
```

The implementation protects the start boundary and enforces a minimum read length of two frames. Forward and reverse indexes wrap within the selected region. Reading uses linear interpolation between adjacent frames, with the neighboring frame also wrapped to the region.

`info~` sends the four source sample rates to `sra/srb/src/srd` for read-step compensation. Mono sources reuse channel 0 for the right output; multichannel files use only the first two channels. Linear interpolation does not guarantee band-limited resampling at high playback ratios.

The four sources share a normalized start position but can have different region lengths. Events and cycles are not automatically aligned.

Scanning runs every sample:

```text
scanPhase[n+1] = wrap(scanPhase[n] + ScanSpeed/Fs)
scanPosition = wrap(Position + scanPhase)
```

Scan Speed is measured in normalized region cycles per second. Scanning continues with RUN disabled or Freeze enabled. SCAN displays Position plus the current scan phase, wrapped to 0–1.

### Sample replacement

The control path is `live.drop → prepend path <slot> → JS`:

1. Remove message-type prefixes and paired quotation marks; retain spaces in paths; ignore empty values and `none`.
2. Set `ready<slot>=0`, attenuating the slot through source-gain smoothing.
3. Cancel the slot's pending Task and schedule `buffer~ replace` after 50 ms.
4. Outside initialization, reset IN / OUT to 0 / 1.
5. On load completion, rebind the waveform, restore readiness, and refresh the displayed selection.

This does not use a double-buffer swap. Existing grains read the replacement buffer, so click-free replacement is not guaranteed for every source.

## 5. Macro Randomness and LFOs

### Macro

`M∈[0,1]` moves each base randomization value toward its maximum:

```text
effective = base + (maximum−base) × M
```

| Destination | Maximum |
| --- | --- |
| Position Jitter | 1 |
| Grain Size Jitter | 1 |
| Density Jitter | 1 |
| Pitch Jitter | 24 semitones |
| Pan Spread | 1 |

The five base controls are not overwritten. The primary engine calculates LFO-modulated base values first, then applies Macro. Regrain does not perform this Macro calculation.

### LFOs

The two LFOs have independent phases and provide Sine, Triangle, rising Ramp, and S&H updated once per cycle. Rate is 0.01–20 Hz, and Depth is 0–1. For a selected primary-engine parameter:

```text
effectiveP = clamp(
    baseP + (selectedLFO1×depth1 + selectedLFO2×depth2) × (maxP−minP)/2,
    minP, maxP
)
```

When both LFOs target the same parameter, their contributions add and are clipped at its boundaries. LFOs continue independently of RUN and Freeze, with no transport synchronization or phase reset.

The menu contains 24 destinations, from Morph X / Y through Filter Random. Calculated Feedback / Feedback Delay values are not forwarded to regrain, so those two internal destinations currently have no effect. Direct host changes to the corresponding controls still reach regrain through the message routing.

## 6. Envelopes, panning, and filtering

### Envelope

Let `u=age/max(1,duration−1)` and Bias `b∈[0.05,0.95]`:

```text
triangle = clamp(u<b ? u/b : (1−u)/(1−b), 0, 1)
hann = 0.5−0.5×cos(π×triangle)
trapezoid = min(1, triangle×4)
```

Shape 0…1 interpolates between triangle and hann; 1…2 interpolates between hann and trapezoid. Shape=1 and Bias=0.5 produce a conventional symmetric Hann envelope. Lower Bias gives a shorter attack and longer decay. It controls peak placement rather than independent millisecond ADSR stages.

### Panning

```text
leftGain  = cos((pan+1)×π/4)
rightGain = sin((pan+1)×π/4)
```

For stereo input, this independently weights the two channels. It does not cross-route right-channel content into the left channel and is not a stereo-width algorithm.

### Per-grain filter

Each primary grain has a TPT state-variable filter with separate left and right states. At onset:

```text
fc = clamp(cutoff×2^(r×filterRandom), 20, min(20000, Fs×0.4))
g = tan(π×fc/Fs)
k = 1/Q
a1 = 1/(1+g×(g+k))
a2 = g×a1
a3 = g×a2
```

Modes are Bypass, Lowpass, Bandpass, and Highpass. Filter states use `fixdenorm`. Filtering occurs after the grain's four-source mix and before its envelope and stereo gain stage. Filter Random is measured in octaves.

This is time-domain filtering, without FFT processing, per-bin masks, or spectral freeze. Regrain does not contain the same filter stage.

## 7. Mixing and gain

Both layers use approximate energy compensation based on their active voice count:

```text
target = 1/sqrt(max(1, activeVoices×0.375))
normalization += (target−normalization)×0.001
```

This is not precise loudness normalization. The fixed per-sample coefficient 0.001 produces a response time that changes with sample rate.

- Primary: `sum → normalization → tanh → dcblock → Output gain`.
- Regrain: `sum → normalization → tanh → Feedback gain`.

Both gain controls use approximately 20 ms smoothing. A source Level of −70 dB is treated as silence; other values convert to `10^(dB/20)`. Output at −60 dB still has finite gain.

## 8. Temporary buffer and recursive regranulation

The recording path is:

```text
primary + delayedRegrain → clip(−1,1) → record~ → temporary stereo buffer
```

`record~ @loop 1` starts during initialization. JavaScript sets the temporary buffer to **524,288 frames and two channels**, overriding its initial 4000 ms object configuration.

| Sample rate | Buffer duration |
| --- | --- |
| 44.1 kHz | Approximately 11.89 s |
| 48 kHz | Approximately 10.92 s |
| 96 kHz | Approximately 5.46 s |

Instance-local `send~ / receive~` objects provide a signal-vector delay in the feedback return, avoiding a zero-delay recursive DSP graph.

Regrain uses `Data voices2(32,7)`: age, duration, start, speed, pan, bias, and shape. It allocates idle voices without stealing. Its fixed 32-voice limit is not controlled by Grain Amount.

```text
regrainSize = clamp(size×fbsize×(1+r×sizej×0.95), 5, 2000) ms
regrainInterval = max(1, Fs/(density×fbdensity) × (1+r×densityj×0.95))
regrainSpeed = rate×2^((pitch+fbpitch+r×pitchj)/12)×direction
nominalStart = wrap(internalWritePhase−fbdelay×Fs/1000)
```

The layer uses shared controls' base values with additional `fbsize/fbdensity/fbpitch`. Triggering requires RUN enabled, Feedback>0.0001, and a buffer length greater than two frames.

V3 increments its internal `History writephase2` every sample and does not connect to the `record~` sync output. Read/write phase reset synchronization remains an area for improvement, and Delay is nominal. Read indexes wrap over the entire temporary buffer, using linear interpolation.

Feedback controls the regrain return gain. The returned audio is recorded again, producing recursive regranulation. This layer does not inherit primary Position Spray, Macro, internal LFO modulation, or per-grain filtering. The temporary recording is not written to disk.

## 9. Audio Freeze

Freeze follows the combined granular layers and uses `Data capture(131072,2)`:

```text
captureFrames = min(131072, floor(Fs×0.25))
```

With Freeze disabled and its transition complete, the engine continuously records into the capture ring. An enabling edge latches the captured length and start. If less than 250 ms has accumulated, only the filled portion is used.

```text
p1 = wrap(phase, 0, length)
p2 = wrap(phase+length/2, 0, length)
w1 = 0.5−0.5×cos(2π×p1/length)
w2 = 1−w1
frozen = read(p1)×w1 + read(p2)×w2
output = mix(liveInput, frozen, freezeBlend)
```

`freezeBlend` transitions linearly over approximately 20 ms. Freeze stops capture writes while the primary engine, scanner, regrain engine, and feedback recording can continue. Unfreezing returns to the current background audio.

The dual windows reduce boundary discontinuities, but summing two half-cycle-offset reads changes the texture. This is not a bit-identical repeat of the original segment, spectral freeze, or a single-sample hold.

## 10. Parameter reference

| Name / ID | Base range | Default | Meaning |
| --- | --- | --- | --- |
| Morph X / `morphx` | 0–1 | 0.5 | Left to right |
| Morph Y / `morphy` | 0–1 | 0.5 | Bottom to top |
| Grain Size / `size` | 5–1000 ms | 120 | Base duration |
| Density / `density` | 0.5–150 Hz | 24 | Trigger rate |
| Grain Amount / `amount` | 1–64 | 32 | Primary voice limit |
| Pitch / `pitch` | −36…36 st | 0 | Pitch exponent |
| Position / `position` | 0–1 | 0.25 | Scan offset |
| Scan Speed / `scan` | −1…1 cyc/s | 0.03 | Region cycles per second |
| Position Jitter / `spray` | 0–1 | 0.05 | Start-position variation |
| Size Random / `sizej` | 0–1 | 0.1 | Relative duration variation |
| Density Random / `densityj` | 0–1 | 0.1 | Relative interval variation |
| Pitch Jitter / `pitchj` | 0–24 st | 0 | Symmetric pitch variation |
| Playback Rate / `rate` | 0.125–4× | 1 | Multiplies pitch-derived speed |
| Reverse Prob / `reverse` | 0–1 | 0 | Reverse probability |
| Envelope Shape / `shape` | 0–2 | 1 | Triangle → Hann → Trapezoid |
| Attack Bias / `bias` | 0.05–0.95 | 0.5 | Envelope peak placement |
| Pan / `pan` | −1…1 | 0 | Base stereo balance |
| Pan Spread / `spread` | 0–1 | 0.25 | Pan variation |
| Macro Randomness / `macro` | 0–1 | 0 | Five-destination macro |
| Grain Cutoff / `cutoff` | 40–18000 Hz | 10000 | Base cutoff |
| Grain Q / `resonance` | 0.5–8 | 0.707 | Filter Q |
| Filter Random / `filterj` | 0–4 oct | 0 | Cutoff variation |
| Feedback / `feedback` | 0–0.85 | 0 | Return gain |
| Feedback Delay / `fbdelay` | 50–2000 ms | 350 | Nominal lookback time |
| Regrain Size / `fbsize` | 0.25–4× | 1 | Size multiplier |
| Regrain Density / `fbdensity` | 0.25–4× | 1 | Density multiplier |
| Regrain Pitch / `fbpitch` | −24…24 st | 0 | Additional pitch offset |
| A–D Level / `<slot>level` | −70…6 dB | 0 | −70 is silent |
| IN / `<slot>start` | 0–1 | 0 | Region start |
| OUT / `<slot>end` | 0–1 | 1 | Region end |
| RUN / `run` | Off / On | Off | Trigger switch for both layers |
| Freeze / `freeze` | Off / On | Off | Audio capture freeze |
| Output / `output` | −60…0 dB | −15 | Primary gain |
| Filter Mode / `filtermode` | Four modes | Lowpass | Primary filtering |
| Input Capture / `inputgain` | 0–1 | 0 | Not implemented |
| LFO 1/2 Rate | 0.01–20 Hz | 0.13 / 0.07 | Free-running frequency |
| LFO 1/2 Depth | 0–1 | 0 / 0 | Unit depth spans half the parameter range |
| LFO 1/2 Target | Off + 24 targets | Off | See Section 5 limitations |
| LFO 1/2 Shape | Four waveforms | Sine | Primary LFO waveform |

## 11. Live parameters, state, and messages

Continuous controls use `parameter_enable=1` and `parameter_modmode=2`. Menus, RUN, Freeze, and the page selector disable continuous modulation mode. `live.drop` uses file parameter type 4 and stores its path as a hidden host parameter.

The four eight-parameter banks are Grain, Random, Tone, and Morph, together with `live.banks`. `autopattr @autorestore 1`, `live.thisdevice`, and `loadbang → deferlow` support state and initialization.

| Message | Receiver / effect |
| --- | --- |
| `size 120`, etc. | `prepend <id>` sends to Gen; shared controls also reach regrain |
| `a <bufferName>`, etc. | Bind the primary Gen's external Buffer references |
| `fbtemp <bufferName>` | Bind the regrain Buffer through `route fbtemp` |
| `path a <filePath>` | JavaScript schedules replacement for A |
| `selection a ...` | Convert waveform selection and update IN / OUT |
| `region a start <value>` | Refresh waveform display |
| `active <n>` / `revoices <n>` | Update layer voice counts |
| `scanpos <value>` | Update SCAN text |
| `page <index>` | Change objects' hidden attributes |

Controller outlet 0 carries Gen messages; outlet 1 carries waveform region messages. A `guard` prevents recursive updates between selections and number controls.

JavaScript creates a timestamp-and-random-suffix UID for the four source buffers and temporary buffer. Feedback buses use instance-local `#0` names, isolating resources across multiple device instances.

Default samples are searched first in adjacent `media/`, then in adjacent `Quadra Grain Support/media/`. This is an audio-path fallback and does not automatically add support scripts to Max's search path. Gen and JavaScript dependencies must remain resolvable.

## 12. Validation and reproducibility

The development helper `tools/build_final_test.py` adds `sfrecord~ 5` to the main patch:

| Channel | Data | Decoding |
| --- | --- | --- |
| 1 / 2 | Final L/R after Freeze | Audio amplitude |
| 3 | Primary voice count × 0.015625 | Multiply by 64 |
| 4 | Regrain voice count × 0.03125 | Multiply by 32 |
| 5 | Stage marker | 0.1…0.6 |

The sequence plays the primary layer, enables Freeze, stops primary triggering and mutes the source, restores playback with feedback, mutes the source to observe the feedback tail, and disables RUN / Feedback.

The archived V3 regression recording from 2026-09-19 contains 655,872 frames at 44.1 kHz with five channels. During marker 0.3, final L/R RMS values are approximately 0.00236 / 0.00273. During marker 0.5, average regrain activity is approximately 0.881 voices. Primary telemetry must be multiplied by 64, not 32.

These results demonstrate audio output and regrain activity in the tested scenarios. They do not establish absolute delay accuracy, peaks across all random combinations, cross-platform compatibility, or real-time CPU performance.

The test script and `qgdiagnostics()` contain absolute paths for the development machine; adjust them before running elsewhere. Tests require Max DSP to be enabled and are not Python-only offline unit tests.

## 13. Extensions and maintenance

Priority improvements include actual write-pointer synchronization, Feedback LFO routing, input capture, and final-bus gain. Further extensions could add regrain filtering, band-limited reads, double-buffer replacement, transport synchronization, and parameter-combination tests.

Apply persistent edits to `tools/build.py` or `tools/ui_source.js` as well. The current dependency is `quadra_regrain_v3.gendsp`; older `quadra_regrain.gendsp` and probe files should not be included in the release.
