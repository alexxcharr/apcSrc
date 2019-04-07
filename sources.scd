// pot 1-8
(
~sourceArr = [\0, \1, \2, \3, \4, \5];
SynthDef(\0, {|
	pot1 = 0, 
	pot2 = 0, //src range lim
	pot3 = 0, //amp range lim
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0,// amp
	freq = 55,
	gate = 1,
	pitchModifier = 1,
	max = 200|
	var src, envgen, env, amp;
	env = Env.asr(1,1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2, 20)}!4).range(0, pot3);
	src = SinOsc.ar({ExpRand(50, max)}).range(0, pot2 * 2);  //multichanel
	src = Pan2.ar(src, 0);
	Out.ar(0, src * envgen * pot8);
	//error when adding pot for !4
	//not playing when adding pot for max
}).add;
SynthDef(\1, {|
	pot1 = 0,//harm
	pot2 = 0,// freq
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0,// amp
	freq = 25,
	gate = 1,
	pitchModifier = 1|
	var src, envgen, env;
	env = Env.asr(1,1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = LeakDC.ar(Mix(Blip.ar([pot2 * 25 * 1.01, pot2 * 25 *1.01], pot1 * 30, envgen)));
	Out.ar(0, Pan2.ar(src * envgen * pot8, 0.5));
}).add;
//ta pot douleuoun opote na nai
SynthDef(\2, {| //werkit2
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0,// amp
	freq = 440,
	gate = 1,
	pitchModifier = 1,
	cutoff = 100,
	rq = 0.1, att = 2, dec = 0, sus = 1, rel = 0.1|
	var src, envgen, env, snd, filter;
	// env = Env.asr(attackTime:0.1, releaseTime:0.1);
	// envgen = EnvGen.kr(env, gate: Dust.kr(1000 * pot1, 1, -0.5), doneAction:0, timeScale: 0.5);
	src = LFSaw.ar(Array.fill(16, { Rand(100, 200) }));
	filter = BLowPass4.ar(src, pot1 * 880, pot2 * 0.1) * 0.1;
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel),
		gate: gate,
		doneAction: 2);
	snd = (0.7 * filter + (0.3 * filter.distort));
	snd = HPF.ar(snd, 100);
	snd = Splay.ar(snd);
	Out.ar(0, snd * env * pot8);
	// Out.ar(127, Pan2.ar(src * pot8 * envgen, pos: (2*(pot3 - 0.5))));
}).add;
~buf0 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "samples/2.wav", bufnum: 1);
SynthDef(\3,{|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	gate = 1
	|
	var src, envgen, env;
	env = Env.asr(attackTime:1, releaseTime:1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = GrainBuf.ar(1,Impulse.kr(pot4 * 440), pot3, ~buf0.bufnum, rate: pot2, pos: pot1, maxGrains: 128);
	Out.ar(0, Pan2.ar(src * envgen * pot8));
}).add;
SynthDef(\4, {|gate = 1, freq = 440, atk = 1, rel = 1, amp = 0.6, pan = 0, pot1 = 0, pot8 = 0|
	var src, env, envgen;
	src = Dust.ar(pot1 * 122);
	env = Env.asr(attackTime:1, releaseTime:1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = BBandPass.ar(src, {LFNoise1.kr(
		LFNoise1.kr(4).exprange(0.4, 0.5)
	).exprange(800, 1900)}!2, {LFNoise1.kr(0.1).exprange(0.2, 0.3)}!2);
	// src = FreeVerb.ar(src, 0.8, 0.6, 0.4, 2);
	src = Pan2.ar(src, ClipNoise.kr());
	Out.ar(127, src * envgen * pot8);
}).add;
SynthDef(\5,{|
	pot1 = 0,//dust frequency
	pot2 = 0,// sine frequency
	pot3 = 0,
	pot4 = 0,
	pot5 = 0,
	pot6 = 0,
	pot7 = 0,
	pot8 = 0.20,// amp
	gate = 1
	|
	var src, envgen, env;
	env = Env.asr(attackTime:1, releaseTime:1);
	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
	src = SinOsc.ar(440 * pot1);
	Out.ar(0, Pan2.ar(src * envgen * pot8));
}).add;
// SynthDef(\1, {|
// 	pot8 = 0.15,//amp
// 	freq = 55,
// 	gate = 1,
// 	pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = SinOsc.ar(freq * pitchModifier);
// 		Out.ar(0, Pan2.ar(src * pot8 * envgen));
// }).add;
// // not a grain wOOOOOOOOOOOw :o
// SynthDef(\2,{|pot8 = 0.2,//amp
// 	gate = 1,
// 	synfreq = 55,
// 	pitchModifier = 1|
// 	var src, envgen, env;
// 	synfreq = synfreq + pitchModifier;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = SinOsc.ar(Line.kr(synfreq, 9/8 * synfreq)); // + LFTri.ar(synfreq, mul: pot8/4);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8 * 1.4));
// }).add;
// SynthDef(\3,{|pot8 = 0.2,//amp
// 	gate = 1,
// 	synfreq = 55|
// 	var src, src2, envgen, env;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = LPF.ar(WhiteNoise.ar(1),6000);
// 	src2 = HPF.ar(src, 2000);
// 	Out.ar(0, Pan2.ar(src2 * envgen  * pot8));
// }).add;
)

/// GRAINS :|
// W A R N I N G - GrainBuf needs mono spot8le!!!
// ~buf0 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "spot8les/1.wav", bufnum: 1);
// SynthDef(\0,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1, pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf0.bufnum, rate * pitchModifier, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
// ~buf1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "spot8les/2.wav", bufnum: 2);
// SynthDef(\1,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1, pitchModifier = 1|
// 	var src, envgen, env;
// 	env = Env.asr(attackTime:1, releaseTime:1);
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf1.bufnum, rate * pitchModifier, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
// spot8le buf2
// SynthDef(\2,{| pot8 = 0.2, impFreq = 50, grainDur = 0.1, rate = 0.5, pos = 0.5, gate =1|
// 	var src, envgen, env;
// 	env = Env.perc();
// 	envgen = EnvGen.kr(env, gate: gate, doneAction:2);
// 	src = GrainBuf.ar(1,Impulse.kr(impFreq), grainDur, ~buf1.bufnum, rate, pos, maxGrains: 128);
// 	Out.ar(0, Pan2.ar(src * envgen * pot8));
// }).add;
