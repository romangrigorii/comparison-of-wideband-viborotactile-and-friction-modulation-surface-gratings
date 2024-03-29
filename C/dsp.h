#ifndef dsp
#define dsp

// lowpass
double HALL1ca[] = {0.0,0.0,0.0}, HALL1cfa[] = {0.0,0.0,0.0}, HALL1sa[] = {0.0,0.0,0.0}, HALL1sfa[] = {0.0,0.0,0.0};
double HALL2ca[] = {0.0,0.0,0.0}, HALL2cfa[] = {0.0,0.0,0.0}, HALL2sa[] = {0.0,0.0,0.0}, HALL2sfa[] = {0.0,0.0,0.0};
double error_amp_H1a[] = {0.0,0.0,0.0}, error_amp_H2a[] = {0.0,0.0,0.0}, error_pha_H1a[] = {0.0,0.0,0.0}, error_pha_H2a[] = {0.0,0.0,0.0};
double control_amp_H1fa[] = {0.0,0.0,0.0}, control_amp_H2fa[] = {0.0,0.0,0.0}, control_pha_H1fa[] = {0.0,0.0,0.0}, control_pha_H2fa[] = {0.0,0.0,0.0};

double lp1a[] = {1.0, -1.9777864837767633598986094511929, 0.97803050849179551384793285251362};
double lp1b[] = {0.000061006178758066236130202381060528, 0.00012201235751613247226040476212106, 0.000061006178758066236130202381060528}; // 10Hz

double c1a[] = {1.0, -1.9833891161522251146646832775505, 0.98338911615222511466468327755051};
double c1b[] = {0.000015185322920540474182478710152289, 0.000030370645841080948364957420304577, 0.000015185322920540474182478710152289}; // closed loop

double rfilter();

#endif
