
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
~c1 = Buffer.read(s,;
)

(
SynthDef.new(\inst4,
{
		arg lowpass=440,highpass=440,gain=1;
		var sig1;

		sig1=LPF.ar(HPF.ar(PlayBuf.ar(4, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2),highpass.lag(0.33)),lowpass.lag(0.33),gain.lag(0.33));

	Out.ar(0,sig1);

}).add;
(
Window.closeAll;
w=Window.new("gui",Rect.new(750,50,200,200)).front.alwaysOnTop_(true);
~gain = Slider.new(w.view,Rect.new(20,20,150,30));
~lowpass = Slider.new(w.view,Rect.new(20,60,150,30));
~highpass = Slider.new(w.view,Rect.new(20,100,150,30));
~on = Button(w,Rect(20,140,40,40)).states_([
	["off",Color.black],["on",Color.white]]).action_({
	arg obj
	if(
		obj.value==1,{~synth=Synth.new(\inst4[\gain.~gain.value,\lowpass,~lowpass.value.linexp(0,1,55,3520),\highpass,~highpass.value.linexp(0,1,3520,55)]).register};,
		{~synth.free}
)})
);

(
~gain.action_({
	arg obj;
	var gain;
	obj.value.postln;
	gain=obj;
	~synth.isPlaying,{~synth.set(\gain,gain)};
});
);
(
~lowpass.action_({
	arg obj;
	var lowpass;
	lowpass=obj.value.linexp(0,1,55,3520);
	lowpass.value.postln;
	~synth.isPlaying,{~synth.set(\lowpass,lowpass)};
});
);
(
~highpass.action_({
	arg obj;
	var highpass;
	highpass=obj.value.linexp(0,1,3520,55)
	highpass.value.postln;
	~synth.isPlaying,{~synth.set(\highpass,highpass)};
});
);

)


s.record(numChannels:4,duration:45)