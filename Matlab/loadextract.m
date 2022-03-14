nums = 1:length(H1);

D1lp = filtfilt(b2,a2,filtfilt(bn,an,H1))*22900/1000;
D2lp = filtfilt(b2,a2,filtfilt(bn,an,H2))*22400/1000;

D1lp = D1lp*86/120 + D2lp*34/120;
D2lp = D1lp*34/120 + D2lp*86/120;

Do = D1lp+D2lp;
Dod1 = filtfilt(b4,a4,abs(filtfilt(b3,a3,derivR(D1lp,1,sr))));
Dodi1 = Dod1<.05;
Dod2 = filtfilt(b4,a4,abs(filtfilt(b3,a3,derivR(D2lp,1,sr))));
Dodi2 = Dod2<.05;
Dodi = Dodi1.*Dodi2;

flag = 0;
for i = 1:round(length(Dodi)/100)-1
    
    indx = i*100;
    
    if flag == 0 & Dodi(indx) == 1
        flag = 1;
        count = 1;
        st = indx;
    end
    
        
    if flag == 1 
        if count<100
            count = count + 1;
        else
            flag = 2;
        end
    end
    
    if Dodi(indx) == 0 
        if flag == 1
            
            Dodi(st-100+1:indx) = 0;
        end
        
        if flag == 2
            flag = 0;
        end
    end
end   
    

Dodi = Dodi == 1;

D1lpf = interp1(nums(Dodi),D1lp(Dodi),nums);
D2lpf = interp1(nums(Dodi),D2lp(Dodi),nums);

D1lp = D1lp - D1lpf.';
D2lp = D2lp - D2lpf.';

D1lp(isnan(D1lp)) = 0;
D2lp(isnan(D2lp)) = 0;


D = D1lp+D2lp;
D(D>0) = 0;
D(D>-.01) = 0;

Dii = D>-.01;
Dii = filtfilt(b4,a4,Dii+0);
Dii = Dii>.99;

Di = D<-.01;
Di = filtfilt(b4,a4,Di+0);
Di = Di>.95;

Fod = filtfilt(b4,a4,abs(derivR(envF,1,sr)))<.01 & envF<.005;
Fnoise = interp1(nums(Fod),envF(Fod),nums).';
envF = envF - Fnoise;
Fii = envF>.001;
Fii = filtfilt(b2,a2,Fii+0);
Fii = Fii<.5;

FP = .055./(D1lp./(D2lp+.001) + 1);
FP(D>.025 | isnan(FP) | ~Di | Dii) = .055/2;

FV = abs(filtfilt(b2,a2,derivR(FP,1,sr)));
FV(Di & Dii) = 0;

H = .055./(D1lp./D2lp + 1);
H(D>.025 | isnan(FP) | ~Di | Dii) = 0;
H = abs(H - .055/2);
Hs = zeros(1,length(H));
for i = 2:length(H)-1
    if H(i-1)>H(i) && H(i+1)>H(i) && H(i)<.0001
        Hs(i) = 1;
    end
end
H = Hs.*nums;


