
(
/////control
{Out.ar(0,LFPulse.ar(freq: 440.0, iphase: 0.0, width: 0.5, mul: 1.0, add: 0))}.play
///direction/needs constant +5V or constant GND
{Out.ar(1,LFPulse.ar(freq: 440.0, iphase: 0.0, width: 0.1, mul: 1.0, add: 0))}.play
)

////8channels means 8 stepper motors or 4 if the half 4 are used as direction pins