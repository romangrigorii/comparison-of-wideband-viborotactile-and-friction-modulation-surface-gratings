dur = 20;
sr = 100000;
st = daq.createSession('ni');
st.Rate = sr;
st.DurationInSeconds = dur;
ch1 = addAnalogInputChannel(st,'Dev1','ai1','Voltage');
ch1.InputType = 'SingleEnded'; %% lateral force
x = input('make sure to turn on the camera and set the normal stage and closed the curtain\n');
out = startForeground(st);
save('C:\Users\atrox\Desktop\Work\Research\My projects\Rendering of natural texture\data\calibration\lateral\data.mat','out','sr');

%% process
% load('C:\Users\atrox\Desktop\Work\Research\projects\Perceptual and physical model of skin vibration due to electroadhesion\data\calibration\lateral\data.mat');

i = 1;
out = detrend(out);
L = length(out) - sr;
i = 1;
tr = .5;
imps = {};
p = 0;

while i < L
    while abs(out(i))<tr && i < L
        i = i + 1;
    end
    while out(i)>(max(abs(out(i:i+1000)))*.01)
        i = i - 1;
    end
    if i < L
        i = i-1;
        p = p + 1;
        imps{p} = out(i:i+.5*sr-1);
        %imps{p} = out(i-10:i+.5*sr - 11);
        %imps{p}(1:10) = zeros(1,10);
        i = i + .25*sr;
    end
end

%% plot 
a = figure;
a.Position(3) = 400;
a.Position(4) = 120;

samp = p-1;
lim = .05;
f = linspace(0,1,2^16)*sr;
FFT1 = []; pha = [];

for s = 1:samp
    sig1 = detrend(imps{s});
    sig(1)= 0;
    sig(end) = 0;
    ff1 = fft(sig1,2^16);
    FFT1(s,:) = 20*log10(abs(ff1)); 
    pha(s,:) = angle(ff1)*180/pi;
end
    
for s = 1:samp
    m = mean(FFT1(s,round((20:1000)/sr*(2^16))));
    FFT1(s,:) = FFT1(s,:) - m;
end

shadedErrorBar(f,mean(FFT1),std(FFT1));
%plot(f,FFT1)
axis([0 1000 -9 9]);
%yticks([-6 -3 0 3 6]);

set(gcf,'color','w');
ylabel('magntiude (dB)','Interpreter', 'Latex','FontSize',9);
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
