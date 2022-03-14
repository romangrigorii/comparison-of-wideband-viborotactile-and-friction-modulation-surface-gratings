#include "dsp.h"

double rfilter(int order, double *b, double *a, double *s, double *sf){
  switch (order){
    case 1:
      return (b[0]*s[0] + b[1]*s[1] - a[1]*sf[0]);
    break;
    case 2:
      return (b[0]*s[0] + b[1]*s[1] + b[2]*s[2] - a[1]*sf[0] - a[2]*sf[1]);
    break;
    // case 3:
    //   return (b[0]*s[0] + b[1]*s[1] + b[2]*s[2] + b[3]*s[3] - a[1]*sf[0] - a[2]*sf[1] - a[3]*sf[2]);
    // break;
    // case 4:
    //   return (b[0]*s[0] + b[1]*s[1] + b[2]*s[2] + b[3]*s[3] + b[4]*s[4]- a[1]*sf[0] - a[2]*sf[1] - a[3]*sf[2] - a[4]*sf[3]);
    // break;
    // case 5:
    //   return (b[0]*s[0] + b[1]*s[1] + b[2]*s[2] + b[3]*s[3] + b[4]*s[4] + b[5]*s[5] - a[1]*sf[0] - a[2]*sf[1] - a[3]*sf[2] - a[4]*sf[3] - a[5]*sf[4]);
    // break;
    return 0.0;
  }
}
