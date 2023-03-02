# Voice_analyzer
Development of an analyzer of breathing sounds for the diagnosis of lung diseases. 

The work describes the development of an analyzer of breathing and voice sounds, which records voice parameters 
using a microphone and transmits a signal via Bluetooth to a smartphone, where the signal is processed. 
A theoretical scheme of the structure of this device is proposed.

Section 1 provides theoretical justifications for the applicability of pathological sound analysis to assess 
the patient's condition. The description and analysis of the studied processes and signals is given.

In section 2, a circuit is proposed, which is a power amplifier built on an operational amplifier and 
bipolar transistors. The circuit is quite simple and consists of a non-inverting amplifier and 
two stages of emitter followers. This power amplifier has good frequency response and is suitable for use in 
audio amplification. In the Micro-Cap environment, we calculated the frequency characteristics of 
the power amplifier (Magnitude Frequency Response, Phase Frequency Response), the dependence of 
the output voltage on temperature. Modeling and layout of the board was made in the Circuit Maker.

In section 3, a variant of a software solution for the voice recording preprocessing process for removing 
parameters specific for pathological changes (HNR, jitter, shimmer) is proposed. MFCC calculated. 
Preprocessing includes the following. The selection of the most informative fragment from the complete 
signal recording is performed by determining the fragment with the maximum signal power. Spectrogram and 
Spector Power Density calculated. Removed silenced samples to reduce data size for analysis.
