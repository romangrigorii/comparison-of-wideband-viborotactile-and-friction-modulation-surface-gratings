t = (0:length(C1)-1)/sr;
s = sin(2*pi*t*freqs(tt));
c = cos(2*pi*t*freqs(tt));
s2 = sin(2*2*pi*t*freqs(tt));
c2 = cos(2*2*pi*t*freqs(tt));

mp = .021;
mh = .002;
mt = .0034;
M = (mp + 2*mh + 2*mt);

b = .85*2.2;
k1 = 23095;
k2 = 23480;
d = .055;

F1 = C1bp*7.4;
F2 = C2bp*7.4;

xc = (xL + xR)/2;
vc = (dxdtL+dxdtR)/2;
ac = (dx2dtL+dx2dtR)/2;

th = asin((xR - xL)/d);
om = (dxdtR-dxdtL)./cos(th/d);
al = ((dx2dtR-dx2dtL)/d+ sin(th).*om.*om)./cos(th);
I = ((mp/12*((.110).^2)) + (mh*2*((.12/2).^2)) + (mt*2*((d/2).^2)));

P1 = F1;
P2 = F2;
P1k = -(k1.*xL);
P2k = -(k2.*xR);
P1b = -(b.*dxdtL);
P2b = -(b.*dxdtR);
P1m = -(49.3/100*M*dx2dtL);
P2m = -(42.5/100*M*dx2dtR);
Prm = -(I*al)/d;

P1 = filtfilt(bb,aa,P1);
P2 = filtfilt(bb,aa,P2);
P1k = filtfilt(bb,aa,P1k);
P2k = filtfilt(bb,aa,P2k);
P1b = filtfilt(bb,aa,P1b);
P2b = filtfilt(bb,aa,P2b);
P1m = filtfilt(bb,aa,P1m);
P2m = filtfilt(bb,aa,P2m);
Prm = filtfilt(bb,aa,Prm);


nums = (0:(length(Dii)-1)).'/sr;

F = zeros(size(nums)).';

if freqs(tt)>200
    ll = [0 -1 .25 -1];
    ul = [3 1 3 1];
else
    ll = [0 -1 0 -1];
    ul = [];
end

sgm = diff(filter(b3,a3,abs(filter(b3,a3,derivR(filter(b3,a3,filter(bn2,an2,(abs(P1)/max(P1)))),1,sr)))>.075)>.3)>0;
sgm = sgm.'.*(1:length(sgm));
sgm = sgm(sgm~=0);

for sg = 1:length(sgm)-1
    tk = zeros(1,length(P1));
    tk(sgm(sg):sgm(sg+1)) =  1;
    inc = (tk.*Dii.').' == 1;
    
    if sum(inc)>1000
        
        fun = @(x,xdata) P1(inc) - P1m(inc) + Prm(inc) - x(1).*P1k(inc) - x(2).*P1b(inc);
        
        x1 = lsqcurvefit(fun,[1,0,1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'));
        
        fun = @(x,xdata) P2(inc) - P2m(inc) - Prm(inc) - x(1).*P2k(inc) - x(2).*P2b(inc);
        
        x2 = lsqcurvefit(fun,[1 0 1 0],nums(inc),zeros(1,length(P2m(inc))).',ll,ul,optimset('Display','off'));
        
        P1kn = P1k*x1(1);
        P2kn = P2k*x2(1);
        P1bn = P1b*x1(2);
        P2bn = P2b*x2(2);
        
%         fun = @(x,xdata) P1(inc) + P2(inc) - P1m(inc) - P2m(inc) - (x(1) + x(2).*xdata).*(P1k(inc) + P2k(inc)) - (x(3) + x(4).*xdata).*(P1b(inc) +P2b(inc));
%         x = lsqcurvefit(fun,[1,0,1,0],nums(inc),zeros(1,length(P1m(inc))).',ll,ul,optimset('Display','off'))
%         
%         P1kn = (x(1) + x(2).*nums).*P1kn;
%         P2kn = (x(1) + x(2).*nums).*P2kn;
%         P1bn = (x(3) + x(4).*nums).*P1bn;
%         P2bn = (x(3) + x(4).*nums).*P2bn;
        
        Pleft = P1 + P2 - P1kn - P1bn - P1m - P2kn - P2bn - P2m;
        
        Pleft = filtfilt(bb,aa,Pleft);
        
        F = Pleft.'.*tk + F;
    end
end

vcc = filtfilt(b2,a2,c.*vc.');
vss = filtfilt(b2,a2,s.*vc.');
Fc = filtfilt(b2,a2,c.*Pleft.');
Fs = filtfilt(b2,a2,s.*Pleft.');


Z = divide_complex(Fc,Fs,vcc,vss);

Z = filtfilt(b2,a2,abs(Z));
F = filtfilt(b2,a2,abs(F))*pi/2;

B(tt,1:2) = [x1(3),x2(3)];
K(tt,1:2) = [x1(1),x2(1)];