z = 1; k = 1; flag = 0;
imps = []; impsm = []; force = []; forcem = []; nforce = []; nforcem = []; vels = []; velsm = []; crz = []; kinem = []; hertz = []; crf = [];
imsa = []; impsma = [];

while z<length(Di)-1 && (Di(z) == 0 || Cii(z) == 0)
    z = z + 1;
end

while z<length(Di)-1 & Cii(z)==1
    zs = z;
    while Di(z) == 1 && z<length(Di)-1
        z = z+1;
        if z==length(Dii)-1
            flag = 1;
        end
    end
    zm = z;
    z = z+1;
    if flag == 0
        while Di(z) == 0 && z<length(Di)-1
            z = z+1;
        end
        ze = z;
    end
        
    plm = poslim(zs:zm); % consider measurements in the inner region of screen
    
    Zt = Zf(zs:zm); % impedance
    Ztang = Zang(zs:zm);
    Ft = Ff(zs:zm); % reactive force
    Dt = D(zs:zm); % normal load
    Vt = dxdtenvc(zs:zm); % normal velocity
    FVt = abs(FV(zs:zm)); % scan velocity
    Ht = H(zs:zm); % scan frequency
    %
    D1 = D1lp(zs:zm);
    D2 = D2lp(zs:zm);
    if length(Ht(Ht~=0))>1
        Ht = sr./diff(Ht(Ht~=0));
    else
        Ht = 0;
    end
    
    if flag == 0
        
        plm = plm(Dt<-.01);
        Ft = Ft(Dt<-.01);
        Zt = Zt(Dt<-.01);
        Ztang = Ztang(Dt<-.01);
        Vt = Vt(Dt<-.01);
        FVt = FVt(Dt<-.01);
        D1 = D1(Dt<-.01);
        D2 = D2(Dt<-.01);        
        Dt = -Dt(Dt<-.01);

        Ft = Ft(plm);
        Zt = Zt(plm);
        Ztang = Ztang(plm);
        Vt = Vt(plm);
        FVt = FVt(plm);
        Dt = Dt(plm);        
        D1 = D1(plm);
        D2 = D2(plm);        
       
        if length(Dt)>sr/30
            
            dmax = sort(Dt);
            nforce(k) = mean(dmax(round(length(dmax)/2):length(dmax)));
            nforcem(k) = dmax(end);
            
            zmax = sort(Zt);            
            fmax = sort(Ft);
            vmax = sort(Vt);
            kmax = sort(FVt(D1<0 & D2<0));
            
            [dmax,kk]  = sort(Dt);
            
            if ~isempty(zmax)
                
                imps(k) =  mean(zmax(round(length(zmax)/2):length(zmax)));
                impsm(k) =  zmax(end);
                
                force(k) = mean(fmax(round(length(zmax)/2):length(zmax)));
                forcem(k) = fmax(end);
                
                vels(k) = median(vmax);
                velsm(k) = vmax(end);
                
                impsa(k) = median(Ztang(round(length(zmax)/2):length(zmax)));
                
                if isempty(kmax)
                    kinem(k) = 0;
                else
                    kinem(k) = median(kmax(round(length(kmax)/1.5):end));
                end
                
                hertz(k) = mean(Ht);
                
                k = k+1;
            end
        end
    end
    flag = 0;
end

impsa = mod(abs(impsa),pi).*sign(impsa);
impsa = impsa(imps>.001);
impsm = impsm(imps>.001);
force = force(imps>.001);
forcem = forcem(imps>.001);
nforce = nforce(imps>.001);
nforcem = nforcem(imps>.001);
vels = vels(imps>.001);
velsm = velsm(imps>.001);
kinem = kinem(imps>.001);
imps = imps(imps>.001);

velsend = mean(dxdtenvc(end-sr*.5:end-sr*.2));

De = D(poslim & Di & Cii);
Ze = Z(poslim & Di & Cii).';
Fe = F(poslim & Di & Cii).';


if sum(hertz>0)
    hertz = mean(hertz(hertz~=0));
    hertzs = std(hertz(hertz~=0));
else
    hertz = 0;
end
