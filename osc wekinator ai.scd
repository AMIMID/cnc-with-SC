(
OSCdef.new(
	\osc,
	{
		arg msg, time, addr, port;
	//	[msg, time, addr, port].postln;
		msg.postln
		Synth(\blabla, [argument:msg[1]])
	},'/wek/outputs'
);
)

///incoming listening port for sc
NetAddr.langPort;