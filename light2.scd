(
Server.default = s = Server.local;
////server setup
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(0.5);
s.options.memSize = 8192*64;
s.options.blockSize = 64*8;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 48000;
);

s.waitForBoot{
(
~b= Buffer.alloc(s,2048);
);
{
var env,sig,wt,angle=0,level,levels;

~levels=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*angle+((360-(360/1.6180339887499))/100).degrad).imag);
};
env = Env(~levels,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~b.loadCollection(wt);
sig.plot;
	}.value;


(
~time=2;
////////fractal
{
var c,angle=0,c_real,c_imag,z;



~c = 5.collect{
 	c_real=exp(Complex(0,1)*angle.degrad).real;
	c_imag=exp(Complex(0,1)*angle.degrad).imag;
 	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
 	c=Complex(c_real,c_imag);
 };
z=Complex(0,0);

~j = (720*~time).collect{
	c=~c.[4];
	z=z.pow(2)+c;
	z.theta.round(0.000001);
}

}.value;
{
var phase1,phase2,angle1=0,angle2=0,m=2,pl1=0,pl2=0;

~posL=(720*~time).collect{

	phase1=exp(Complex(0,1)*(angle1.degrad*~j.[pl1]).wrap(2pi.neg,2pi)).theta;
	pl1=pl1=1;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1=(Complex(sin(phase1.round(0.0001)*m),sin(phase1.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase1.round(0.0001)*m),cos(phase1.round(0.0001)*m)).rho).round(0.0001);

};

	~posR=(720*~time).collect{

	phase2=exp(Complex(0,1)*(angle2.degrad*~j.[pl2]).wrap(2pi.neg,2pi)).theta;
	pl2=pl2=1;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=(Complex(sin(phase2.round(0.0001)*m),sin(phase2.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase2.round(0.0001)*m),cos(phase2.round(0.0001)*m)).rho).round(0.0001).neg;
};

}.value;

{
var phase,angle=0,mag,phase1,angle1=0,mag1,m=2,pl1=0,pl2=0;

~magL = (720*~time).collect{

	phase=exp(Complex(0,1)*(angle.degrad*~j.[pl1]).wrap(2pi.neg,2pi)).theta;
	pl1=pl1=1;
	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	mag=Complex(cos(phase.round(0.0001)*m),cos(phase.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase.round(0.0001)*m),cos(phase.round(0.0001)*m)).rho.round(0.0001);
	};

~magR = (720*~time).collect{

	phase1=exp(Complex(0,1)*(angle1.degrad*~j.[pl2]).wrap(2pi.neg,2pi)).theta;
	pl2=pl2=1;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	mag1=Complex(sin(phase1.round(0.0001)*m),sin(phase1.round(0.0001)*m)).rho.round(0.0001)*Complex(cos(phase1.round(0.0001)*m),cos(phase1.round(0.0001)*m)).rho.round(0.0001);
	};
}.value;


	);

		({
		var angle=0;
		~angle=(720*~time).collect{
		angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		}
		}.value
	);

////////////////////osc

(
SynthDef.new(\light,
{
arg decay=6,speed=1,octave=2,angle_r=0,gain=0.1;
var signal1,signal2,env,amp1,amp2,pl=0,nx,ny,mult=12,m=1,pl1=0;
var pos1,pos2,phase1,phase2,mag,fundamental=55,freq,pitch1,pitch2;
var amp,phase,c1,c2;

fundamental=fundamental*speed.reciprocal;
		freq=fundamental*octave;
(720).do{

		pos1=~posL.[pl1];
		pos2=~posR.[pl1];
		//phase1=~phase1.[pl];
		//phase2=~phase2.[pl];
		mag=Complex(~magL.[pl1],~magR.[pl1]);

		//ph1=SinOsc.ar(mag.reciprocal,phase1,mag);
		//ph2=SinOsc.ar(mag.reciprocal,phase2,mag);
		mag=mag.round(0.0000000001);

				c1=Polar(mag.real,mag.theta);
				c2=Polar(mag.imag,mag.theta);

			    nx=(mag*Polar(mult,Select.kr(angle_r,~angle).degrad)).real;
			    ny=(mag*Polar(mult,Select.kr(angle_r,~angle).degrad)).imag;
				//nx=c1.x*mult;
				//ny=c1.y*mult;

		pitch1=2.pow(nx/12);
		pitch2=2.pow(ny/12);

				//phase=if(pl2%2==0,0.degrad,90.degrad);

		amp1=m.reciprocal*octave.reciprocal*speed*pitch1.reciprocal;
		amp2=m.reciprocal*octave.reciprocal*speed*pitch2.reciprocal;

				signal1=(Osc.ar(~b.bufnum,freq*pitch1*m,c1.theta,amp1));
				signal2=(Osc.ar(~b.bufnum,freq*pitch2*m,c2.theta,amp2));

				Out.ar(0,Pan2.ar(LeakDC.ar(signal1),pos1,gain));
				Out.ar(0,Pan2.ar(LeakDC.ar(signal2),pos2,gain));

						pl1+pl1=1;
						m=m+1;
					}

}).add;
);

SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbserial-1340",9600);

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
~synth=Synth.new(\light, [\angle_r,45]);
(~control = Routine.new({
	{
				~synth.set(\angle_r,~val.linlin(100,1200,0,(720*~time)));
		0.01.wait;
	}.loop;
}).play;
	))

	}
)


