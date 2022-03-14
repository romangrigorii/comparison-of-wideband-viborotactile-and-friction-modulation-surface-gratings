% ddpath = genpath('C:\Users\atrox\Desktop\Work\Research');
clear all
filea = 'C:\Users\atrox\Desktop\Work\Research\My projects\z Finished\A comparison of vibrotactile and friction modulation surface gratings\Data\raw data\';
fileb = 'C:\Users\atrox\Desktop\Work\Research\My projects\z Finished\A comparison of vibrotactile and friction modulation surface gratings\Data\sub data\';

addpath(genpath('C:\Users\atrox\Desktop\Work'));
gndrs = [];
ages = [];
ind = 1;

K = zeros(13,40,3);
B = zeros(13,40,3);

sr = 30000;
dur = 45*60;

[b1,a1] = butter(2,5000*2/sr,'low');
[b2,a2] = butter(2,10*2/sr,'low');
[b3,a3] = butter(2,5*2/sr,'low');
[b4,a4] = butter(2,2*2/sr,'low');
[b5,a5] = butter(2,1*2/sr,'low');
[b6,a6] = butter(2,[10,1000]*2/sr,'bandpass');
[b7,a7] = butter(3,.1*2/sr,'high');
[b8,a8] = butter(2,30*2/sr,'low');
[b9,a9] = butter(2,.5*2/sr,'low');
[b10,a10] = butter(1,5*2/sr,'low');

lpf = [1.0029,    1.0031,    1.0036,    1.0048,    1.0076,    1.0142,    1.0295,    1.0645];
latnorm = [1.0110    0.9741    0.9876    0.8709    1.1416    1.1293    1.0987    1.0602];


