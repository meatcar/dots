# Comparing microphone quality on Linux

**Date:** 2026-10-13
**Host:** watson

Record every mic at once, match loudness, then judge three ways: blind
listening, plots, and numbers. No single tool covers all three.

## Method

1. **Record all mics at the same time.** One take of the same speech in the
   same room removes performance and room variation between takes. PipeWire
   records any number of sources in parallel.
2. **Turn off processing.** Disable noise suppression, echo cancel, and AGC
   (in PipeWire filter chains, EasyEffects, or the app) so you hear the mic,
   not the DSP. Unmute each source and set its gain so speech peaks near
   −12 dBFS without clipping.
3. **Loudness-match before listening.** The louder take usually sounds
   better. Normalize each file to the same integrated loudness (LUFS) first.
4. **Listen blind**, then check plots and metrics to explain what you heard.

## Tools

| Job                                  | Tool                                                                                                   | nixpkgs                                | Notes                                                                                                                                                   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------ | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Capture                              | `pw-record`, `ffmpeg`, `sox`                                                                           | installed                              | `pw-record --target` takes a `node.name` or `object.serial`, not the `wpctl` ID                                                                         |
| Noise floor, levels                  | `sox … stats`, `ffmpeg -af astats`                                                                     | installed                              | Record room silence; compare `RMS Tr dB` (sox) or `Noise floor dB` (ffmpeg)                                                                             |
| Loudness match                       | `ffmpeg -af loudnorm`, `ebur128`; `ebumeter`                                                           | `ebumeter`                             | EBU R128                                                                                                                                                |
| Blind listening                      | [Lacinato ABX/Shootout-er][abx]                                                                        | no (Linux tarball)                     | ABX, ABCD..X, and "shootout" ranking with per-file gain                                                                                                 |
| Spectrogram / spectrum of files      | Audacity (Plot Spectrum), Sonic Visualiser, Spek, `sox … spectrogram`, `ffmpeg -lavfi showspectrumpic` | `audacity`, `sonic-visualiser`, `spek` | Shows hiss, hum, low/high roll-off, compression artifacts                                                                                               |
| Live analysis                        | [Friture][friture], JAAA, JAPA                                                                         | `friture`, `jaaa`, `japa`              | Real-time spectrum, spectrogram, octave bands, levels                                                                                                   |
| Frequency response                   | [REW][rew]                                                                                             | no (Linux installer)                   | Sweep from a speaker; compare mics relative to each other. Absolute response needs a calibrated reference mic. Free version records one input at a time |
| Objective speech score, no reference | DNSMOS P.835, SIGMOS, NISQA, UTMOS via [speechonnxmetrics][som]                                        | no (pip)                               | 1–5 MOS estimates; DNSMOS splits into speech (SIG), background (BAK), overall (OVRL); NISQA adds noisiness/coloration/discontinuity/loudness            |
| Objective score, with reference      | [ViSQOL][visqol], PESQ                                                                                 | no                                     | Needs a clean reference of the same audio; fits a playback-through-speaker test, not live speech                                                        |

## Commands

Capture all sources for 30 s into `takes/` (one file per mic):

```sh
mkdir -p takes
pw-dump | jq -r '.[] | select(.info.props."media.class"? == "Audio/Source") | .info.props."node.name"' |
  while read -r name; do
    timeout 30 pw-record --target "$name" --channels 1 "takes/$name.wav" &
  done
wait
```

Noise floor (record silence, then):

```sh
for f in takes/*.wav; do echo "$f"; sox "$f" -n stats 2>&1 | grep -E 'RMS (lev|Tr)'; done
```

Loudness-match to −23 LUFS for listening:

```sh
mkdir -p matched
for f in takes/*.wav; do ffmpeg -i "$f" -af loudnorm=I=-23 -ar 48000 "matched/${f##*/}"; done
```

Spectrograms side by side:

```sh
for f in matched/*.wav; do sox "$f" -n spectrogram -t "${f##*/}" -o "${f%.wav}.png"; done
```

Speech-quality scores:

```sh
uvx --from speechonnxmetrics speechonnxmetrics score takes/*.wav --metrics dnsmos,sigmos
```

## Caveats

- `speechonnxmetrics` is a young project (first commit 2026-07). The
  reference DNSMOS code lives in [microsoft/DNS-Challenge][dns]; NISQA in
  [gabrielmittag/NISQA][nisqa]. NISQA weights are CC BY-NC-SA.
- MOS models were trained on call/telephony speech. Treat scores as a ranking
  aid, not ground truth.
- Mics in different positions hear different room sound. Put them at the same
  distance from your mouth for a fair test.

## Observed on watson (2026-10-13)

A 3 s parallel capture of all 8 sources confirmed the capture command. Muted
or unplugged sources (C-Media USB, Generic USB, headphone mic) record digital
silence. The built-in laptop mic (`HiFi__Mic1`) sat at −12 dBFS RMS and the
Brio 101 at −35 dBFS, both with a steady level (trough close to average).
That could be room noise, hum, or high gain. Three seconds of unknown room
sound is too short to conclude anything.

[abx]: https://lacinato.com/cm/software/othersoft/abx
[friture]: https://friture.org/
[rew]: https://www.roomeqwizard.com/
[som]: https://github.com/TigreGotico/speechonnxmetrics
[visqol]: https://github.com/google/visqol
[dns]: https://github.com/microsoft/DNS-Challenge
[nisqa]: https://github.com/gabrielmittag/NISQA
