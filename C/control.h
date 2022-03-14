#ifndef control
#define control

void vib_control();

// message related things
char message[100], option;

// vibration specific parameters
int clfeedback = 0;
double HALL1 = 0, HALL1c = 0, HALL1cf = 0, HALL1s = 0, HALL1sf = 0, HALL1amp = 0, HALL1pha = 0.0, error_amp_H1 = 0, error_pha_H1 = 0, control_amp_H1 = 0, control_pha_H1 = 0;
double HALL2 = 0, HALL2c = 0, HALL2cf = 0, HALL2s = 0, HALL2sf = 0, HALL2amp = 0, HALL2pha = 0.0, error_amp_H2 = 0, error_pha_H2 = 0, control_amp_H2 = 0, control_pha_H2 = 0;
double TRANS1 = 0, TRANS2 = 0;
double amplitude = 0.0, freq[] = {20,31,47,72,111,170,261,400}, maxamplitude[] = {.119,.077,.0501,.0332,.0215,.014,.0091,.006}, halfperiod = 0.0, wavefunc = 0.0;
int freqi = 5, wavetype = 0;

double a = 1.0, b = 2.0;
#endif
