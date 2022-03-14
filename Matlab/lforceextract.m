z = 1; k = 1; flag = 0;
lforce = []; lforcem = []; lforcen = [];

while z<length(Fii)-1 & Fii(z) == 1
    z = z + 1;
end

while z<length(Fii)-1
    zs = z;
    while Fii(z) == 0 && z<length(Fii)-1
        if z<length(Fii)-1
            z = z+1;
        else
            flag = 1;
        end
        
    end
    
    zm = z;
    z = z+1;
    
    if flag == 0
        while Fii(z) == 1 && z<length(Fii)-1
            if z<length(Dii)-1
                z = z+1;
            else
                flag = 1;
            end
        end
    end
    
    if flag == 0
        Ft = Flf(zs:zm);
        fmax = sort(Ft(Ft>.005));
        if ~isempty(fmax)
            lforce(k) =  median(fmax); % median(fmax(round(end/2):end));
            lforcem(k) =  fmax(end);
            lforcen(k) = median(fmax(end/2:end));
            k = k+1;
        end
    end
    flag = 0;
end