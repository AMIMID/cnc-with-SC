
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
	~time=2;
/*(
var  sph1,sph2,m_x=2,m_y=1,m_z=3,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;

~az = (360*~time).collect{

		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph1=Spherical(1,az1.degrad,el1.degrad).theta.round(0.00001);

	};

~el = (360*~time).collect{

		az2=(az2+(1)).wrap(180.neg,180);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,az2.degrad,el2.degrad).phi.round(0.00001);

	};

~magx = (360*~time).collect{

	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad,elx.degrad);

mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),
cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/
2)))).rho)*sphx.rho;
	};

~magy = (360*~time).collect{

	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad,ely.degrad);


mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),
sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,
(pi/2)))).rho)*sphy.rho;
	};

~magz = (360*~time).collect{

	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad,elz.degrad);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	};

)

/////////////////notes and durs

(
var dur=10,ph1,ph2,ph3,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0,sph1,sph2,sph3,n1,n2,n3,mult=12;
var mag1,mag2,mag3;

~phase2 = (360*~time).collect{
	ph1=~magx.[pl1]/(2.sqrt);
	pl1=pl1+1;
	ph1=(ph1*dur).round(1/256);
	};

~n2 = (360*~time).collect{
	mag1=Cartesian(~magx[pl4]/(2.sqrt),~magy[pl4]/(2.sqrt),~magz[pl4]/(2.sqrt)).rho/(2.sqrt);
	sph1=Spherical(mag1*mult,~az.[pl4],~el.[pl4]).z;
	pl4=pl4+1;
	n1=(sph1).round(1);
	};

);*/

(
SynthDef(\string,{
arg pitch,decay;
var signal1,signal2,env1,env2,pl=89,angle1=0,angle2=0,angle3=0,angle4=0,angle5=0,angle6=90;
var pos1,pos2,phase1,phase2,phase3,phase4,phase5,phase6,maga,magb,m1=3,m2=3;
var in1,in2, chainx,chainy,b=0,phasea,phaseb,p1,p2;
var chainxx,chainyy,mag1,mag2,maag,ph1,ph2,ang1=0,ang2=90;
var env;

	in1 = SoundIn.ar(0);
	 in2 =  SoundIn.ar(1);

	chainx = FFT(LocalBuf(1024), in1);
	chainy = FFT(LocalBuf(1024), in2);


		~phase1=(360*~time).collect{

	ph1=exp(Complex(0,1)*ang1.degrad).theta;
	ang1=(ang1+(360-(360/1.6180339887499))).wrap(0,360);
					ph1.round(0.0001);

};

~phase2=(360*~time).collect{

	ph2=exp(Complex(0,1)*ang2.degrad).theta;
	angle2=(ang2+(360-(360/1.6180339887499))).wrap(0,360);
					ph2.round(0.0001).neg;
};


~posL=(360*~time).collect{

	phase1=exp(Complex(0,1)*angle1.degrad).theta;
	angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
	phase1=(Complex(sin(phase1.round(0.0001)*m1),sin(phase1.round(0.0001)*m1)).rho.round(0.0001)*Complex(cos(phase1.round(0.0001)*m1),cos(phase1.round(0.0001)*m1)).rho).round(0.0001);

};

~posR=(360*~time).collect{

	phase2=exp(Complex(0,1)*angle2.degrad).theta;
	angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
	phase2=(Complex(sin(phase2.round(0.0001)*m2),sin(phase2.round(0.0001)*m2)).rho.round(0.0001)*Complex(cos(phase2.round(0.0001)*m2),cos(phase2.round(0.0001)*m2)).rho).neg.round(0.0001);
};


~magL = (360*~time).collect{

	phase3=exp(Complex(0,1)*angle3.degrad).theta;
	angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
	maga=Complex(cos(phase3.round(0.0001)*m1),cos(phase3.round(0.0001)*m1)).rho.round(0.0001)*Complex(cos(phase3.round(0.0001)*m1),cos(phase3.round(0.0001)*m1)).rho.round(0.0001);
	};

~magR = (360*~time).collect{

	phase4=exp(Complex(0,1)*angle4.degrad).theta;
	angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
	magb=Complex(sin(phase4.round(0.0001)*m2),sin(phase4.round(0.0001)*m2)).rho.round(0.0001)*Complex(cos(phase4.round(0.0001)*m2),cos(phase4.round(0.0001)*m2)).rho.round(0.0001);
	};

			env=EnvGen.ar(Env.sine(decay,pitch.reciprocal),doneAction:2);
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



signal1=Pan2.ar(PitchShift.ar(IFFT(chainxx,0.degrad),pitchRatio:pitch),pos1,env);
signal2=Pan2.ar(PitchShift.ar(IFFT(chainyy,0.degrad),pitchRatio:pitch),pos2,env);

b=b+1;
pl=pl+1;
		Out.ar(0,signal1);
		Out.ar(0,signal2);

}
};).add;
)



	(
z=Pdef(\1, Pbind(\instrument, \maze,
	//\dur,Pseq(~phase2,1),
			\dur,Pbrown(1/4,2,0.125,inf),
//\pitch,PdegreeToKey(Pseq(~n2,inf),Scale.phrygian),
			\pitch,PdegreeToKey(Pbrown(24.neg,24,1,inf),Scale.phrygian),
	\decay,Pbrown(2,4,1,inf);
));
)

}


)