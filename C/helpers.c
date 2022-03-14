#include <xc.h>          // Load the proper header for the processor
#include "interrupts.h"
#include "control.h"
#include "NU32.h"
#include <math.h>
#include "dsp.h"
#include "helpers.h"

void wait(t){ // = 8 cycles + t cycles
  int ii;
  for (ii=0;ii<t;ii++){
  }
}

void array_insert(int order, double *array, double elem){
  int i;
  for(i=order;i>0;i--){
    array[i] = array[i-1];
  }
  array[0] = elem;
}

/* atanr takes arctan of a value but

*/
double atanr(double y, double x){
  if (y>=0){
    if (x>=0){
      return atan(y/x);
    } else {
      return atan(y/x) + pi;
    }
  } else {
    if (x>=0){
      return atan(y/x);
    } else {
      return atan(y/x) - pi;
    }
  }
  //return atan(y/x) + ((double) (x<0)*((y>=0)-(y<0)))*pi;
}

double absd(double val){
  if (val>=0.0){
    return val;
  } else {
    return -val;
  }
}
