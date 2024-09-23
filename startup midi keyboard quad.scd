
(
Server.default = s = Server.local;

(
s.options.numWireBufs = 1024*16;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*32;
s.options.maxNodes = 1024 * 32;
);

s.waitForBoot{

/////wavetables
//Buffer.freeAll
(
~w= Buffer.alloc(s,2048);
~t= Buffer.alloc(s,2048);
);

(
// 3D
~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);

(
SynthDef.new(\ob, {
	arg  n1=1,cutt=1200,decay=6,t=2,attack=0.01,az=0,el=0,mag=1,mx=1,my=1,mz=1;
	var phase,scale=4,pl=0,osc,sph,sphere,az_o,el_o;
	var mg_x,mg_y,mg_z,mag_o,v,q,rot,cr,i,j,k,rr;
	var freq, env,m=1,bank,pitch,fund=55,ange=0, ang;
///wt_osc
	var en,sig,wt_osc,angl=0,level,levels;
//wt_osc_pan
	var signal,wt,n=0,amp;
//az el mag

	var  sph1,sph2,m_x=5,m_y=5,m_z=5,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
	var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
//out
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

////////////////////////////////////////////////////////////////////
~levels=720.collect{
level=exp(Complex(0,1)*angl).imag;
angl=angl+1.degrad;
levels=level.rrand(exp(Complex(0,1)*angl+((1/6)/1.6180339887499)).imag);
};
en = Env(~levels,[1]);
sig=en.asSignal(1024);
wt_osc = sig.asWavetable;
~w.loadCollection(wt_osc);
///////////////////////////////////////////////////////////////
~level=720.collect{n=n+1;amp=n.reciprocal};
~phase=720.collect{pi};
signal=Signal.sineFill(1024,~level,~phase);
wt = signal.asWavetable;
~t.loadCollection(wt);
/////////////////////////////////////////////////////////
~az = (360*2).collect{

		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph1=Spherical(1,az1.degrad,el1.degrad).theta.round(0.00001);

	};

~el = (360*2).collect{

		az2=(az2+(1)).wrap(180.neg,180);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,az2.degrad,el2.degrad).phi.round(0.00001);

	};

~magx = (360*2).collect{

	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad,elx.degrad);

	mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;

//mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
//Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;

	};

~magy = (360*2).collect{

	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad,ely.degrad);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz = (360*2).collect{

	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad,elz.degrad);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	};

///////////////////////////synth
bank=18;
pitch=2.pow(n1/(2*6));
freq=(fund*scale)*pitch;

ang=(360-(360/1.6180339887499));
az_o = az.round(0.0001);
el_o = el.round(0.0001);
cr=Spherical(mag,az,el);
v=Quaternion(0,cr.x,cr.y,cr.z);

bank.do{
phase=exp(Complex(0,1)*ange.degrad).theta;
ange=(ange+(360-(360/1.6180339887499))).wrap(0,360);

rr=Spherical(1,~az.[pl],~el.[pl]);
rot=[rr.x,rr.y,rr.z];
i=Quaternion(0, rot.[0], 0, 0);
j=Quaternion(0, 0, rot.[1], 0);
k=Quaternion(0, 0, 0, rot.[2]);

q=(cos(ang.degrad)+(sin(ang.degrad)*(i+j+k)));
v=q*v*q.conjugate;
pl=pl+1;

sph=Cartesian(v.b,v.c,v.d);

mg_x=(Complex(cos((sph.theta.round(0.00001)*mx).wrap(pi.neg,pi)),cos((sph.theta.round(0.00001)*mx).wrap(pi.neg,pi))).rho*Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho);

mg_y=(Complex(sin((sph.theta.round(0.00001)*my).wrap(pi.neg,pi)),sin((sph.theta.round(0.00001)*my).wrap(pi.neg,pi))).rho*Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho);

mg_z= Complex(cos((sph.phi.round(0.00001)*mz).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)*mz).wrap((pi/2).neg,(pi/2)))).rho;

mag_o=Cartesian(mg_x/(2.sqrt),mg_y/(2.sqrt),mg_z/(2.sqrt)).rho/(2.sqrt);

sphere=Spherical(mag_o,sph.theta,sph.phi);

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:mag_o);
	//	env=EnvGen.ar(Env.sine(decay,pitch.reciprocal),doneAction:2,levelScale:mag_o);


osc=VBAP.ar(4,
Osc.ar(~w.bufnum,(freq*m),mul:m.reciprocal,phase:phase),
~b.bufnum,
Osc.ar(~t.bufnum,sphere.rho,phase:sphere.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
Osc.ar(~t.bufnum,sphere.rho,phase:sphere.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);
m=m+1;

wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc)*env*0.2),cutt))
//Out.ar(0,LPF.ar(LeakDC.ar((osc)*env*0.1),cutt));
	};
}).add;
);



(
MIDIClient.init;
MIDIIn.connectAll;

MIDIdef.noteOn(\note, { |val, num, chan, src|
	[val, num, chan, src].postln;
	if(num < 49) {
		num = num - 1
	};
			~a=Synth(\ob, [n1: num - 48,cutt:1760, out: [(0..3).rotate(4.rand)], az:~az.[720.rand], el:~el.[720.rand], mag:~magx.[720.rand] ,mx:5.rand ,my:5.rand  ,mz:5.rand]);

}, noteNum: (36..96));
);

	}
	)




