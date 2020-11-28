---
title: "Monophonic Analog Synthesizer with AR Enveloping"
date: 2013-04-21 01:29:18
date_description: April 2013 - May 2013
categories: portfolio
tag: electronics
image: /img/projects/analog-synth-ec412/analog-synth-ec412.jpg
documentation: /pdf/ec412-final-report.pdf
source: https://github.com/cwoodall/ec412-analog-audio-synth
video: #
partners: ["Benjamin Havey"]
id: 2
---

This Monophonic Analog Synthesizer was designed by Christopher Woodall and Benjamin Havey. The synthesizer uses a homemade linearly actuated potentiometer as its input, a long with a button for articulation. The potentiometer voltage is fed through a linear to exponential converter and then a voltage controlled oscillator. The output of the VCO is then put through a analog multiplier designed using an opamp and discrete transistors which envelopes the square and triangle wave VCO outputs with a attack release (AR) envelope. The enveloped output is then filtered, amplified and pumped through speakers. Each piece of the synthesizer was simulated in LTSpice and then built on a breadboard.
