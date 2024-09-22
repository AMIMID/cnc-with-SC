
// if you want to set a different port for your standalone.
// s = Server("standalone_name",NetAddr("localhost",57556));
// Server.default = s;
(
Server.default = s = Server.local;

(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=2;
s.options.memSize = 8192*4;
s.options.maxNodes = 1024 * 1;
);

s.waitForBoot{
	s.meter;

(
{
var signal1,signal2,env1,env2,pl=89,angle1=0,angle2=0,angle3=0,angle4=0,angle5=0,angle6=90;
var pos1,pos2,phase1,phase2,phase3,phase4,phase5,phase6,maga,magb,m1=3,m2=3;
var in1,in2, chainx,chainy,b=0,phasea,phaseb,p1,p2;
var chainxx,chainyy,mag1,mag2,maag,ph1,ph2,ang1=0,ang2=90;

	in1 = SoundIn.ar(0);
	 in2 =  SoundIn.ar(1);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);


~phase1=720.collect{

	ph1=exp(Complex(0,1)*ang1.degrad).theta;
	ang1=(ang1+(360-(360/1.6180339887499))).wrap(0,360);
					ph1.round(0.0001);

};

~phase2=720.collect{

	ph2=exp(Complex(0,1)*ang2.degrad).theta;
	angle2=(ang2+(360-(360/1.6180339887499))).wrap(0,360);
					ph2.round(0.0001).neg;
};


~posL=720.collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1=(Complex(sin(phase1.round(0.0001)*m1),sin(phase1.round(0.0001)*m1)).rho.round(0.0001)*Complex(cos(phase1.round(0.0001)*m1),cos(phase1.round(0.0001)*m1)).rho).round(0.0001);

};

~posR=720.collect{

	phase2=exp(Complex(0,1)*angle2.degrad).theta;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=(Complex(sin(phase2.round(0.0001)*m2),sin(phase2.round(0.0001)*m2)).rho.round(0.0001)*Complex(cos(phase2.round(0.0001)*m2),cos(phase2.round(0.0001)*m2)).rho).neg.round(0.0001);
};


~magL = 720.collect{

	phase3=exp(Complex(0,1)*angle3.degrad).theta;
	angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
	maga=Complex(cos(phase3.round(0.0001)*m1),cos(phase3.round(0.0001)*m1)).rho.round(0.0001)*Complex(cos(phase3.round(0.0001)*m1),cos(phase3.round(0.0001)*m1)).rho.round(0.0001);
	};

~magR = 720.collect{

	phase4=exp(Complex(0,1)*angle4.degrad).theta;
	angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
	magb=Complex(sin(phase4.round(0.0001)*m2),sin(phase4.round(0.0001)*m2)).rho.round(0.0001)*Complex(cos(phase4.round(0.0001)*m2),cos(phase4.round(0.0001)*m2)).rho.round(0.0001);
	};

90.do{

		pos1=~posL.[pl]/(2.sqrt);
		pos2=~posR.[pl]/(2.sqrt);
		mag1=~magL.[pl]/(2.sqrt);
		mag2=~magR.[pl]/(2.sqrt);
		p1=~phase1.[pl];
		p2=~phase2.[pl];

		maag=Complex(mag1,mag2).rho/(2.sqrt);



chainxx = chainx.pvcollect(1024, {|mag, phase, index| [mag*maag, exp(Complex(0,1)*(phase+SinOsc.ar(maag,p1))).theta]; }, frombin: b, tobin: b, zeroothers: 1);
chainyy = chainy.pvcollect(1024, {|mag, phase, index| [mag*maag, exp(Complex(0,1)*(phase+SinOsc.ar(maag,p2))).theta]; }, frombin: b, tobin: b, zeroothers: 1);



		signal1=Pan2.ar(IFFT(PV_PhaseShift(chainxx,0.degrad)),pos1);
		signal2=Pan2.ar(IFFT(PV_PhaseShift(chainyy,0.degrad)),pos2);
b=b+1;
pl=pl+1;
		Out.ar(0,signal1);
		Out.ar(0,signal2);

}
}.play
);



}


)