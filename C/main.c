#include <xc.h>          // Load the proper header for the processor
#include "interrupts.h"
#include "control.h"
#include "NU32.h"
#include "helpers.h"
#include <math.h>
#include <stdio.h>
#include "dsp.h"

int main(void) {
  int i;  // generic variable
  __builtin_disable_interrupts();
  NU32_Startup();
  digital_init();
  interrupt_init();
  SPI_com_init();
  SYN = 0;
  CNVST = 1;
  __builtin_enable_interrupts();

  NU32_ReadUART3(message,100);
  sprintf(message,"%s\n\r","CONNECTED");
  NU32_WriteUART3(message);

  while (1){
    NU32_ReadUART3(message,100);
    sscanf(message,"%c",&option);
    sprintf(message,"%c\r\n", option);
    NU32_WriteUART3(message);
    switch (option){
      case 'a': // send along desired amplitude and frequency
      amplitude = 0.0;
      __builtin_disable_interrupts();
      NU32_ReadUART3(message,100);
      sscanf(message,"%lf",&amplitude);
      NU32_ReadUART3(message,100);
      sscanf(message,"%d",&freqi);
      if(amplitude>maxamplitude[freqi]){
        amplitude = maxamplitude[freqi];
      }
      if (amplitude<.0001){
        amplitude = .0001;
      }
      halfperiod = 1/(2*freq[freqi]);
      sprintf(message,"%s\t%lf\t%s\t%lf\r\n", "amp",amplitude,"frequency",freq[freqi]);
      NU32_WriteUART3(message);
      __builtin_enable_interrupts();
      break;
      case 'z':
      amplitude = 0.0;
      avc = 0;
      break;
      case 't':
      sprintf(message,"%lf\t%lf\n\r", HALL1, HALL2);
      NU32_WriteUART3(message);
      break;
      case 'o':
      sprintf(message,"%d\n\r", chip_out2);
      NU32_WriteUART3(message);
      break;
      case 'f':
      if (clfeedback == 0){
        clfeedback = 1;
        sprintf(message, "closed loop turned on\n\r");
      } else {
        clfeedback = 0;
        sprintf(message, "closed loop turned off\n\r");
      }
      NU32_WriteUART3(message);
      break;
      case 'p':
      sprintf(message,"%lf\t%lf\n\r", HALL1amp,HALL2amp);
      NU32_WriteUART3(message);
      sprintf(message,"%lf\t%lf\t%lf\t%lf\n\r", HALL1pha, HALL2pha,control_pha_H1,control_pha_H2);
      NU32_WriteUART3(message);
      break;
      case 'w':
      NU32_ReadUART3(message,100);
      sscanf(message,"%d",&wavetype);
      break;
    }
  }
}
