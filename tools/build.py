from pathlib import Path
import json, math, wave, struct, random
ROOT=Path(__file__).resolve().parents[1]
# id, label, min, max, default, unit; ordered modulation destinations.
P=[('morphx','Morph X',0,1,.5,''),('morphy','Morph Y',0,1,.5,''),('size','Grain Size',5,1000,120,'ms'),('density','Density',.5,150,24,'Hz'),('amount','Grain Amount',1,64,32,''),('pitch','Pitch',-36,36,0,'st'),('position','Position',0,1,.25,''),('scan','Scan Speed',-1,1,.03,'cyc/s'),('spray','Position Jitter',0,1,.05,''),('sizej','Size Random',0,1,.1,''),('densityj','Density Random',0,1,.1,''),('pitchj','Pitch Jitter',0,24,0,'st'),('rate','Playback Rate',.125,4,1,'x'),('reverse','Reverse Prob',0,1,0,''),('shape','Envelope Shape',0,2,1,''),('bias','Attack Bias',.05,.95,.5,''),('pan','Pan',-1,1,0,''),('spread','Pan Spread',0,1,.25,''),('macro','Macro Randomness',0,1,0,''),('feedback','Feedback',0,.85,0,''),('fbdelay','Feedback Delay',50,2000,350,'ms'),('cutoff','Grain Cutoff',40,18000,10000,'Hz'),('resonance','Grain Q',.5,8,.707,''),('filterj','Filter Random',0,4,0,'oct')]
EX=[('run','Run',0,1,0,''),('freeze','Freeze',0,1,0,''),('filtermode','Filter Mode',0,3,1,''),('inputgain','Input Capture',0,1,0,''),('output','Output',-60,0,-15,'dB')]
for n in [1,2]: EX += [(f'lfo{n}rate',f'LFO {n} Rate',.01,20,.13 if n==1 else .07,'Hz'),(f'lfo{n}depth',f'LFO {n} Depth',0,1,0,''),(f'lfo{n}dest',f'LFO {n} Target',0,len(P),0,''),(f'lfo{n}shape',f'LFO {n} Shape',0,3,0,'')]
EX += [(f'{k}level',f'{k.upper()} Level',-70,6,0,'dB') for k in 'abcd']
EX += [(f'{k}{edge}',f'{k.upper()} {edge.title()}',0,1,de,'') for k in 'abcd' for edge,de in [('start',0),('end',1)]]
EX += [('fbsize','Regrain Size',.25,4,1,'x'),('fbdensity','Regrain Density',.25,4,1,'x'),('fbpitch','Regrain Pitch',-24,24,0,'st')]
ALL=P+EX
src='''// QUADRA GRAIN — sample-accurate scheduler, 64 non-stealing voices.
// Data channel layout: age,duration,start,speed,pan,shape,bias,g,k,mode,filter states, four source regions.
Buffer a; Buffer b; Buffer c; Buffer d;
Data voices(64,24);
History clocker(0); History scanphase(0); History cursor(0);
History mx(.5); History my(.5); History gain(0); History norm(1); History heldpos(.25);
History lfoph1(0); History lfoph2(0); History sh1(0); History sh2(0);
'''
for k,l,lo,hi,de,u in ALL: src+=f'Param {k}({de}, min={lo}, max={hi});\n'
for k in 'abcd':src+=f'Param sr{k}(44100);\nParam ready{k}(1);\nHistory level{k}(1);\n'
src+='''
lfoph1 = wrap(lfoph1+lfo1rate/samplerate,0,1);
lfoph2 = wrap(lfoph2+lfo2rate/samplerate,0,1);
sh1 = lfoph1 < lfo1rate/samplerate ? noise() : sh1;
sh2 = lfoph2 < lfo2rate/samplerate ? noise() : sh2;
lv1 = lfo1shape < .5 ? sin(lfoph1*twopi) : (lfo1shape < 1.5 ? 1-4*abs(lfoph1-.5) : (lfo1shape < 2.5 ? 2*lfoph1-1 : sh1));
lv2 = lfo2shape < .5 ? sin(lfoph2*twopi) : (lfo2shape < 1.5 ? 1-4*abs(lfoph2-.5) : (lfo2shape < 2.5 ? 2*lfoph2-1 : sh2));
'''
for i,(k,l,lo,hi,de,u) in enumerate(P,1):src+=f'v_{k} = clamp({k} + ((lfo1dest == {i})*lv1*lfo1depth + (lfo2dest == {i})*lv2*lfo2depth)*{(hi-lo)*.5}, {lo}, {hi});\n'
for k in 'abcd':src+=f'level{k} = level{k} + (({k}level <= -69.9 ? 0 : pow(10,{k}level/20))*ready{k}-level{k})*(1-exp(-1/(.01*samplerate)));\n'
src+='''
// Macro adds remaining headroom without overwriting the automatable base knobs.
jpos = v_spray+(1-v_spray)*v_macro;
jsize = v_sizej+(1-v_sizej)*v_macro;
jdens = v_densityj+(1-v_densityj)*v_macro;
jpitch = v_pitchj+(24-v_pitchj)*v_macro;
jpan = v_spread+(1-v_spread)*v_macro;
scanphase = wrap(scanphase+v_scan/samplerate,0,1);
heldpos = wrap(v_position+scanphase,0,1);
mx = mx+(v_morphx-mx)*(1-exp(-1/(.015*samplerate)));
my = my+(v_morphy-my)*(1-exp(-1/(.015*samplerate)));
wa=sqrt((1-mx)*my)*levela; wb=sqrt(mx*my)*levelb; wc=sqrt((1-mx)*(1-my))*levelc; wd=sqrt(mx*(1-my))*leveld;
clocker = clocker-1;
if (run > .5 && clocker <= 0) {
    slot=-1;
    for (j=0; j<64; j+=1) {
        idx=wrap(cursor+j,0,64);
        if (slot < 0 && idx < floor(v_amount) && peek(voices,idx,0) >= peek(voices,idx,1)) { slot=idx; }
    }
    if (slot >= 0) {
        dur=max(5,v_size*(1+noise()*jsize*.95))*.001*samplerate;
        spd=v_rate*pow(2,(v_pitch+noise()*jpitch)/12)*((noise()*.5+.5)<v_reverse ? -1 : 1);
        fc=clamp(v_cutoff*pow(2,noise()*v_filterj),20,min(20000,samplerate*.4));
        poke(voices,0,slot,0); poke(voices,dur,slot,1);
        poke(voices,wrap(heldpos+noise()*jpos*.5,0,1),slot,2);
        poke(voices,spd,slot,3); poke(voices,clamp(v_pan+noise()*jpan,-1,1),slot,4);
        poke(voices,v_shape,slot,5); poke(voices,v_bias,slot,6);
        poke(voices,tan(pi*fc/samplerate),slot,7); poke(voices,1/v_resonance,slot,8);
        poke(voices,filtermode,slot,9);
        for (z=12;z<16;z+=1) { poke(voices,0,slot,z); }
        poke(voices,min(astart,aend),slot,16); poke(voices,max(astart,aend),slot,17);
        poke(voices,min(bstart,bend),slot,18); poke(voices,max(bstart,bend),slot,19);
        poke(voices,min(cstart,cend),slot,20); poke(voices,max(cstart,cend),slot,21);
        poke(voices,min(dstart,dend),slot,22); poke(voices,max(dstart,dend),slot,23);
        cursor=wrap(slot+1,0,64);
    }
    clocker=max(1,samplerate/v_density*(1+noise()*jdens*.95));
}
if (run < .5) { clocker=0; }
sumL=0; sumR=0; active=0;
for (i=0; i<64; i+=1) {
    age=peek(voices,i,0); dur=peek(voices,i,1);
    if (age < dur && dur > 0) {
        active+=1;
        pos=peek(voices,i,2); speed=peek(voices,i,3);
        loa=min(peek(voices,i,16)*dim(a),max(0,dim(a)-2));
        lena=max(2,peek(voices,i,17)*dim(a)-loa);
        ia=loa+wrap(pos*lena+age*speed*sra/samplerate,0,lena);
        lob=min(peek(voices,i,18)*dim(b),max(0,dim(b)-2));
        lenb=max(2,peek(voices,i,19)*dim(b)-lob);
        ib=lob+wrap(pos*lenb+age*speed*srb/samplerate,0,lenb);
        loc=min(peek(voices,i,20)*dim(c),max(0,dim(c)-2));
        lenc=max(2,peek(voices,i,21)*dim(c)-loc);
        ic=loc+wrap(pos*lenc+age*speed*src/samplerate,0,lenc);
        lod=min(peek(voices,i,22)*dim(d),max(0,dim(d)-2));
        lend=max(2,peek(voices,i,23)*dim(d)-lod);
        idd=lod+wrap(pos*lend+age*speed*srd/samplerate,0,lend);
        al=mix(peek(a,floor(ia),0,boundmode="wrap"),peek(a,loa+wrap(floor(ia)+1-loa,0,lena),0,boundmode="wrap"),fract(ia)); ar=mix(peek(a,floor(ia),min(1,channels(a)-1),boundmode="wrap"),peek(a,loa+wrap(floor(ia)+1-loa,0,lena),min(1,channels(a)-1),boundmode="wrap"),fract(ia));
        bl=mix(peek(b,floor(ib),0,boundmode="wrap"),peek(b,lob+wrap(floor(ib)+1-lob,0,lenb),0,boundmode="wrap"),fract(ib)); br=mix(peek(b,floor(ib),min(1,channels(b)-1),boundmode="wrap"),peek(b,lob+wrap(floor(ib)+1-lob,0,lenb),min(1,channels(b)-1),boundmode="wrap"),fract(ib));
        cl=mix(peek(c,floor(ic),0,boundmode="wrap"),peek(c,loc+wrap(floor(ic)+1-loc,0,lenc),0,boundmode="wrap"),fract(ic)); cr=mix(peek(c,floor(ic),min(1,channels(c)-1),boundmode="wrap"),peek(c,loc+wrap(floor(ic)+1-loc,0,lenc),min(1,channels(c)-1),boundmode="wrap"),fract(ic));
        dl=mix(peek(d,floor(idd),0,boundmode="wrap"),peek(d,lod+wrap(floor(idd)+1-lod,0,lend),0,boundmode="wrap"),fract(idd)); dr=mix(peek(d,floor(idd),min(1,channels(d)-1),boundmode="wrap"),peek(d,lod+wrap(floor(idd)+1-lod,0,lend),min(1,channels(d)-1),boundmode="wrap"),fract(idd));
        sl=al*wa+bl*wb+cl*wc+dl*wd;
        sr=ar*wa+br*wb+cr*wc+dr*wd;
        g=peek(voices,i,7); k=peek(voices,i,8); mode=peek(voices,i,9);
        a1=1/(1+g*(g+k)); a2=g*a1; a3=g*a2;
        s1=peek(voices,i,12); s2=peek(voices,i,13); v3=sl-s2; bp=a1*s1+a2*v3; lp=s2+a2*s1+a3*v3;
        poke(voices,fixdenorm(2*bp-s1),i,12); poke(voices,fixdenorm(2*lp-s2),i,13);
        sl=mode<.5 ? sl : (mode<1.5 ? lp : (mode<2.5 ? bp : sl-k*bp-lp));
        s1=peek(voices,i,14); s2=peek(voices,i,15); v3=sr-s2; bp=a1*s1+a2*v3; lp=s2+a2*s1+a3*v3;
        poke(voices,fixdenorm(2*bp-s1),i,14); poke(voices,fixdenorm(2*lp-s2),i,15);
        sr=mode<.5 ? sr : (mode<1.5 ? lp : (mode<2.5 ? bp : sr-k*bp-lp));
        phase=age/max(1,dur-1); biasv=peek(voices,i,6); envshape=peek(voices,i,5);
        tri=clamp(phase<biasv ? phase/biasv : (1-phase)/(1-biasv),0,1);
        hann=.5-.5*cos(pi*tri); trap=min(1,tri*4);
        env=envshape<=1 ? mix(tri,hann,envshape) : mix(hann,trap,envshape-1);
        pv=peek(voices,i,4);
        sumL+=sl*env*cos((pv+1)*pi*.25); sumR+=sr*env*sin((pv+1)*pi*.25);
        poke(voices,age+1,i,0);
    }
}
norm=norm+(1/sqrt(max(1,active*.375))-norm)*.001;
wetL=tanh(sumL*norm); wetR=tanh(sumR*norm);
gain=gain+(pow(10,output/20)-gain)*(1-exp(-1/(.02*samplerate)));
out1=dcblock(wetL)*gain; out2=dcblock(wetR)*gain;
out3=active; out4=heldpos;
'''
(ROOT/'quadra_resample_engine.genexpr').write_text(src)
app={'major':9,'minor':1,'revision':3,'architecture':'arm64','modernui':1}
g={'fileversion':1,'appversion':app,'classnamespace':'dsp.gen','rect':[50,50,1000,750],'boxes':[],'lines':[]}
g['boxes'].append({'box':{'id':'code','maxclass':'codebox','numinlets':2,'numoutlets':4,'patching_rect':[150,80,800,550],'code':src}})
for n in [1,2]:
 g['boxes'].append({'box':{'id':f'in{n}','maxclass':'newobj','text':f'in {n}','patching_rect':[n*70,20,50,22]}});g['lines'].append({'patchline':{'source':[f'in{n}',0],'destination':['code',n-1]}})
