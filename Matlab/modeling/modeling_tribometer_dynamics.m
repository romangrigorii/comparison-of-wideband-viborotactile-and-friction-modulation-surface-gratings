% modeling speaker

m = .02/1000;
k = 23000/1000;
b = 1/1000;

K = 7.6;
sr = 5000;
freqs = round(logspace(log10(20),log10(400),8));

T = tf(K*[m b k],[1]);
[b,a] = tfdata(T);

[k,l] = bode(b,a,freqs*2*pi);

[b,a] = stoz(b{1},a{1},sr);

%% veryfying model

K = 7.6;

freqs = round(logspace(log10(20),log10(400),8));

dur = 1;
sr = 50000;
st = daq.createSession('ni');
st.Rate = sr;
st.DurationInSeconds = dur;
ch1 = addAnalogInputChannel(st,'Dev1','ai1','Voltage');
ch1.InputType = 'SingleEnded'; %% lateral force
ch2 = addAnalogInputChannel(st,'Dev1','ai9','Voltage');
ch2.InputType = 'SingleEnded'; %% normal force
ch3 = addAnalogInputChannel(st,'Dev1','ai2','Voltage');
ch3.InputType = 'SingleEnded'; %% lateral force
ch4 = addAnalogInputChannel(st,'Dev1','ai10','Voltage');
ch4.InputType = 'SingleEnded'; %% normal force

t = linspace(0,dur,dur*sr);
freqs = round(logspace(log10(20),log10(400),8));
[b,a] = butter(4,5*2/sr,'low');

DATA = [];

for i = 1:8
    x = input(strcat('put_',num2str(freqs(i)) ,'Hz'));
    
    out = startForeground(st);
    
    H1 = 2*sqrt(filter(b,a,out(:,1).*sin(2*pi*t*freqs(i)).').^2 + filter(b,a,out(:,1).*cos(2*pi*t*freqs(i)).').^2)*.034;
    H1 = mean(H1(end/2:end));
    
    H2 = 2*sqrt(filter(b,a,out(:,2).*sin(2*pi*t*freqs(i)).').^2 + filter(b,a,out(:,2).*cos(2*pi*t*freqs(i)).').^2)*.0325;
    H2 = mean(H2(end/2:end));
    
    F1 = 2*sqrt(filter(b,a,out(:,3).*sin(2*pi*t*freqs(i)).').^2 + filter(b,a,out(:,3).*cos(2*pi*t*freqs(i)).').^2)/10*K;
    F1 = mean(F1(end/2:end));
    
    F2 = 2*sqrt(filter(b,a,out(:,4).*sin(2*pi*t*freqs(i)).').^2 + filter(b,a,out(:,4).*cos(2*pi*t*freqs(i)).').^2)/10*K;
    F2 = mean(F2(end/2:end));
    
    DATA(1:4,i) = [H1,H2,F1,F2];
end
   
%%

hold on
plot(freqs,20*log10(k))
plot(freqs,20*log10(DATA(3,:)./DATA(1,:)*4))
plot(freqs,20*log10(DATA(4,:)./DATA(2,:)*4))

