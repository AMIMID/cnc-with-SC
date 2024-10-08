
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

(
var c,angle=0,c_real,c_imag,z;



~c = 5.collect{
 	c_real=exp(Complex(0,1)*angle.degrad).real;
	c_imag=exp(Complex(0,1)*angle.degrad).imag;
 	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
 	c=Complex(c_real,c_imag);
 };
z=Complex(0,0);

~j = (1440*2).collect{
	c=~c.[4];
	z=z.pow(2)+c;
	z.theta.round(0.000001);
}

)
s.waitForBoot{

~b= Buffer.alloc(s,2048);

SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbserial-210",9600);


	(
SynthDef(\light ,{ arg amp=0.01;

var phase1,angle1=0,phase2,angle2=90;
var phase3,phase4,angle3=0,angle4=0,m=2;
var phase5,angle5=0,mag,phase6,angle6=0,mag1;
var signal1,signal2,env1,env2,pl=89,mm=1,fund=55;
var pos1,pos2,phase7,phase8,ph1,ph2,magg;
var env,sig,wt,angle=0,level,levels;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0;

~phase1=720.collect{

	phase1=exp(Complex(0,1)*(angle1.degrad*~j.[pl1])).theta;
				pl1=pl1=1;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1.round(0.000000001)
};
~phase2=720.collect{

	phase2=exp(Complex(0,1)*(angle2.degrad*~j.[pl2])).theta;
				pl2=pl2=1;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2.round(0.000000001).neg
};

~posL=720.collect{

	phase3=exp(Complex(0,1)*(angle3.degrad*~j.[pl3])).theta;
				pl3=pl3=1;
	angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
	phase3=(Complex(sin(phase3.round(0.000000001)*m),sin(phase3.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase3.round(0.000000001)*m),cos(phase3.round(0.000000001)*m)).rho).round(0.000000001);

};

~posR=720.collect{

	phase4=exp(Complex(0,1)*(angle4.degrad*~j.[pl4])).theta;
				pl4=pl4=1;
	angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
	phase4=(Complex(sin(phase4.round(0.000000001)*m),sin(phase4.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase4.round(0.000000001)*m),cos(phase4.round(0.000000001)*m)).rho).round(0.000000001).neg;
};

~magL = 720.collect{

	phase5=exp(Complex(0,1)*(angle5.degrad*~j.[pl5])).theta;
				pl5=pl5=1;
	angle5=(angle5+(360-(360/1.6180339887499))).wrap(0,360);
	mag=Complex(cos(phase5.round(0.000000001)*m),cos(phase5.round(0.000000001)*m)).rho.round(0.000000001)*Complex(cos(phase5.round(0.000000001)*m),cos(phase5.round(0.000000001)*m)).rho.round(0.000000001);
	};

~magR = 720.collect{

	phase6=exp(Complex(0,1)*(angle6.degrad*~j.[pl6])).theta;
				pl6=pl6=1;
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

		ph1=SinOsc.ar(magg.reciprocal,phase7,magg);
		ph2=SinOsc.ar(magg.reciprocal,phase8,magg);

				signal1=LPF.ar(Osc.ar(~b.bufnum,fund*mm,ph1,mm.reciprocal),fund*16,magg);
				signal2=LPF.ar(Osc.ar(~b.bufnum,fund*mm,ph2,mm.reciprocal),fund*16,magg);

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
		//1.wait;
~synth=Synth.new(\light, [\amp,1]);
(~control = Routine.new({
	{
	~synth.set(\amp,~val.linlin(300,600,1/(64*1024),1/6));
		0.01.wait;
	}.loop;
}).play;
	))
}
	)