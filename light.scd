
Buffer.freeAll

(
Server.default = s = Server.local;

(
s.options.numWireBufs = 1024*8;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
s.options.maxNodes = 1024 * 16;
);

s.waitForBoot{

~b= Buffer.alloc(s,2048);

SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbserial-130",9600);


	(
SynthDef(\light ,{ arg amp=0.01;

var phase1,angle1=0,phase2,angle2=90;
var phase3,phase4,angle3=0,angle4=0,m=3;
var phase5,angle5=0,mag,phase6,angle6=0,mag1;
var signal1,signal2,env1,env2,pl=89,mm=1,fund=55;
var pos1,pos2,phase7,phase8,ph1,ph2,magg;
var env,sig,wt,angle=0,level,levels;

~phase1=720.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1.round(0.000000001)
};
~phase2=720.collect{

	phase2=exp(Complex(0,1)*angle2.degrad).theta;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2.round(0.000000001).neg
};

~posL=720.collect{

	phase3=exp(Complex(0,1)*angle3.degrad).theta;
	angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
	phase3=(Complex(sin(phase3.round(0.000000001)*m),sin(phase3.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase3.round(0.000000001)*m),cos(phase3.round(0.000000001)*m)).rho).round(0.000000001);

};

~posR=720.collect{

	phase4=exp(Complex(0,1)*angle4.degrad).theta;
	angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
	phase4=(Complex(sin(phase4.round(0.000000001)*m),sin(phase4.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase4.round(0.000000001)*m),cos(phase4.round(0.000000001)*m)).rho).round(0.000000001).neg;
};

~magL = 720.collect{

	phase5=exp(Complex(0,1)*angle5.degrad).theta;
	angle5=(angle5+(360-(360/1.6180339887499))).wrap(0,360);
	mag=Complex(cos(phase5.round(0.000000001)*m),cos(phase5.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase5.round(0.000000001)*m),cos(phase5.round(0.000000001)*m)).rho.round(0.000000001);
	};

~magR = 720.collect{

	phase6=exp(Complex(0,1)*angle6.degrad).theta;
	angle6=(angle6+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(sin(phase6.round(0.000000001)*m),sin(phase6.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase6.round(0.000000001)*m),cos(phase6.round(0.000000001)*m)).rho.round(0.000000001);
	};
///////oscbuf

~levels=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*angle+((1/6)/1.6180339887499)).imag);
};
env = Env(~levels,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~b.loadCollection(wt);
//sig.plot;
////////////////////osc


//env1=EnvGen.ar(Env([1,1],[1]),doneAction:2);
//env2=EnvGen.ar(Env([1,1],[1]),doneAction:2);
//env1=EnvGen.ar(Env.sine(100,1),doneAction:2);
//env2=EnvGen.ar(Env.sine(100,1)),doneAction:2);

90.do{

		pos1=~posL.[pl]/(2.sqrt);
		pos2=~posR.[pl]/(2.sqrt);
		phase7=~phase1.[pl];
		phase8=~phase2.[pl];
magg=Complex(~magL.[pl]/(2.sqrt),~magR.[pl]/(2.sqrt)).rho/(2.sqrt);

		ph1=SinOsc.ar(magg,phase7);
		ph2=SinOsc.ar(magg,phase8);

				signal1=LPF.ar(Osc.ar(~b.bufnum,fund*mm,ph1,mm.reciprocal),(1000*magg.reciprocal),magg);
				signal2=LPF.ar(Osc.ar(~b.bufnum,fund*mm,ph2,mm.reciprocal),(1000*magg.reciprocal),magg);

mm=mm+1;

pl=pl+1;

Out.ar(0,Pan2.ar(signal1,pos1,amp.lag(0.02)));
Out.ar(0,Pan2.ar(signal2,pos2,amp.lag(0.02)));

};
}).add;

);


	(
~charArray = [];
~getValues = Routine.new({

	var ascii;
	{ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
			~charArray =[];
		});
	}.loop;

}).play
);


(
		1.wait;
~synth=Synth.new(\light, [\amp,0.1]);
(~control = Routine.new({
	{
	~synth.set(\amp,~val.linlin(20,1100,1/8,1/(64*1024)));
		0.01.wait;
	}.loop;
}).play;
	))
}
	)