DATA = {};
frat = [.6 1];
fdir = {'03\','05\'};
matched = [];

dontrun = {};
dontrun{1,3} = ones(1,40); dontrun{1,4} = ones(1,40); dontrun{1,5} = ones(1,40); dontrun{1,6} = ones(1,40); dontrun{1,7} = ones(1,40);
dontrun{2,3} = ones(1,40); dontrun{2,4} = ones(1,40); dontrun{2,5} = ones(1,40); dontrun{2,6} = ones(1,40); dontrun{2,7} = ones(1,40);dontrun{2,8} = ones(1,40);dontrun{2,9} = ones(1,40);dontrun{2,10} = ones(1,40);

dontrun{1,4}(4) = 0; dontrun{1,4}(15) = 0; dontrun{1,4}(18) = 0; dontrun{1,4}(27) = 0;
dontrun{1,7}(10) = 0;
dontrun{2,5}(6) = 0; dontrun{2,5}(7) = 0; dontrun{2,5}(22) = 0; dontrun{2,5}(23) = 0; dontrun{2,5}(33) = 0; dontrun{2,5}(40) = 0; 
dontrun{2,7}(23) = 0;
dontrun{2,9}(10) = 0; dontrun{2,9}(21) = 0; dontrun{2,9}(27) = 0; dontrun{2,9}(40) = 0;


pows = linspace(-1,2,76);

Ciicordgener();

frord = zeros(13,40);

for ff = 1:2
    dira = dir(strcat(filea,fdir{ff}));
    dirb = dir(strcat(fileb,fdir{ff}));
    if ff == 1
        uarr = 3:length(dira);
    else
        uarr = 3:length(dira);
    end
    for uu = uarr
        
        % selecting file names
        load(strcat(filea,fdir{ff},dira(uu).name));
        load(strcat(fileb,fdir{ff},dirb(uu).name));
        clear exp
        gndrs(ind) = dira(uu).name(5) == 'm';
        ages(ind) = str2num(dira(uu).name(3:4));
        % extracting and filtering data
        HALL1=data(1:sr*dur,1)*0.2597;
        HALL2=data(1:sr*dur,2)*0.3837;
        curr1=-data(1:sr*dur,3)/5;
        curr2=-data(1:sr*dur,4)/5;        
        Force=data(1:sr*dur,5)*0.47619*frat(ff);
        VoltageSpeaker1=data(1:sr*dur,7);
        VoltageSpeaker2=data(1:sr*dur,8);
        Pin = double(data(1:sr*dur,6)>.5);
        
        % extracting segmented trials from overall data
        post1 = []; post2 = [];
        Pin = diff(Pin)>.5;
        arr = 1:length(Pin);
        Pin = arr(Pin);
        if ind == 8
            Pin = Pin(1:end-1);
        end        
        Pin1 = Pin(1:end-16);
        Pin2 = Pin(end-15:end);        
        post3 = Pin1(diff(Pin1)>7000);
        post1 = Pin1(diff(Pin1)<7000);
        post1 = [1,post1,Pin1(end)];        
        H1 = HALL1(post1(1):post1(2));
        while std(H1)<.0005
            post1 = post1(2:end);
            H1 = HALL1(post1(1):post1(2));
        end        
        post2 = Pin2(diff(Pin2)>7000);        
        post = [post1,post2,Pin2(end)];
        post = post([diff(post)>7000,1==1]);        
        
        DATA{ind,1,1} = [];
        DATA{ind,1,2} = [];
        DATA{ind,1,3} = [];
        DATA{ind,1,4} = [];
        DATA{ind,1,5} = [];        
        DATA{ind,2,1} = [];
        DATA{ind,2,2} = [];
        DATA{ind,2,3} = [];
        DATA{ind,2,4} = [];
        DATA{ind,2,5} = [];  
        
        freqs = [];
        fvr = 1;        
        for tt = 1:length(post)-1
            C1 = curr1(post(tt):post(tt+1));
            frdom = abs(fft(detrend(C1),3000000));
            [~,freq] = max(frdom(2001:100000));
            freq = round((freq+2001)/100);
            [~,frdom] = min(abs(freq_arr-freq));
            freqs(tt) = freq_arr(frdom);
        end
        freq_order = freq_order.';
        matched(ind) = sum(freq_order(1:32) == freqs(1:32)); % makes sure that section of extracted data correspond to correct frequencies
        hh = 1;
        
        datatofit = [1,1,1,1,1,1,1,1];

        for tt = 1:length(post)-1
            if dontrun{ff,uu}(tt) == 1
                
                fr = 1:8;
                fr = fr(freq_arr==freqs(tt));
                
                sw = ((post(tt)+45010)<post3)&((post(tt+1)-45010)>post3);
                sw = post3(sw);
                if isempty(sw)
                    sw = post(tt);
                else
                    sw = sw(end);
                end
                sw = sw - post(tt);
                
                pars1 = 1 + [-2*pi/freqs(tt),2*pi/freqs(tt)];
                pars2 = 1 + [-4*pi/freqs(tt),4*pi/freqs(tt)];
                
                [bb,aa] = butter(2,freqs(tt)*pars2*2/sr,'bandpass');
                [bb2,aa2] = butter(2,2*freqs(tt)*pars1*2/sr,'bandpass');
                [bb4,aa4] = butter(2,4*freqs(tt)*pars1*2/sr,'bandpass');                
                [bn,an] = butter(2,freqs(tt)*pars2*2/sr,'stop');
                [bn2,an2] = butter(2,2*freqs(tt)*pars2*2/sr,'stop');
                
                % extracting data from particulatr trial
                H1 = HALL1(post(tt):post(tt+1));
                H2 = HALL2(post(tt):post(tt+1));
                C1 = curr1(post(tt):post(tt+1));
                C2 = curr2(post(tt):post(tt+1));
                F = Force(post(tt):post(tt+1))*lpf(freqs(tt)==freq_arr)*latnorm(freqs(tt)==freq_arr);
                F = F - linspace(F(1),F(end),length(F)).';
                Fbp = filtfilt(bb,aa,F-filtfilt(bn,an,F));
                dcF = filtfilt(b3,a3,F);
                
                V1 = VoltageSpeaker1(post(tt):post(tt+1));
                V2 = VoltageSpeaker2(post(tt):post(tt+1));
                
                C1bp = filtfilt(bb,aa,C1);
                C2bp = filtfilt(bb,aa,C2);
                V1bp = filtfilt(bb,aa,V1);
                V2bp = filtfilt(bb,aa,V2);
                H1bp = filtfilt(bb,aa,H1);
                H2bp = filtfilt(bb,aa,H2);
                
                % extracting enevelope
                
                envH1 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(H1bp)))*pi/2;
                envH1keep = filtfilt(b2,a2,filtfilt(bn2,an2,abs(H1bp)))*pi/2;
                envH2 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(H2bp)))*pi/2;
                envH2keep = filtfilt(b2,a2,filtfilt(bn2,an2,abs(H2bp)))*pi/2;
                envC1 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(C1bp)))*pi/2;
                envC2 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(C2bp)))*pi/2;
                envV1 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(V1bp)))*pi/2;
                envV2 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(V2bp)))*pi/2;
                envF = (filtfilt(b2,a2,filtfilt(bn2,an2,abs(Fbp)))*pi/2);
                
                H1in = filtfilt(b8,a8,filtfilt(bn2,an2,abs(H1bp)))*pi/2;
                H2in = filtfilt(b8,a8,filtfilt(bn2,an2,abs(H2bp)))*pi/2;
                C1out = filtfilt(b8,a8,filtfilt(bn2,an2,abs(C1bp)))*pi/2;
                C2out = filtfilt(b8,a8,filtfilt(bn2,an2,abs(C2bp)))*pi/2;                
                
                
                didt1 = filtfilt(bb,aa,derivR(C1bp,1,sr));
                didt2 = filtfilt(bb,aa,derivR(C2bp,1,sr));                
                dxdt1 = filtfilt(bb,aa,derivR(H1bp,1,sr)/1000); % velocity on the left side
                dxdt2 = filtfilt(bb,aa,derivR(H2bp,1,sr)/1000); % velocity on the right side
                
                xL = (H1bp*86/120 + H2bp*34/120)/1000;
                xR = (H1bp*34/120 + H2bp*86/120)/1000;
                dxdtL = ((dxdt1*86/120) + (dxdt2*34/120)); % velocity on the left speakers
                dxdtR = ((dxdt1*34/120) + (dxdt2*86/120)); % velocity on the right speaker
                dxdtc = (dxdt1+dxdt2)/2;
                dxdtenvc = filtfilt(b2,a2,filtfilt(bn2,an2,abs(dxdtc)))*pi/2; 
                
                dx2dt1 = filtfilt(bb,aa,derivR(H1bp,2,sr)/1000);
                dx2dt2 = filtfilt(bb,aa,derivR(H2bp,2,sr)/1000);
                dx2dt1 = -filtfilt(bb,aa,H1bp*((2*pi*freqs(tt))^2)/1000);
                dx2dt2 = -filtfilt(bb,aa,H2bp*((2*pi*freqs(tt))^2)/1000);
                dx2dtL = (dx2dt1*86/120 + dx2dt2*34/120); % velocity on the left speakers
                dx2dtR = (dx2dt1*34/120 + dx2dt2*86/120); % velocity on the right speaker
                
                dxdtenv1 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(dxdt1)))*pi/2;
                dxdtenv2 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(dxdt2)))*pi/2;
                dx2dtenv1 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(dx2dt1)))*pi/2;
                dx2dtenv2 = filtfilt(b2,a2,filtfilt(bn2,an2,abs(dx2dt2)))*pi/2;
                
                % extracting normal load, locating contact, and extracting velocity
                 
                loadextract();                

                % locating when the speaker is actually on and impedance
                % data is best
                
                nums = 1:length(envH1);  
                Cii = zeros(size(H1));
                Cii(Ciicord(ind,tt,1):Ciicord(ind,tt,2)) = 1;
                Cii = Cii == 1;
                impanalysis2();
                
                dxdtenvc = 2*sqrt(vcc.^2 + vss.^2);
                
                % extracting finger contact time
                
                Dmin = D/min(D);
                Dmin(isnan(Dmin)) = 0;
                contv = sum(Dmin>.05)/sr;
                
                dcFmin = abs(dcF)/max(abs(dcF));
                Dmin(isnan(dcFmin)) = 0;
                contf = sum(dcFmin>.05)/sr;
                

                cont = dcFmin + Dmin;
                cont(isnan(cont)) = 0;
                cont = abs(cont)>.05;
                cont = cont.*(1:length(cont)).';
                cont = cont(cont~=0);
                if tt == 1
                    contt = cont(1)-30000;
                else
                    contt = 10001;
                end
                
                % cleaning up available raw data
                
                nums = 1:length(Z);
                envC1 = envC1(contt:end-10000);
                envV1 = envV1(contt:end-10000);
                envC2 = envC2(contt:end-10000);
                envV2 = envV2(contt:end-10000);
                Di = Di(contt:end-10000);
                D = D(contt:end-10000);
                FV = FV(contt:end-10000);
                FP = FP(contt:end-10000);
                H = H(contt:end-10000);
                Do = Do(contt:end-10000);
                D1lp = D1lp(contt:end-10000);
                D2lp = D2lp(contt:end-10000);
                Dii = Dii(contt:end-10000);
                Fii = Fii(contt:end-10000);
                envH1 = envH1(contt:end-10000);
                envH2 = envH2(contt:end-10000);
                envF = envF(contt:end-10000);
                Z = Z(contt:end-10000);
                F = F(contt:end-10000);
                Cii = Cii(contt:end-10000);
                dxdtenvc = dxdtenvc(contt:end-10000);
                
                
                envC2 = envC2(envC1>(mean(envC1)/5));
                envV1 = envV1(envC1>(mean(envC1)/5));
                envV2 = envV2(envC1>(mean(envC1)/5));
                Di = Di(envC1>(mean(envC1)/5));
                D = D(envC1>(mean(envC1)/5));
                FV = FV(envC1>(mean(envC1)/5));
                FP = FP(envC1>(mean(envC1)/5));
                H = H(envC1>(mean(envC1)/5));
                Do = Do(envC1>(mean(envC1)/5));
                D1lp = D1lp(envC1>(mean(envC1)/5));
                D2lp = D2lp(envC1>(mean(envC1)/5));
                Dii = Dii(envC1>(mean(envC1)/5));
                Fii = Fii(envC1>(mean(envC1)/5));
                envH1 = envH1(envC1>(mean(envC1)/5));
                envH2 = envH2(envC1>(mean(envC1)/5));
                envF = envF(envC1>(mean(envC1)/5));
                Z = Z(envC1>(mean(envC1)/5));
                F = F(envC1>(mean(envC1)/5));
                dxdtenvc = dxdtenvc(envC1>(mean(envC1)/5));
                Cii = Cii(envC1>(mean(envC1)/5));
                envC1 = envC1(envC1>(mean(envC1)/5));
                
                % removing bottom data
                
                poslim = FP<.055 & FP>.0;
                nums = 1:length(Z);
                
                %if sum(Dii)>10000                    
                     Zf = Z;
                     Ff = F;
