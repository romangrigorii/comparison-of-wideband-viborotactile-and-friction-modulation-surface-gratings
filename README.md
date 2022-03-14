# comparison-of-wideband-viborotactile-and-friction-modulation-surface-gratings

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
