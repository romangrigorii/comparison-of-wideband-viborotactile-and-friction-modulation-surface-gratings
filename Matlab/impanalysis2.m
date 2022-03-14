t = (0:length(C1)-1)/sr;
s = sin(2*pi*t*freqs(tt));
c = cos(2*pi*t*freqs(tt));
s2 = sin(2*2*pi*t*freqs(tt));
c2 = cos(2*2*pi*t*freqs(tt));

mp = .035;
mh = .0015;
mt = .0034;
M = (mp + 2*mh + 2*mt);

b = .85;
k1 = 23095;
k2 = 23000;
d = .055;

F1 = C1bp*7.4;
F2 = C2bp*7.4;

xc = (xL + xR)/2;
vc = (dxdtL+dxdtR)/2;
ac = (dx2dtL+dx2dtR)/2;

vf = dxdtL.*(d-FP)/d + dxdtR.*FP/d;

th = asin((xR - xL)/d);
om = (dxdtR-dxdtL)./cos(th/d);
al = ((dx2dtR-dx2dtL)/d + sin(th).*om.*om)./cos(th);
I = ((mp/12*((.120).^2)) + (mh*2*((.14/2).^2)) + (mt*2*((d/2).^2)));

P1 = F1;
P2 = F2;
P1k = -(k1.*xL);
P2k = -(k2.*xR);
P1b = -(b.*dxdtL);
P2b = -(b.*dxdtR);
P1m = -(1/2*M*dx2dtL);
P2m = -(1/2*M*dx2dtR);

Prm = -(I*al)/d;

% P1 = filtfilt(bb,aa,P1);
% P2 = filtfilt(bb,aa,P2);
% P1k = filtfilt(bb,aa,P1k);
% P2k = filtfilt(bb,aa,P2k);
% P1b = filtfilt(bb,aa,P1b);
% P2b = filtfilt(bb,aa,P2b);
% P1m = filtfilt(bb,aa,P1m);
% P2m = filtfilt(bb,aa,P2m);
% Prm = filtfilt(bb,aa,Prm);


nums = (0:(length(Dii)-1)).'/sr;

inc = Dii & Cii;

% if freqs(tt)>200
%     ll = [0 -1 0 -1];
%     ul = [3 1 3 1];
% else
%     ll = [0 -1 0 -1];
%     ul = [];
% end

% fun = @(x,xdata) P1(inc) - P1m(inc) - Prm(inc)*3.6 - (x(1) + x(2).*xdata).*P1k(inc) - (x(3) + x(4).*xdata).*P1b(inc);
% 
% x1 = lsqcurvefit(fun,[1,0,1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'));
% 
% fun = @(x,xdata) P2(inc) - P2m(inc) + Prm(inc)*3.6 - (x(1) + x(2).*xdata).*P2k(inc) - (x(3) + x(4).*xdata).*P2b(inc);
% 
% x2 = lsqcurvefit(fun,[1 0 1 0],nums(inc),zeros(1,length(P2m(inc))).',ll,ul,optimset('Display','off'));


    
% ll = [log(freqs(tt))/4 -1];
% ul = [log(freqs(tt))/2 1];
ll = [0 -1];
ul = [15, 1];

% fun = @(x,xdata) P1(inc) - P1m(inc) - (x(1) + x(2).*xdata).*P1k(inc) + Prm(inc)/10;
% 
% x1 = lsqcurvefit(fun,[1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'));
% 
% fun = @(x,xdata) P2(inc) - P2m(inc) - (x(1) + x(2).*xdata).*P2k(inc) - Prm(inc)/10;
% 
% x2 = lsqcurvefit(fun,[1,0],nums(inc),zeros(1,length(P2m(inc))).',ll,ul,optimset('Display','off'));
% 
% P1k = P1k.*(x1(1) + x1(2)*nums);
% P2k = P2k.*(x2(1) + x2(2)*nums);
% 
% 
% ll = [((400/freqs(tt))^.66)/2 -1];
% ul = [((400/freqs(tt))^.66)*2 1];
% 
% ll = [0 -1];
% ul = [15, 1];
% 
% fun = @(x,xdata) P1(inc) - P1m(inc) - P1k(inc) - (x(1) + x(2).*xdata).*P1b(inc) + Prm(inc)/10;
% 
% x3 = lsqcurvefit(fun,[1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'));
% 
% fun = @(x,xdata) P2(inc) - P2m(inc) - P2k(inc) - (x(1) + x(2).*xdata).*P2b(inc) - Prm(inc)/10;
% 
% x4 = lsqcurvefit(fun,[1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'));
% 
% P1b = P1b.*(x3(1) + x3(2)*nums);
% P2b = P2b.*(x4(1) + x4(2)*nums);


% if freqs(tt)>150 & freqs(tt)<300
%     fun = @(x,xdata) (P2(inc) - P1(inc)) - (P2m(inc) - P1m(inc)) - (P2k(inc) - P1k(inc)) - (P2b(inc) - P1b(inc)) - x(1)*Prm(inc);
%     xr = lsqcurvefit(fun,1,nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'))
% end

ll = [0 -1 0 -1];
ul = [];


fun = @(x,xdata) P1(inc) + P2(inc) - P1m(inc) - P2m(inc) - (x(1) + x(2).*xdata).*(P1k(inc) + P2k(inc)) - (x(3) + x(4).*xdata).*(P1b(inc) + P2b(inc));
x = lsqcurvefit(fun,[1,0,1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'))
% 
P1k = (x(1) + x(2).*nums).*P1k;
P2k = (x(1) + x(2).*nums).*P2k;
P1b = (x(3) + x(4).*nums).*P1b;
P2b = (x(3) + x(4).*nums).*P2b;

Pleft = P1 + P2 - P1k - P1b - P1m - P2k - P2b - P2m;

%Pleft = filtfilt(bb,aa,Pleft);

vcc = filtfilt(b10,a10,c.*vf.');
vss = filtfilt(b10,a10,s.*vf.');
Fc = filtfilt(b10,a10,c.*Pleft.');
Fs = filtfilt(b10,a10,s.*Pleft.');

F = Pleft.';

Z = divide_complex(Fc,Fs,vcc,vss);
Zang = filtfilt(b10,a10,unwrap(atan2(imag(Z),real(Z))));

Z = abs(Z);
%F = filtfilt(b10,a10,abs(filtfilt(bb,aa,F)))*pi/2;
F = 2*sqrt(Fc.^2 + Fs.^2);

% B(ind,tt,1:3) = [x3(1),x4(1),x(3)];
% K(ind,tt,1:3) = [x1(1),x2(1),x(1)];

B(ind,tt,1:3) = [x(3),x(3),x(3)];
K(ind,tt,1:3) = [x(1),x(1),x(1)];