%                     ZZ = interp1(nums(Dii),Z(Dii),nums);
%                     ZZ(isnan(ZZ)) = 0;
%                     ZZ = filtfilt(b4,a4,ZZ);
%                     Zf = Z - ZZ;                  
%                     Zf(Zf<0) = 0;
% 
%                     FF = interp1(nums(Dii),F(Dii),nums);
%                     FF(isnan(FF)) = 0;
%                     FF = filtfilt(b4,a4,FF);
%                     Ff = F - FF;                   
%                     Ff(Ff<0) = 0;
                     Flf = envF;
                %end                
                
                % extracting impedence
                
                impextract();
                
                % extracting lateral force
                
                lforceextract();
                
                % saving data
                
                frord(ind,tt) = freqs(tt);
                
                
                if tt<=32

                    DATA{ind,1,1}(ceil(tt/8),fr,1:length(imps),1:9) = [imps;impsm;force;forcem;nforce;nforcem;vels;velsm;kinem].';
                    DATA{ind,1,2}(ceil(tt/8),fr,1:4) = [contv,contf,hertz,hertzs];
                    DATA{ind,1,3}(ceil(tt/8),fr,1:length(lforce),1:2) = [lforce;lforcem].';
                    if length(imps)>1
                        DATA{ind,1,4}(ceil(tt/8),fr,1:9) = median([imps;impsm;force;forcem;nforce;nforcem;vels;velsm;kinem].');
                        DATA{ind,1,4}(ceil(tt/8),fr,7:8) = [velsend,vels(end)];
                        DATA{ind,1,4}(ceil(tt/8),fr,3:4) = [force(end),forcem(end)];
                    elseif imps == 1
                        DATA{ind,1,4}(ceil(tt/8),fr,1:9) = [imps;impsm;force;forcem;nforce;nforcem;vels;velsm;kinem].';
                    end
                    DATA{ind,1,4}(ceil(tt/8),fr,10:12) = [median(lforce);median(lforcem);median(lforcen)].';               
                    
                    
                    if datatofit(fr) == 1
                        datatofit(fr) = datatofit(fr)-1;
                        DATA{ind,1,4+fr} = [De,Ze,Fe];
                    else
                        DATA{ind,1,4+fr}= [DATA{ind,1,4+fr};[De,Ze,Fe]];
                    end    
                    
                    subplot(2,4,1);
                    plot(DATA{ind,1,4}(:,:,1).');
                    subplot(2,4,2);
                    plot(DATA{ind,1,4}(:,:,8).');

                    subplot(2,4,3);
                    plot(freqs(1:tt),squeeze(K(ind,1:tt,1:3)),'.')
%                     subplot(2,4,4);
%                     plot(Z(Cii));
%                     subplot(2,4,8);
%                     plot(F(Cii));

                    subplot(2,4,4);
                    plot((DATA{ind,1,4}(:,:,4)./DATA{ind,1,4}(:,:,12)).');

                    subplot(2,4,7);
                    plot(freqs(1:tt),squeeze(B(ind,1:tt,1:3)),'.')                    
                    
                    pause(.1);
                else
                    DATA{ind,2,1}(fr,1:length(imps),1:9) = [imps;impsm;force;forcem;nforce;nforcem;vels;velsm;kinem].';
                    DATA{ind,2,2}(fr,1:4) = [contv,contf,hertz,hertzs];
                    DATA{ind,2,3}(fr,1:length(lforce),1:2) = [lforce;lforcem].';
                    if length(imps)>1
                        DATA{ind,2,4}(fr,1:9) = median([imps;impsm;force;forcem;nforce;nforcem;vels;velsm;kinem].');
                        DATA{ind,2,4}(fr,7:8) = [velsend,vels(end)];
                        DATA{ind,2,4}(fr,3:4) = [force(end),forcem(end)];
                    else
                        DATA{ind,2,4}(fr,1:9) = [imps;impsm;force;forcem;nforce;nforcem;vels;velsm;kinem].';
                    end
                    DATA{ind,2,4}(fr,10:12) = [median(lforce);median(lforcem);median(lforcen)].';            
                    
                    
                    if datatofit(fr) == 1
                        datatofit(fr) = datatofit(fr)-1;
                        DATA{ind,2,4+fr} = [De,Ze,Fe];
                    else
                        DATA{ind,2,4+fr}= [DATA{ind,2,4+fr};[De,Ze,Fe]];
                    end
                    
                    
                    subplot(2,4,1);
                    plot(DATA{ind,1,4}(:,:,1).');
                    subplot(2,4,2);
                    plot(DATA{ind,1,4}(:,:,8).');

                    subplot(2,4,3);
                    plot(freqs(1:tt),squeeze(K(ind,1:tt,1:3)),'.')
                    subplot(2,4,4);
                    plot(freqs(1:tt),squeeze(K(ind,1:tt,1:3)),'.')
%                     plot(Z(Cii));
%                     subplot(2,4,8);
%                     plot(F(Cii));
                    subplot(2,4,7);
                    plot(freqs(1:tt),squeeze(B(ind,1:tt,1:3)),'.')      
                                        
                    subplot(2,4,5);
                    plot(DATA{ind,2,4}(:,1).');
                    subplot(2,4,6);
                    plot(DATA{ind,2,4}(:,8).');                   
                     
                    pause(.1);
                end
            end
            fprintf(strcat('subj \\',num2str(ind),' | trial \\', num2str(tt), ' | frequency \\', num2str(freqs(tt)),'\n'));
        end
        DATA{ind,3,1}(1:4,1:8) = test1_arr;
        DATA{ind,3,2}(1:8) = test2_arr;
        DATA{ind,3,3} = [ages(ind),gndrs(ind)];
        ind = ind + 1
        save('C:\Users\atrox\Desktop\Work\Research\My projects\z Finished\A comparison of vibrotactile and friction modulation surface gratings\Data\processed data\datay.mat','DATA','K','B','frord');
    end
end

save('C:\Users\atrox\Desktop\Work\Research\My projects\z Finished\A comparison of vibrotactile and friction modulation surface gratings\Data\processed data\datay.mat','DATA','K','B','frord');