for n in range(1,5):
 g['boxes'].append({'box':{'id':f'out{n}','maxclass':'newobj','text':f'out {n}','patching_rect':[n*90,670,55,22]}});g['lines'].append({'patchline':{'source':['code',n-1],'destination':[f'out{n}',0]}})
(ROOT/'quadra_resample_engine.gendsp').write_text(json.dumps({'patcher':g},indent=2))

# Feedback regranulator. It reads the external temporary buffer written by MSP record~.
regrain='''Buffer fbtemp;
Data voices2(32,7);
History clock2(0); History cursor2(0); History gain2(0); History norm2(1); History writephase2(0);
Param feedback(0,min=0,max=.85); Param fbdelay(350,min=50,max=2000);
Param fbsize(1,min=.25,max=4); Param fbdensity(1,min=.25,max=4); Param fbpitch(0,min=-24,max=24);
Param size(120,min=5,max=1000); Param density(24,min=.5,max=150); Param pitch(0,min=-36,max=36);
Param pitchj(0,min=0,max=24); Param sizej(.1,min=0,max=1); Param densityj(.1,min=0,max=1);
Param rate(1,min=.125,max=4); Param reverse(0,min=0,max=1); Param pan(0,min=-1,max=1); Param spread(.25,min=0,max=1);
Param shape(1,min=0,max=2); Param bias(.5,min=.05,max=.95); Param run(0,min=0,max=1);
ringlen2=max(2,dim(fbtemp)); writephase2=wrap(writephase2+1,0,ringlen2); clock2=clock2-1;
if(run>.5 && feedback>.0001 && clock2<=0 && ringlen2>2){
 slot2=-1;
 for(j=0;j<32;j+=1){idx2=wrap(cursor2+j,0,32);if(slot2 < 0 && peek(voices2,idx2,0) >= peek(voices2,idx2,1)){slot2=idx2;}}
 if(slot2>=0){
  dur2=clamp(size*fbsize*(1+noise()*sizej*.95),5,2000)*.001*samplerate;
  speed2=rate*pow(2,(pitch+fbpitch+noise()*pitchj)/12)*((noise()*.5+.5)<reverse?-1:1);
  lookback=clamp(fbdelay*.001*samplerate,32,ringlen2-2);
  poke(voices2,0,slot2,0);poke(voices2,dur2,slot2,1);poke(voices2,wrap(writephase2-lookback,0,ringlen2),slot2,2);
  poke(voices2,speed2,slot2,3);poke(voices2,clamp(pan+noise()*spread,-1,1),slot2,4);poke(voices2,bias,slot2,5);poke(voices2,shape,slot2,6);
  cursor2=wrap(slot2+1,0,32);
 }
 clock2=max(1,samplerate/(density*fbdensity)*(1+noise()*densityj*.95));
}
if(run<.5){clock2=0;}
sum2L=0;sum2R=0;active2=0;
for(i=0;i<32;i+=1){
 age2=peek(voices2,i,0);dur2=peek(voices2,i,1);
 if(age2<dur2 && dur2>0){
  active2=active2+1;phase2=age2/max(1,dur2-1);bias2=peek(voices2,i,5);shape2=peek(voices2,i,6);
  tri2=clamp(phase2<bias2?phase2/bias2:(1-phase2)/(1-bias2),0,1);hann2=.5-.5*cos(pi*tri2);env2=shape2<=1?mix(tri2,hann2,shape2):mix(hann2,min(1,tri2*4),shape2-1);
  pos2=wrap(peek(voices2,i,2)+age2*peek(voices2,i,3),0,ringlen2);pan2=peek(voices2,i,4);
  frame2=floor(pos2);next2=wrap(frame2+1,0,ringlen2);frac2=fract(pos2);
  grain2L=mix(peek(fbtemp,frame2,0),peek(fbtemp,next2,0),frac2);
  grain2R=mix(peek(fbtemp,frame2,min(1,channels(fbtemp)-1)),peek(fbtemp,next2,min(1,channels(fbtemp)-1)),frac2);
  sum2L=sum2L+grain2L*env2*cos((pan2+1)*pi*.25);
  sum2R=sum2R+grain2R*env2*sin((pan2+1)*pi*.25);
  poke(voices2,age2+1,i,0);
 }
}
norm2=norm2+(1/sqrt(max(1,active2*.375))-norm2)*.001;gain2=gain2+(feedback-gain2)*(1-exp(-1/(samplerate*.02)));
out1=tanh(sum2L*norm2)*gain2;out2=tanh(sum2R*norm2)*gain2;out3=active2;'''
rg={'fileversion':1,'appversion':app,'classnamespace':'dsp.gen','rect':[60,60,900,650],'boxes':[],'lines':[]}
rg['boxes'].append({'box':{'id':'code','maxclass':'codebox','numinlets':0,'numoutlets':3,'patching_rect':[120,60,720,500],'code':regrain}})
for n in range(1,4):rg['boxes'].append({'box':{'id':f'out{n}','maxclass':'newobj','text':f'out {n}','patching_rect':[n*90,590,50,22]}});rg['lines'].append({'patchline':{'source':['code',n-1],'destination':[f'out{n}',0]}})
(ROOT/'quadra_regrain_v3.gendsp').write_text(json.dumps({'patcher':rg},indent=2))

