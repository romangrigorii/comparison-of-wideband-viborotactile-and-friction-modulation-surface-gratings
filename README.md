# comparison-of-wideband-viborotactile-and-friction-modulation-surface-gratings

"This article seeks to understand conditions under which virtual gratings produced via vibrotaction and friction modulation are perceived as similar and to find physical origins in the results. To accomplish this, we developed two single-axis devices, one based on electroadhesion and one based on out-of-plane vibration. The two devices had identical touch surfaces, and the vibrotactile device used a novel closed-loop controller to achieve precise control of out-of-plane plate displacement under varying load conditions across a wide range of frequencies. A first study measured the perceptual intensity equivalence curve of gratings generated under electroadhesion and vibrotaction across the 20-400 Hz frequency range. A second study assessed the perceptual similarity between two forms of skin excitation given the same driving frequency and same perceived intensity. Our results indicate that it is largely the out-of-plane velocity that predicts vibrotactile intensity relative to shear forces generated by friction modulation. A high degree of perceptual similarity between gratings generated through friction modulation and through vibrotaction is apparent and tends to scale with actuation frequency suggesting perceptual indifference to the manner of fingerpad actuation in the upper frequency range."

This repository contains all of the code used in writing an IEEE publication
titled "Comparison of wideband vibrotactile and friction modulation surface
gratings" which can be found here:

DOI: 10.1109/TOH.2021.3075905

IEEE link: https://ieeexplore.ieee.org/document/9416877
Arxiv link: https://arxiv.org/abs/2103.16637

/C contains the embedded C code used to program PIC32 microcontroller.
Microcontroller was responsible for:

1) communication with DAC/ADC
2) applying control of 2DOF vibrotactile device
3) applying modulation to ultrasonic electroadhesion carrier to generate
surface haptics
4) interacting with MATLAB GUI to change rendering parameters of stimuli

/matlab contains experimental protocol for gathering psychophysical data
from subjects, extract a number of statistic metrics from the data, and generate
the graphics that are included in the paper.
