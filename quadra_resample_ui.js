autowatch=1; inlets=1; outlets=2;
var uid='qv2_'+new Date().getTime()+'_'+Math.floor(Math.random()*1000000),ready=false,x=.5,y=.5;
var pages={"0": ["size", "density", "amount", "pitch", "position", "scan", "rate", "reverse", "shape", "bias", "cutoff", "resonance", "feedback", "fbdelay"], "1": ["spray", "sizej", "densityj", "pitchj", "pan", "spread", "filterj", "inputgain", "fbsize", "fbdensity", "fbpitch"], "2": ["drop_a", "wave_a", "alevel", "label_astart", "astart", "label_aend", "aend", "drop_b", "wave_b", "blevel", "label_bstart", "bstart", "label_bend", "bend", "drop_c", "wave_c", "clevel", "label_cstart", "cstart", "label_cend", "cend", "drop_d", "wave_d", "dlevel", "label_dstart", "dstart", "label_dend", "dend"], "3": ["lfo1rate", "lfo1depth", "lfo1dest", "lfo1shape", "lfo2rate", "lfo2depth", "lfo2dest", "lfo2shape"]}, lengths={}, guard=false, got={}, jobs={}, pending={}, initializing=true, initjob=null, donejob=null, debugstate={};
var defaults=['A_Glass','B_Reed','C_Dust','D_Chord'];
function named(k){return this.patcher.getnamed(k);}
function readable(p){var f=new File(p,'read');var ok=f.isopen;if(ok)f.close();return ok;}
function defaultsample(base,name){
 var local=base+'media/'+name+'.wav';
 var support=base+'Quadra Grain Support/media/'+name+'.wav';
 return readable(local)?local:(readable(support)?support:local);
}
function value(k){var v=named(k).getvalueof();return Number(v instanceof Array?v[0]:v);}
function page(v){for(var p=0;p<4;p++)for(var i=0;i<pages[p].length;i++)named(pages[p][i]).hidden=(p!=Math.round(v));}
function updatepad(){named('pad').message('set',Math.round(x*1000),Math.round(y*1000));}
function morphx(v){x=v;updatepad();} function morphy(v){y=v;updatepad();}
function padx(v){named('morphx').message(v/1000);} function pady(v){named('morphy').message(v/1000);}
var voices1=0,voices2=0;
function counts(){named('active').message('set','GRAINS '+voices1+' + '+voices2);}
function active(v){voices1=Math.round(v);counts();}
function revoices(v){voices2=Math.round(v);counts();}
function scanpos(v){named('posread').message('set','SCAN '+Number(v).toFixed(3));}
function display(k){if(!lengths[k])return;guard=true;outlet(1,k,0,lengths[k],value(k+'start')*lengths[k],value(k+'end')*lengths[k]);guard=false;}
function region(k,edge,v){if(!guard)display(k);}
function selection(k,start,length,selstart,selend){
 if(guard||!lengths[k])return;
 var a=Math.max(0,Math.min(1,Math.min(selstart,selend)/lengths[k]));
 var b=Math.max(0,Math.min(1,Math.max(selstart,selend)/lengths[k]));
 if(b-a<.00001)return;
 guard=true;named(k+'start').message(a);named(k+'end').message(b);guard=false;
}
function path(k){debugstate[k+"_args"]=arrayfromargs(arguments);
 var args=arrayfromargs(arguments).slice(1);if(args[0]=='text'||args[0]=='symbol'||args[0]=='list')args.shift();var s=args.join(' ').replace(/^\s+|\s+$/g,'');
 if(s.charAt(0)=='"'&&s.charAt(s.length-1)=='"')s=s.substring(1,s.length-1);
 if(!s||s=='none')return;got[k]=true;
 if(jobs[k])jobs[k].cancel();outlet(0,'ready'+k,0);pending[k]=true;
 var reset=!initializing;
 jobs[k]=new Task(function(){
  if(reset){guard=true;named(k+'start').message(0);named(k+'end').message(1);guard=false;}
  named('buffer_'+k).message('replace',s);
 },this);jobs[k].schedule(50);
}
function duration(k,ms){lengths[k]=Number(ms);display(k);}
function loaded(k){named('wave_'+k).message('set',uid+'-'+k);pending[k]=false;outlet(0,'ready'+k,1);display(k);}
function fullpath(k){var s=arrayfromargs(arguments).slice(1).join(' ');named('wave_'+k).message('annotation',s+' | drag to select region');}
function bang(){
 for(var i=0;i<4;i++){var k='abcd'.charAt(i);if(!ready){named('buffer_'+k).message('set',uid+'-'+k);named('info_'+k).message('set',uid+'-'+k);named('wave_'+k).message('set',uid+'-'+k);}outlet(0,k,uid+'-'+k);}
 if(!ready){
  named('feedback_temp').message('set',uid+'-regrain');
  named('feedback_temp').message('sizeinsamps',524288);
  named('feedback_record').message('set',uid+'-regrain');
  outlet(0,'fbtemp',uid+'-regrain');
 }
 page(value('page'));updatepad();
 if(ready)return;ready=true;
 for(var i=0;i<4;i++)named('drop_'+'abcd'.charAt(i)).message('bang');
 initjob=new Task(function(){try{debugstate.task=true;
  var base=this.patcher.filepath; base=base.substring(0,base.lastIndexOf('/')+1);if(base.indexOf(':/')>0)base=base.substring(base.indexOf(':/')+1);
  debugstate.base=base;debugstate.got=got;for(var i=0;i<4;i++){var k='abcd'.charAt(i);if(!got[k]){debugstate[k]=defaultsample(base,defaults[i]);named('drop_'+k).message('set',debugstate[k]);named('drop_'+k).message('bang');}}
  donejob=new Task(function(){initializing=false;},this);donejob.schedule(300);
 }catch(e){debugstate.error=String(e);}},this);initjob.schedule(100);
}

function qgdiagnostics(){var f=new File('/Users/lingyuanyang/Documents/ChatGPT/MaxMSP/Quadra_Grain_V2/validation/init_report.json','write','TEXT');f.eof=0;f.writestring(JSON.stringify(debugstate));f.close();}
