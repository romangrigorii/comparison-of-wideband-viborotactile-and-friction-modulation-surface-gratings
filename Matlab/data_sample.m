clear all
dur = 1;
sr = 50000;
st = daq.createSession('ni');
st.Rate = sr;
st.DurationInSeconds = dur;
% ch1 = addAnalogInputChannel(st,'Dev1','ai9','Voltage');
% ch1.InputType = 'SingleEnded'; %% lateral force
% ch1 = addAnalogInputChannel(st,'Dev1','ai2','Voltage');
% ch1.InputType = 'SingleEnded'; %% lateral force
ch1 = addAnalogInputChannel(st,'Dev1','ai10','Voltage');
ch1.InputType = 'SingleEnded'; %% lateral force
ch1 = addAnalogInputChannel(st,'Dev1','ai3','Voltage');
ch1.InputType = 'SingleEnded'; %% lateral force
% DATA = {};
% 
for i = 1:10
    x = input('make sure to turn on the camera and set the normal stage and closed the curtain\n');
    out = startForeground(st);
    DATA{i} = out;
end