#include <xc.h>          // Load the proper header for the processor
#include "interrupts.h"
#include "control.h"
#include "NU32.h"
#include "helpers.h"
#include <math.h>
#include <stdio.h>
#include "dsp.h"

void digital_init(){
  TRISBbits.TRISB10 = 0;  // CNVST pin
  TRISBbits.TRISB9 = 0;  // SYN pin
  TRISBbits.TRISB11 = 0; // DAC1 spi CS
  TRISBbits.TRISB12 = 0; // DAC2 spi CS
  TRISBbits.TRISB13 = 0; // ADC spi CS
}

void SPI_com_init(){
  // setting up communication with ADC
  CS1 = 1;
  SPI3CON = 0;
  SPI3BRG = 10; // communication at 640kHz
  SPI3BUF;
  SPI3BUF;
  SPI3STATbits.SPIROV = 0;
  SPI3CONbits.MODE32 = 1;
  SPI3CONbits.MODE16 = 0;
  SPI3CONbits.MSTEN = 1;
  SPI3CONbits.CKE = 1;
  SPI3CONbits.CKP = 0;
  SPI3CONbits.SMP = 0;
  SPI3CONbits.ON = 1;

  // setting up communiction with DAC
  CS2 = 1;
  CS3 = 1;
  SPI4CON = 0;
  SPI4BRG = 39;
  SPI4BUF;
  SPI4BUF;
  SPI4STATbits.SPIROV = 0;
  SPI4CONbits.MODE32 = 0;
  SPI4CONbits.MODE16 = 1;
  SPI4CONbits.MSTEN = 1;
  SPI4CONbits.CKE = 0;
  SPI4CONbits.CKP = 1;
  SPI4CONbits.SMP = 0;
  SPI4CONbits.ON = 1;
}

void chip_write_data(){
  // writing to control transducers
  CS2 = 0;
  SPI4BUF = chip_out1 & 0x0FFF | 0x7000;
  while(!SPI4STATbits.SPIRBF){
  }
  SPI4BUF;
  CS2 = 1;
  wait(100);
  CS2 = 0;
  SPI4BUF = chip_out2 & 0x0FFF | 0xF000;
  while(!SPI4STATbits.SPIRBF){
  }
  SPI4BUF;
  CS2 = 1;

  // writing to produce carrier modulation

  CS3 = 0;
  SPI4BUF = 0x7000 | mod_out;
  while(!SPI4STATbits.SPIRBF){
  }
  SPI4BUF;
  CS3 = 1;
}

int twocompconv(int s){
  if (s>=8192){
    s = s - 8192;
  } else {
    s = s + 8191;
  }
  return s;
}

void chip_read_data(){
  CNVST = 0;
  wait(2);
  CNVST = 1;
  wait(5);
  CS1 = 0;
  SPI3BUF = 0;
  while(!SPI3STATbits.SPIRBF){
  }
  sig = SPI3BUF;
  CS1 = 1;
  sig1 = (long double) twocompconv((sig>>4) & 0x3FFF);
  sig2 = (long double) twocompconv((sig>>18) & 0x3FFF);
}

void interrupt_init(){
  // vibration control interrupt
  PR4 =  19950; // freq = 80,000,000/(1+7999) = 10kHz
  TMR4 = 0;
  T4CONbits.TCKPS = 0;
  T4CONbits.ON = 1;
  IPC4bits.T4IP = 5;
  IPC4bits.T4IS = 0;
  IFS0bits.T4IF = 0;
  IEC0bits.T4IE = 1;
}

void find_avg(){
  if (avc<avn){
    sig1s = sig1s + sig1;
    sig2s = sig2s + sig2;
    avc++;
    if (avc==avn){
      sig1av = sig1s/((long double) avn);
      sig2av = sig2s/((long double) avn);
      sig1s = 0.0;
      sig2s = 0.0;
    }
  }
}

void sample_hall(){ // readings are in mN
  chip_read_data();
  HALL1 = (sig1 - sig1av)/adcbits*VtoD1*20.0;
  HALL2 = (sig2 - sig2av)/adcbits*VtoD2*20.0;
}

void output_compute(){
  chip_out1 = (int) ((TRANS2 + 5.0)/10.0*dacbits);
  chip_out2 = (int) ((TRANS1 + 5.0)/10.0*dacbits);

  //mod_out = (int) (sqrt((sin(2*pi*t*freq[freqi])+1)/2)*.5*dacbits);

  if (chip_out1 > dacbits){
    chip_out1 = (int) dacbits;
  }
  if (chip_out1 < 0){
    chip_out1 = 0;
  }
  if (chip_out2 > dacbits){
    chip_out2 = (int) dacbits;
  }
  if (chip_out2 < 0){
    chip_out2 = 0;
  }
}

void __ISR(_TIMER_4_VECTOR,IPL5SOFT) Timer4ISR(void){
  // friction sample, filter, and feedback routine
  t += .00025;
  sample_hall();
  find_avg();
  vib_control();
  output_compute();
  chip_write_data();
  IFS0bits.T4IF = 0;
}
