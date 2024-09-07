
(
/////control
{Out.ar(0,LFPulse.ar(freq: 440.0, iphase: 0.0, width: 0.5, mul: 1.0, add: 0))}.play
)

////8channels means 8 stepper motors or 4 if the half 4 are used as direction pins


////constant 5v can be given with wavetable osc
/////wavetables
Buffer.freeAll
~w= Buffer.alloc(s,2048);

(
var env,sig,wt;

env = Env([1,1],[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w.loadCollection(wt);
sig.plot;
)

(
///direction/needs constant +5V or constant GND
{Out.ar(1,Osc.ar(~w,freq:440,mul:1.0,phase:0.0))}.play
)