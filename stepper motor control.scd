(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*32;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 4;
s.waitForBoot
)

////constant 5v can be given with wavetable osc
/////wavetables
Buffer.freeAll
(
(
~w= Buffer.alloc(s,2048);
);

(
var env,sig,wt;

env = Env([1,1],[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w.loadCollection(wt);
//sig.plot;
)
)

(
///direction/needs constant +5V or constant GND
{Out.ar(1,Osc.ar(~w,freq:11,mul:1.0,phase:0.0))}.play
)

(
/////control
{
var env;
	env=EnvGen.ar(Env.new([0,1,1,0],[0.01,10,0.01]),doneAction:2);
Out.ar(2,LFPulse.ar(freq: 100, iphase: 0.0, width: 0.01, mul: env, add: 0));
Out.ar(3,Osc.ar(~w.bufnum,freq:1,mul:env,phase:0.0))
	}.play
)

////8channels means 8 stepper motors or 4 if the half 4 are used as direction pins