# Final audio-layer freeze, placed after primary and feedback granular layers are mixed.
freeze_src='''Data capture(131072,2);
History head(0);History filled(0);History start(0);History length(1);History phase(0);History previous(0);History blend(0);
Param freeze(0,min=0,max=1); cap=min(131072,floor(samplerate*.25));
if(freeze>.5 && previous<.5){length=max(2,min(filled,cap));start=wrap(head-length,0,cap);phase=0;}
previous=freeze;blend=clamp(blend+(freeze>.5?1:-1)/(samplerate*.02),0,1);
if(freeze<.5 && blend==0){poke(capture,in1,head,0);poke(capture,in2,head,1);head=wrap(head+1,0,cap);filled=min(cap,filled+1);}
p1=wrap(phase,0,length);p2=wrap(phase+length*.5,0,length);w1=.5-.5*cos(twopi*p1/length);w2=1-w1;
r1=wrap(start+p1,0,cap);r2=wrap(start+p2,0,cap);
f1L=mix(peek(capture,floor(r1),0),peek(capture,wrap(floor(r1)+1,0,cap),0),fract(r1));
f2L=mix(peek(capture,floor(r2),0),peek(capture,wrap(floor(r2)+1,0,cap),0),fract(r2));
f1R=mix(peek(capture,floor(r1),1),peek(capture,wrap(floor(r1)+1,0,cap),1),fract(r1));
f2R=mix(peek(capture,floor(r2),1),peek(capture,wrap(floor(r2)+1,0,cap),1),fract(r2));
phase=wrap(phase+1,0,length);out1=mix(in1,f1L*w1+f2L*w2,blend);out2=mix(in2,f1R*w1+f2R*w2,blend);'''
fg={'fileversion':1,'appversion':app,'classnamespace':'dsp.gen','rect':[60,60,800,580],'boxes':[],'lines':[]}
fg['boxes'].append({'box':{'id':'code','maxclass':'codebox','numinlets':2,'numoutlets':2,'patching_rect':[130,60,620,430],'code':freeze_src}})
for n in [1,2]:fg['boxes'].append({'box':{'id':f'in{n}','maxclass':'newobj','text':f'in {n}','patching_rect':[n*70,20,45,22]}});fg['lines'].append({'patchline':{'source':[f'in{n}',0],'destination':['code',n-1]}})
for n in [1,2]:fg['boxes'].append({'box':{'id':f'out{n}','maxclass':'newobj','text':f'out {n}','patching_rect':[n*90,520,50,22]}});fg['lines'].append({'patchline':{'source':['code',n-1],'destination':[f'out{n}',0]}})
(ROOT/'quadra_audio_freeze.gendsp').write_text(json.dumps({'patcher':fg},indent=2))
# Create original stereo examples. They are optional starter samples, never copyrighted recordings.
rng=random.Random(72)
for n,name in enumerate(['A_Glass','B_Reed','C_Dust','D_Chord']):
 with wave.open(str(ROOT/'media'/f'{name}.wav'),'wb') as w:
  w.setparams((2,2,44100,0,'NONE','not compressed')); data=bytearray()
  for i in range(44100*4):
   t=i/44100; pair=[]
   for ch in range(2):
    if n==0: v=sum(math.sin(2*math.pi*f*t+ch*.15)*math.exp(-((t%(1.0+ch*.03)))*5)/(j+1) for j,f in enumerate([220,553,921,1403]))*.32
    elif n==1:v=sum(math.sin(2*math.pi*110*(j*2+1)*t+ch*.1)/(j*2+1) for j in range(7))*.28*(.7+.3*math.sin(t*3))
    elif n==2:v=(rng.random()*2-1)*.42*(.12+.88*math.exp(-(t%.25)*35))
    else:v=sum(math.sin(2*math.pi*f*t*(1+ch*.0009)) for f in [130.81,164.81,196,246.94])*.13*(.7+.3*math.sin(t*2))
    pair.append(int(max(-1,min(1,v))*32767))
   data.extend(struct.pack('<hh',*pair))
  w.writeframes(data)
