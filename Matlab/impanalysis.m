t = (0:length(C1)-1)/sr;
s = sin(2*pi*t*freqs(tt));
c = cos(2*pi*t*freqs(tt));
s2 = sin(2*2*pi*t*freqs(tt));
c2 = cos(2*2*pi*t*freqs(tt));

M = .021;
me = .002;
ms = .0034;
b = .85;
k = 21700;
F1 = C1bp*7.4;
F2 = C2bp*7.4;
ac = (dx2dtL+dx2dtR)/2;
vcc = (dxdtL+dxdtR)/2;

vccs = (dxdtR - dxdtL)/.055.*FP + dxdtL;
vccs = filtfilt(bb,aa,vccs);

vcc2 = vcc.^2;
vccs2 = filtfilt(bb2,aa2,vccs.^2);

P1 = F1.*dxdtL;
P2 = F2.*dxdtR;
P1k = -(k.*xL).*dxdtL;
P2k = -(k.*xR).*dxdtR;
P1b = -(b.*dxdtL).*dxdtL;
P2b = -(b.*dxdtR).*dxdtR;
P1m = -(ms*dx2dtL).*dxdtL;
P2m = -(ms*dx2dtR).*dxdtR;
P1me = -(me*dx2dt1).*dxdt1;
P2me = -(me*dx2dt2).*dxdt2;
Pcm = -(M*ac).*vcc;

ta = (F2 - F1)*.055;
th = (xR - xL)/1000/.055;
om = (dxdtR-dxdtL)/.055;
al = (dx2dtR-dx2dtL)/.055;
I = ((M/12*((.110).^2)) + (me*2*(.055.^2)) + (ms*2*((.055/2).^2)));
PrF = ta.*om;
Prm = -(I.*al).*om;
Prb = -om.*om;
Prk = -th.*om;

P1 = filtfilt(bb2,aa2,P1);
P2 = filtfilt(bb2,aa2,P2);
P1k = filtfilt(bb2,aa2,P1k);
P2k = filtfilt(bb2,aa2,P2k);
P1b = filtfilt(bb2,aa2,P1b);
P2b = filtfilt(bb2,aa2,P2b);
P1m = filtfilt(bb2,aa2,P1m);
P2m = filtfilt(bb2,aa2,P2m);
P1me = filtfilt(bb2,aa2,P1me);
P2me = filtfilt(bb2,aa2,P2me);
Pcm = filtfilt(bb2,aa2,Pcm);
PrF = filtfilt(bb2,aa2,PrF);
Prm = filtfilt(bb2,aa2,Prm);
Prk = filtfilt(bb2,aa2,Prk);
Prb = filtfilt(bb2,aa2,Prb);

nums = (0:(length(Dii)-1)).'/sr;

inc = Dii & Cii;

fun = @(x,xdata) P1(inc) - Pcm(inc)/2 - (x(1) + x(2).*xdata).*P1k(inc) - (x(3) + x(4).*xdata).*P1b(inc) - P1m(inc) - P1me(inc);

x1 = lsqcurvefit(fun,[1,0,1,0],nums(inc),zeros(1,length(Pcm(inc))).',[0 -1 0 -1],[],optimset('Display','off'));

fun = @(x,xdata) P2(inc) - Pcm(inc)/2 - (x(1) + x(2).*xdata).*P2k(inc) - (x(3) + x(4).*xdata).*P2b(inc) - P2m(inc) - P2me(inc);

x2 = lsqcurvefit(fun,x1,nums(inc),zeros(1,length(Pcm(inc))).',[0 -1 x1(3)/4 -1],[],optimset('Display','off'));

P1k = P1k*x1(1);
P2k = P2k*x2(1);
P1b = P1b*x1(3);
P2b = P2b*x2(3);

fun = @(x,xdata) P1(inc) + P2(inc) - Pcm(inc) - (x(1) + x(2).*xdata).*(P1k(inc) + P2k(inc)) - (x(3) + x(4).*xdata).*(P1b(inc) +P2b(inc)) - P1m(inc) - P2m(inc) - P1me(inc) - P2me(inc) - Prm(inc);
x = lsqcurvefit(fun,[1,0,1,0],nums(inc),zeros(1,length(Pcm(inc))).',[0 -1 0 -1],[],optimset('Display','off'))

P1k = (x(1) + x(2).*nums).*P1k;
P2k = (x(1) + x(2).*nums).*P2k;
P1b = (x(3) + x(4).*nums).*P1b;
P2b = (x(3) + x(4).*nums).*P2b;


% P1k = filtfilt(bb2,aa2,P1k);
% P1b = filtfilt(bb2,aa2,P1b);
% P2k = filtfilt(bb2,aa2,P2k);
% P2b = filtfilt(bb2,aa2,P2b);
% Prk = filtfilt(bb2,aa2,Prk);
% Prm = filtfilt(bb2,aa2,Prm);
% Prb = filtfilt(bb2,aa2,Prb);

Pleft = P1 + P2 - P1k - P1b - P1m - P2k - P2b - P2m - Pcm  - P1me - P2me - Prm;

Pleft = filtfilt(bb2,aa2,Pleft);

% fun = @(x,xdata) Pleft(inc) - x(1).*Prm(inc);
% x = lsqcurvefit(fun,[1,1,1],nums(inc),zeros(1,length(Pcm(inc))).',[0,0,0],[],optimset('Display','off'));
% 
% Pleft = Pleft - Prm*x(1) - Prk*x(2) - Prb*x(3);

% Pabs = filtfilt(b2,a2,abs(Pleft))*pi/2;
% Prma = filtfilt(b2,a2,abs(PrF))*pi/2;
% vabs = filtfilt(b2,a2,abs((dxdtR + dxdtL)/2))*pi/2;
% 
% F = ((Pabs-Prma)./vabs).';
% Z = 2*F./vabs.';

Pc = filtfilt(b2,a2,4*c2.*Pleft.');
Ps = filtfilt(b2,a2,4*s2.*Pleft.');

vc = filtfilt(b2,a2,2*c.*vcc.');
vs = filtfilt(b2,a2,2*s.*vcc.');
vc2 = filtfilt(b2,a2,4*c2.*vcc2.');
vs2 = filtfilt(b2,a2,4*s2.*vcc2.');

vcs = filtfilt(b2,a2,2*c.*vccs.');
vss = filtfilt(b2,a2,2*s.*vccs.');
vcs2 = filtfilt(b2,a2,4*c2.*vccs2.');
vss2 = filtfilt(b2,a2,4*s2.*vccs2.');

% Z = divide_complex(Pc,Ps,vcs2,vss2);
% F = multiply_complex(real(Z),imag(Z),vcs,vss);

F = divide_complex(Pc,Ps,vc,vs);
Z = divide_complex(Pc,Ps,vc2,vs2);

% plot(filtfilt(bb2,aa2,(real(F).*c + imag(F).*s).*vccs.'))
% plot(filtfilt(bb2,aa2,(real(Z).*c2 + imag(Z).*s2).*vccs.'.*vccs.'))

Z(abs(Z)>2000) = 0;
F(abs(F)>2000) = 0;
Zr = filtfilt(b2,a2,real(Z));
Zi = filtfilt(b2,a2,imag(Z));
Z = filtfilt(b2,a2,abs(Z));
F = filtfilt(b2,a2,abs(F));

B(tt) = x1(3)*b;