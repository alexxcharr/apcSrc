
//:
SynthDef.new(\multi, {|max = 200|
	var sig, amp, env;
	env = EnvGen.kr(Env.new([0.1, 0.2, 0], [10, 10]),doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2, 20)}!4).range(0, 1);
	sig = SinOsc.ar({ExpRand(50, max)}!6).range(0, 2);  //multichanel
	sig = sig * amp;
	// sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).play;



//:
SynthDef.new(\klang, {|amp = 0.2, pan = 0
	freqs = #[55, 130, 174, 740],
	amps = #[0.35, 0.23, 0.12, 0.05],
	phases = #[pi]|
	var sig, env;
	sig = Klang.ar(`[freqs, amps, phases]);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(0, sig);
}).play;



//:
SynthDef.new(\gauss,{ |freq = 367, amp = 0.5, pan = 0, rq= 0.6, gate=1|
	var sig, env;
	sig = LFGauss.ar(PinkNoise.kr(1), 0.1);
	//env = Env([0,1,0], [1,1], \sine);
	//sig = sig * EnvGen.kr(env, gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = APF.ar(sig, 100, pi/16);
	Out.ar(0, sig);
}).add;



//:
SynthDef.new(\mpou, {|st=90, gate=1|
	var sig, env;
	sig = SinOsc.ar(XLine.kr(st, 80, 2), 0, 0.8);
	env = Env([0.5, 0.9, 0], [3, 3], \sine);
	sig = sig * EnvGen.kr(env, gate, doneAction: 2);
	sig = FreeVerb.ar(sig, 0.9, 0.8);
	sig = APF.ar(sig, 100, pi/16);
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig);
}).play;


//:
SynthDef.new(\ante, {|freq = 380, atk = 1, rel = 1, gate = 1|
	var sig, env;
	sig = Formant.ar(freq);
	env = Env.new([0, 0.6, 0], [atk, rel], \sine);
	sig = sig * EnvGen.kr(env, gate, doneAction:2);
	sig = LPF.ar(sig);
	sig = Pan2.ar(sig, 0, 0.7);
	Out.ar(0, sig);
}).play;


//:
~t = TempoClock(1);
~tc = TempoClock(1);

//:
SynthDef.new(\wt, {|freq = 240, atk = 0.3, rel =0.5, amp = 1|
	var sig, env;
	sig = Formant.ar(Vibrato.kr(freq));
	sig = Pan2.ar(sig, 0, amp);
	env = EnvGen.ar(Env.new([0,1, 0], [atk, rel]), doneAction:2);
	sig = BPF.ar(sig, 600);
	Out.ar(0, sig);
}).add;

//:
SynthDef.new(\iter, {|atk = 0.05, rel = 0.1|
	var temp, sum, env;
	sum = 0;
	10.do{
		temp = VarSaw.ar(
			40* {Rand(0.99, 1.02)}!2,
			0,
			0.05
		);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	env = EnvGen.ar(Env.new([0, 0.8, 0], [atk, rel]), doneAction:2);
	sum = sum * env;
	Out.ar(0, sum);
}).play;


//:
SynthDef.new(\lfpar, {|freq = 673, amp = 0.8, pan = 0, atk = 3, rel = 2, cfmin = 500, cfmax = 2000, cfhzmin = 0.1, cfhzmax = 0.3, rqmin = 0.1, rqmax = 0.2|
	var sig, env;
	sig = LFPar.ar(Vibrato.kr(freq));
	env = EnvGen.ar(Env.new([0, 1, 0], [atk, rel], \wel, ),doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = LPF.ar(sig, {LFNoise1.kr(
		LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)
	).exprange(cfmin, cfmax)}!2, {LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2);
	sig = FreeVerb.ar(sig, 0.45, 0.8);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).play;

//:
4.do{
	Synth(
		\lfpar,
		[
			\freq, (Scale.minor.degrees+60).midicps.choose,
			\amp, 0.25,
			\cfmin, 50 * 2,
			\cfmax, 50 * 50,
			\rqmin, 0.5,
			\rqmax, 0.8,
			\cfhzmin, 1,
			\cfhzmax, 6,
		]
	);
};


//:
SynthDef.new(\blip, {|round = 300, dust = 20, max = 1200, amp = 0.2|
	var freq, trig, sig, env;
	freq = LFNoise0.kr(6).exprange(300, max).round(round);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(dust);
	env = Env([0, 1, 0],[0.01, 0.2], \sine);
	sig = sig * EnvGen.kr(env, trig);
	sig = Pan2.ar(sig, 0, amp);
	Out.ar(0, sig);
}).play;