# Main patch: three pages fit Live's 169px device strip.
B=[]; L=[]; params={}; hiddenrow=250
C=[.055,.065,.085,1]; ink=[.85,.9,.94,1]; accent=[.34,.86,.75,1]
def box(id,cls,rect,**kw):
 d={'id':id,'maxclass':cls,'patching_rect':rect};d.update(kw);B.append({'box':d});return d
def link(a,o,b,i=0):L.append({'patchline':{'source':[a,o],'destination':[b,i]}})
def obj(id,text,ni=1,no=1):
 global hiddenrow
 d=box(id,'newobj',[20+(len(B)%6)*185,hiddenrow,180,22],text=text,numinlets=ni,numoutlets=no);hiddenrow+=25;return d
def vis(id,cls,rect,**kw):return box(id,cls,rect,presentation=1,presentation_rect=rect,**kw)
def label(id,text,x,y,w=140):return vis(id,'comment',[x,y,w,16],text=text,fontsize=9,textcolor=ink)
vis('background','panel',[0,0,1190,169],bgcolor=C,border=0,background=1)
label('brand','QUADRA / GRAIN',10,4,150)['fontsize']=12
label('sub','4-SOURCE GRANULAR',10,22,155)['textcolor']=accent
obj('engine','gen~ quadra_resample_engine @nocache 1',2,4)
obj('feedback_temp','buffer~ #0-regrain 4000 2 @embed 0',1,2)
obj('regrain_engine','gen~ quadra_regrain_v3 @nocache 1',1,3)
obj('regrain_send_l','send~ #0-rgl',1,0);obj('regrain_send_r','send~ #0-rgr',1,0)
obj('regrain_return_l','receive~ #0-rgl',0,1);obj('regrain_return_r','receive~ #0-rgr',0,1)
obj('feedback_sum_l','+~',2,1);obj('feedback_sum_r','+~',2,1)
obj('feedback_clip_l','clip~ -1. 1.',1,1);obj('feedback_clip_r','clip~ -1. 1.',1,1)
obj('feedback_record','record~ #0-regrain 2 @loop 1',4,1)
obj('feedback_record_on','loadmess 1',1,1);link('feedback_record_on',0,'feedback_record',0)
link('engine',0,'feedback_sum_l',0);link('engine',1,'feedback_sum_r',0)
link('regrain_engine',0,'regrain_send_l',0);link('regrain_engine',1,'regrain_send_r',0)
link('regrain_return_l',0,'feedback_sum_l',1);link('regrain_return_r',0,'feedback_sum_r',1)
link('feedback_sum_l',0,'feedback_clip_l',0);link('feedback_sum_r',0,'feedback_clip_r',0)
link('feedback_clip_l',0,'feedback_record',0);link('feedback_clip_r',0,'feedback_record',1)
obj('freeze_engine','gen~ quadra_audio_freeze @nocache 1',2,2)
link('feedback_sum_l',0,'freeze_engine',0);link('feedback_sum_r',0,'freeze_engine',1)
obj('controller','js quadra_resample_ui.js #0',1,2)
obj('audioin','plugin~',1,2);obj('audioout','plugout~',2,0)
link('audioin',0,'engine',0);link('audioin',1,'engine',1)
link('freeze_engine',0,'audioout',0);link('freeze_engine',1,'audioout',1)
obj('meters','snapshot~ 100',2,1);link('engine',2,'meters');obj('actmsg','prepend active');link('meters',0,'actmsg');link('actmsg',0,'controller')
obj('remeter','snapshot~ 100');link('regrain_engine',2,'remeter');obj('remsg','prepend revoices');link('remeter',0,'remsg');link('remsg',0,'controller')
obj('scanmeter','snapshot~ 100',2,1);link('engine',3,'scanmeter');obj('scmsg','prepend scanpos');link('scanmeter',0,'scmsg');link('scmsg',0,'controller')
link('controller',0,'engine')
obj('feedback_name_route','route fbtemp',1,2);obj('feedback_name_prepend','prepend fbtemp',1,1)
link('controller',0,'feedback_name_route',0);link('feedback_name_route',0,'feedback_name_prepend',0);link('feedback_name_prepend',0,'regrain_engine',0)
label('active','GRAINS 0 + 0',10,144,150)
# Morph pad always visible. Top=A/B, bottom=C/D; xy bridge goes through live.numbox.
vis('pad','pictslider',[170,24,122,122],leftvalue=0,rightvalue=1000,topvalue=1000,bottomvalue=0,parameter_enable=0,horizontaltracking=1.,verticaltracking=1.)
label('aCorner','A',172,6,20);label('bCorner','B',279,6,20);label('cCorner','C',172,148,20);label('dCorner','D',279,148,20)
obj('padx','prepend padx');obj('pady','prepend pady');link('pad',0,'padx');link('pad',1,'pady');link('padx',0,'controller');link('pady',0,'controller')
label('posread','SCAN 0.250',305,145,125)
# live parameter widget generator. UI page membership is saved separately.
pages={0:[],1:[],2:[],3:[]}
def widget(p,x,y,page=None,cls='live.dial',enum=None,w=64):
 k,name,lo,hi,de,u=p
 if cls=='live.dial':rect=[x,y,w,48]
 elif cls=='live.toggle':rect=[x,y,20,20]
 else:rect=[x,y,w,19]
 val={'parameter_longname':name,'parameter_shortname':('Randomness' if k=='macro' else name),'parameter_type':2 if enum else (1 if k in ['amount','run','freeze'] else 0),'parameter_mmin':lo,'parameter_mmax':hi,'parameter_initial':[de],'parameter_initial_enable':1,'parameter_unitstyle':({'ms':2,'Hz':3,'dB':4,'st':7}.get(u,9) if u else (0 if k=='amount' else 1)),'parameter_modmode':0 if enum or k in ['run','freeze','page'] else 2}
 if u:val['parameter_units']=u
 if enum:val.update(parameter_enum=enum,parameter_unitstyle=9)
 vis(k,cls,rect,varname=k,parameter_enable=1,numinlets=1,numoutlets=2 if cls in ['live.dial','live.numbox'] else (3 if cls=='live.menu' else 1),saved_attribute_attributes={'valueof':val},activebgcolor=accent,textcolor=ink,fontsize=9)
 if cls=='live.toggle':
  B[-1]['box'].update(activebgcolor=[.19,.23,.27,1],activebgoncolor=accent)
 params[k]=[name,name,0]
 obj(k+'_send','prepend '+k);link(k,0,k+'_send');link(k+'_send',0,'engine')
 if k in ['morphx','morphy']:
  obj(k+'_ui','prepend '+k);link(k,0,k+'_ui');link(k+'_ui',0,'controller')
 if page is not None:pages[page].append(k)
 return k
