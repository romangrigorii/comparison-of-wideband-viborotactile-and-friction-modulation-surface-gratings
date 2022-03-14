%% 

dur = 1;
sr = 50000;
st = daq.createSession('ni');
st.Rate = sr;
st.DurationInSeconds = dur;
ch1 = addAnalogInputChannel(st,'Dev1','ai9','Voltage');
ch1.InputType = 'SingleEnded'; %% lateral force
ch2 = addAnalogInputChannel(st,'Dev1','ai2','Voltage');
ch2.InputType = 'SingleEnded'; %% lateral force


%%
out = startForeground(st);

%% calibrating hall
t = linspace(0,dur,sr*dur);

freq = 20;

Vtovel = 10/4; % mm/s*V

[b,a] = butter(4,5*2/sr,'low');

HALLposV = out(:,1);
HALLvelV = derivR(HALLposV,1,sr);
HALLvelVa = 2*sqrt(filter(b,a,HALLvelV.*sin(2*pi*t*freq).').^2 + filter(b,a,HALLvelV.*cos(2*pi*t*freq).').^2);
HALLposVa = 2*sqrt(filter(b,a,HALLposV.*sin(2*pi*t*freq).').^2 + filter(b,a,HALLposV.*cos(2*pi*t*freq).').^2);

LDVvelVa = 2*sqrt(filter(b,a,out(:,2).*sin(2*pi*t*freq).').^2 + filter(b,a,out(:,2).*cos(2*pi*t*freq).').^2);

LDVvela = LDVvelVa*Vtovel;

Vtopos = LDVvela(end/2:end)./HALLvelVa(end/2:end);

Vtoposm = mean(Vtopos)



