//:
SynthDef(\free, {|freq = 1000|
	var sig, env, gate, freqEnv;
	freqEnv = EnvGen.kr(Env.perc(level: 5.0.rand), Dust.ar(1000));
	sig = SinOsc.ar(freq + (freqEnv * (freq/2)));
	env = EnvGen.kr(Env.perc(releaseTime: 0.05), WhiteNoise.ar.poll);
	sig = sig * env;
	Out.ar(127, sig);
}).add;

//:
SynthDef(\rev, {
	var in, sig;
	in = In.ar(127);
	sig = MoogFF.ar(in, freq: 234, gain: 0);
	sig = LPF.ar(in, freq: 880);
	sig = HPF.ar(sig);
	sig = FreeVerb.ar(sig, mix: 0.7, room: 1, add: 1);
	Out.ar(0, sig);
}).play;

//
//: retriggered envelope by Dust

{
    var env = Env([0.0, 0.5, 0.0, 1.0, 0.9, 0.0], [0.05, 0.1, 0.01, 1.0, 1.5], -4);
    var envgen = EnvGen.ar(env, Dust.ar(10).poll);
    SinOsc.ar(
        envgen * 1000 + 440
    ).poll * envgen * 0.1
}.play

