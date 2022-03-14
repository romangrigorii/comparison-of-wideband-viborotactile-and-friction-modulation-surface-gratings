#ifndef interrupts
#define interrupts

#define CS1 LATBbits.LATB13
#define CS2 LATBbits.LATB11
#define CS3 LATBbits.LATB12
#define SYN LATBbits.LATB9
#define CNVST LATBbits.LATB10

void chip_read_data();
void chip_write_data();
int twocompconv(int);
void pin_init();
void SPI_com_init();
void interrupt_init();
void sample_hall();
void output_compute();

// signal processing related initialization
int chip_out1 = 0, chip_out2 = 0, sig = 0, mod_out = 0;
int avc = 0, avn = 1000;
double sig1 = 0, sig2 = 0, sig1s = 0, sig2s = 0, sig1av = 0, sig2av = 0;

// chip communication related initialization
double adcbits = 65535, dacbits = 4095, t = 0.0;

// constants
double VtoD1 = 0.034, VtoD2 = 0.0325;
double LUT1[] = {100.0,110.0,105.0,100.0,75.25,7.0,100.0,380.0}, LUT2[] = {120.0,105.0,100.0,96.0,80.0,7.0,85.0,400.0};

#endif
