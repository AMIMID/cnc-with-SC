
////server setup
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*8;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 4;
s.waitForBoot
)

/////wavetables
Buffer.freeAll

(
~c1 = Buffer.read(s,"/Users/petrostatsiopoulos/Music/SuperCollider Recordings/SC_241017_230402.wav");
~c2 = Buffer.read(s,"/Users/petrostatsiopoulos/Music/SuperCollider Recordings/pinotites2/recordings from mics/705140__dibko__231007-04-strnisce-forest-full-of-life-04_remaster.wav");
)

(
SynthDef.new(\inst4,
{
		arg lowpass1=440,highpass1=440,lowpass2=440,highpass2=440,gain1=1,gain2=1;
		var sig1a,sig2a,sig1b,sig2b;

sig1a=HPF.ar(PlayBuf.ar(4, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2),highpass1.lag(0.333),gain1.lag(0.333));
sig1b=LPF.ar(PlayBuf.ar(4, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2),lowpass1.lag(0.333),gain1.lag(0.333));
sig2a=HPF.ar(PlayBuf.ar(4, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0, doneAction:2),highpass2.lag(0.333),gain2.lag(0.333));
sig2b=LPF.ar(PlayBuf.ar(4, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0, doneAction:2),lowpass2.lag(0.333),gain2.lag(0.333));

	Out.ar(0,sig1a);Out.ar(0,sig2a);Out.ar(0,sig2a);Out.ar(0,sig2b);

}).add;
(
Window.closeAll;
w=Window.new("gui",Rect.new(750,100,200,250)).front.alwaysOnTop_(true);

~gain1 = Slider.new(w.view,Rect.new(20,20,160,30));

~gain2 = Slider.new(w.view,Rect.new(20,60,160,30));

~filter1 = RangeSlider.new(w.view,Rect.new(20,100,160,30));

~filter2 = RangeSlider.new(w.view,Rect.new(20,140,160,30));

~on = Button(w,Rect(80,180,40,40)).states_([
	["off",Color.black],Color.gray,["on",Color.white,Color.gray]]).action_({
	arg obj;
	if(
		obj.value==1,{~synth=Synth.new(\inst4,[
\gain1,~gain1.value,\gain2,~gain2.value,
\lowpass1,~filter1.lo.linexp(0,1,20,20000),\highpass1,~filter1.hi.linexp(0,1,20000,20),
	\lowpass2,~filter2.lo.linexp(0,1,20,20000),\highpass2,~filter2.hi.linexp(0,1,20000,20)]).register;},
		{~synth.free}
)})
);

(
~gain1.action_({
	arg obj;
	var gain;
	obj.value.postln;
	gain=obj.value;
	if(~synth.isPlaying,{~synth.set(\gain1,gain)});
});
);
(
~gain2.action_({
	arg obj;
	var gain;
	obj.value.postln;
	gain=obj.value;
	if(~synth.isPlaying,{~synth.set(\gain2,gain)});
});
);
(
~filter1.lo_(0).hi_(1).action_({
	arg obj;
	var lowpass,highpass;
	lowpass=obj.lo.linexp(0,1,20,20000);
	highpass=obj.hi.linexp(0,1,20000,20);
	lowpass.value.postln;
	highpass.value.postln;
	if(~synth.isPlaying,{~synth.set(\lowpass1,lowpass,\highpass1,highpass)});
});
);
(
~filter2.lo_(0).hi_(1).action_({
	arg obj;
	var lowpass,highpass;
	lowpass=obj.lo.linexp(0,1,20,20000);
	highpass=obj.hi.linexp(0,1,20000,20);
	lowpass.value.postln;
	highpass.value.postln;
	if(~synth.isPlaying,{~synth.set(\lowpass2,lowpass,\highpass2,highpass)});
});
);
)
s.record(numChannels:4)

(
MIDIClient.init;
MIDIIn.connectAll;

MIDIdef.cc(\midi,{ |val, num, chan, src|
	[val, num, chan, src].postln;

});
)
	