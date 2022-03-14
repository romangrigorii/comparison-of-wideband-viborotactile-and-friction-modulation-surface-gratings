#include <xc.h>          // Load the proper header for the processor
#include "interrupts.h"
#include "control.h"
#include "NU32.h"
#include <math.h>
#include "helpers.h"
#include "dsp.h"

void vib_control(){
  if (clfeedback == 1){
    // computing hall effect 1
    HALL1c = cos(2*pi*freq[freqi]*t)*HALL1;
    HALL1s = sin(2*pi*freq[freqi]*t)*HALL1;
    array_insert(2,HALL1ca,HALL1c);
    array_insert(2,HALL1sa,HALL1s);
    HALL1cf = rfilter(2,lp1b,lp1a,HALL1ca,HALL1cfa);
    HALL1sf = rfilter(2,lp1b,lp1a,HALL1sa,HALL1sfa);
    array_insert(2,HALL1cfa,HALL1cf);
    array_insert(2,HALL1sfa,HALL1sf);
    HALL1amp = sqrt((HALL1cf*HALL1cf) + (HALL1sf*HALL1sf))*2;
    HALL1pha = atan2(HALL1sf,HALL1cf);

    // computing hall effect 2
    HALL2c = cos(2*pi*freq[freqi]*t)*HALL2;
    HALL2s = sin(2*pi*freq[freqi]*t)*HALL2;
    array_insert(2,HALL2ca,HALL2c);
    array_insert(2,HALL2sa,HALL2s);
    HALL2cf = rfilter(2,lp1b,lp1a,HALL2ca,HALL2cfa);
    HALL2sf = rfilter(2,lp1b,lp1a,HALL2sa,HALL2sfa);
    array_insert(2,HALL2cfa,HALL2cf);
    array_insert(2,HALL2sfa,HALL2sf);
    HALL2amp = sqrt((HALL2cf*HALL2cf) + (HALL2sf*HALL2sf))*2;
    HALL2pha = atan2(HALL2sf,HALL2cf);

    // comuting error and control
    error_amp_H1 = amplitude - HALL1amp;
    error_amp_H2 = amplitude - HALL2amp;
    error_pha_H1 = HALL1pha;
    error_pha_H2 = HALL2pha;
    array_insert(2,error_amp_H1a,error_amp_H1);
    array_insert(2,error_amp_H2a,error_amp_H2);
    array_insert(2,error_pha_H1a,error_pha_H1);
    array_insert(2,error_pha_H2a,error_pha_H2);
    control_amp_H1 = rfilter(2,c1b,c1a,error_amp_H1a,control_amp_H1fa);
    if (control_amp_H1<0.0){
      control_amp_H1 = 0.0;
    }
    control_amp_H2 = rfilter(2,c1b,c1a,error_amp_H2a,control_amp_H2fa);
    if (control_amp_H2<0.0){
      control_amp_H2 = 0.0;
    }
    control_pha_H1 = rfilter(2,c1b,c1a,error_pha_H1a,control_pha_H1fa);
    control_pha_H2 = rfilter(2,c1b,c1a,error_pha_H2a,control_pha_H2fa);
    array_insert(2,control_amp_H1fa,control_amp_H1);
    array_insert(2,control_amp_H2fa,control_amp_H2);
    array_insert(2,control_pha_H1fa,control_pha_H1);
    array_insert(2,control_pha_H2fa,control_pha_H2);

    TRANS1 = LUT1[freqi]*control_amp_H1*sin((2*pi*freq[freqi]*t) + control_pha_H1);
    TRANS2 = LUT2[freqi]*control_amp_H2*sin((2*pi*freq[freqi]*t) + control_pha_H2);
  }
  else {
    switch(wavetype){
      case 0:
      wavefunc = sin(2*pi*freq[freqi]*t);
      break;
      case 1:
      wavefunc = 2*((double) sin(2*pi*freq[freqi]*t)>0)-1;
      break;
      case 2:
      wavefunc = 2*(halfperiod - absd(fmod(t,2*halfperiod) - halfperiod))/halfperiod - 1;
      break;
    }
    TRANS1 = amplitude*wavefunc;
    TRANS2 = amplitude*wavefunc;
  }
}