widget(P[0],305,43,cls='live.numbox',w=66);widget(P[1],305,82,cls='live.numbox',w=66)
label('xlab','MORPH X',305,26,80);label('ylab','MORPH Y',305,65,80)
widget(EX[0],10,49,cls='live.toggle');label('runlabel','RUN',35,50,42)
widget(EX[1],82,49,cls='live.toggle');label('frlabel','FREEZE',107,50,60)
widget(next(p for p in EX if p[0]=='output'),14,83,w=68)
widget(next(p for p in P if p[0]=='macro'),88,83,w=70)
# Page selector, device state retained via parameter system.
pageparam=('page','Panel',0,3,2,'')
widget(pageparam,401,5,cls='live.menu',enum=['GRAINS / MOTION','RANDOM / SPACE','SAMPLES / REGIONS','MODULATION'],w=191)
# page is UI-only (remove generated gen connection)
L[:]=[l for l in L if l['patchline']['source'][0]!='page_send'];link('page_send',0,'controller')
page0=['size','density','amount','pitch','position','scan','rate','reverse','shape','bias','cutoff','resonance','feedback','fbdelay']
page1=['spray','sizej','densityj','pitchj','pan','spread','filterj','inputgain','fbsize','fbdensity','fbpitch']
byid={p[0]:p for p in ALL}
for i,k in enumerate(page0):widget(byid[k],405+(i%7)*108,33+(i//7)*65,0,w=94)
for i,k in enumerate(page1):widget(byid[k],405+(i%7)*108,33+(i//7)*65,1,w=94)
widget(byid['filtermode'],947,5,cls='live.menu',enum=['Bypass','Lowpass','Bandpass','Highpass'],w=105)
label('filterlabel','PER-GRAIN FILTER',1060,7,126)
# Two LFO blocks on page 2; source loaders use persistent textedit paths.
for n in [1,2]:
 x=440+(n-1)*340
 for off,part in enumerate(['rate','depth']):widget(byid[f'lfo{n}{part}'],x+off*110,29,3,w=100)
 widget(byid[f'lfo{n}dest'],x,92,3,cls='live.menu',enum=['Off']+[p[1] for p in P],w=163)
 widget(byid[f'lfo{n}shape'],x,119,3,cls='live.menu',enum=['Sine','Triangle','Ramp','S&H'],w=163)
obj('wave_router','route a b c d',1,5);link('controller',1,'wave_router')
for i,k in enumerate('abcd'):
 x=405+(i%2)*390;y=29+(i//2)*69
 drop='drop_'+k
 vis(drop,'live.drop',[x,y,66,60],varname=drop,legend=k.upper()+' / DROP',parameter_enable=1,numinlets=1,numoutlets=2,decodemode=1,textcolor=accent,bordercolor=[.25,.4,.43,1],saved_attribute_attributes={'valueof':{'parameter_longname':k.upper()+' Sample','parameter_shortname':k.upper()+' Sample','parameter_type':4,'parameter_invisible':1}})
 pages[2].append(drop);params[drop]=[k.upper()+' Sample',k.upper()+' Sample',0]
 obj('dropsend_'+k,'prepend path '+k);link(drop,0,'dropsend_'+k);link('dropsend_'+k,0,'controller')
 vis('wave_'+k,'waveform~',[x+71,y,238,37],varname='wave_'+k,buffername='#0-'+k,setmode=1,outmode=3,allowdrag=0,numinlets=5,numoutlets=6,bgcolor=[.08,.12,.15,1],waveformcolor=accent,selectioncolor=[.48,.65,1,1],selectalpha=.3)
 pages[2].append('wave_'+k)
 obj('select_'+k,'prepend selection '+k);link('wave_'+k,5,'select_'+k);link('select_'+k,0,'controller')
 widget(byid[k+'level'],x+316,y+3,2,w=64)
 for offset,edge in enumerate(['start','end']):
  lab='label_'+k+edge;label(lab,'IN' if edge=='start' else 'OUT',x+71+offset*123,y+42,29);pages[2].append(lab)
  widget(byid[k+edge],x+101+offset*123,y+40,2,cls='live.numbox',w=81)
  obj('region_'+k+edge,'prepend region '+k+' '+edge);link(k+edge,0,'region_'+k+edge);link('region_'+k+edge,0,'controller')
 obj('buffer_'+k,'buffer~ @embed 0',1,2);obj('info_'+k,'info~',1,10);link('buffer_'+k,1,'info_'+k)
 obj('sr_'+k,'prepend sr'+k);link('info_'+k,0,'sr_'+k);link('sr_'+k,0,'engine')
 obj('loaded_'+k,'prepend loaded '+k);link('info_'+k,7,'loaded_'+k);link('loaded_'+k,0,'controller')
 obj('duration_'+k,'prepend duration '+k);link('info_'+k,6,'duration_'+k);link('duration_'+k,0,'controller')
 # JS sends selection display updates to waveform's link inlet (no data edits).
 link('wave_router',i,'wave_'+k,4)
obj('init','loadbang');obj('delayinit','deferlow');link('init',0,'delayinit');link('delayinit',0,'controller')
obj('liveinit','live.thisdevice',1,3);link('liveinit',0,'delayinit')
obj('savestate','autopattr @autorestore 1');obj('device','live.banks',1,2)
# Route only the controls understood by the secondary granular and final freeze engines.
for k in ['feedback','fbdelay','fbsize','fbdensity','fbpitch','size','density','pitch','pitchj','sizej','densityj','rate','reverse','pan','spread','shape','bias','run']:
 link(k+'_send',0,'regrain_engine',0)
link('freeze_send',0,'freeze_engine',0)
# Generic bank metadata for supported host control surfaces.
parameters={**params,'parameterbanks':{str(i):{'index':i,'name':name,'parameters':ks+['-']*(8-len(ks))} for i,(name,ks) in enumerate([('Grain',['size','density','amount','pitch','position','scan','rate','reverse']),('Random',['macro','spray','pitchj','sizej','densityj','spread','pan','freeze']),('Tone',['shape','bias','cutoff','resonance','filtermode','filterj','feedback','fbdelay']),('Morph',['morphx','morphy','output','run','lfo1rate','lfo1depth','lfo2rate','lfo2depth'])])},'inherited_shortname':1}
patch={'fileversion':1,'appversion':app,'classnamespace':'box','rect':[40,80,1190,210],'openinpresentation':1,'devicewidth':1190,'bgcolor':C,'editing_bgcolor':[.14,.16,.19,1],'default_fontname':'Arial','default_fontsize':11,'boxes':B,'lines':L,'parameters':parameters,'dependency_cache':[{'name':'quadra_resample_engine.gendsp','type':'gDSP','implicit':1},{'name':'quadra_regrain_v3.gendsp','type':'gDSP','implicit':1},{'name':'quadra_audio_freeze.gendsp','type':'gDSP','implicit':1},{'name':'quadra_resample_ui.js','type':'TEXT','implicit':1}]}
(ROOT/'Quadra_Grain_V2.maxpat').write_text(json.dumps({'patcher':patch},indent=2))
(ROOT/'tools'/'parameters.json').write_text(json.dumps(ALL,indent=2))
# Inline page inventory for deterministic UI switching.
ui=(ROOT/'tools'/'ui_source.js').read_text().replace('PAGEJSON',json.dumps(pages))
# getnamed requires varname for every scripted box.
for wrapped in B:
 d=wrapped['box'];d.setdefault('varname',d['id'])
for k in 'abcd':
 obj('fullpath_'+k,'prepend fullpath '+k);link('info_'+k,9,'fullpath_'+k);link('fullpath_'+k,0,'controller')
for wrapped in B:
 if wrapped['box']['id'] in pages[0]+pages[1]+pages[3]: wrapped['box']['hidden']=1
(ROOT/'Quadra_Grain_V2.maxpat').write_text(json.dumps({'patcher':patch},indent=2))
(ROOT/'quadra_resample_ui.js').write_text(ui)
print('Built Quadra_Grain_V2.maxpat, engine, UI and four original samples')
