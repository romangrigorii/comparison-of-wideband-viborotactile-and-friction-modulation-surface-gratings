% addpath(genpath('C:\Users\atrox\Desktop\Work\Research\'));
%% 
sr = 5000;
t = linspace(0,1,sr);
[b1,a1] = butter(2,20*2/sr,'low');
[b2,a2] = butter(2,10*2/sr,'low');
f = 200;

sig = .3*sin(2*pi*t*f + .5);
sigs = sig.*sin(2*pi*t*f);
sigc = sig.*cos(2*pi*t*f);
hold on
% plot(t,filter(b2,a2,sqrt(filter(b1,a1,sigs).^2 + filter(b1,a1,sigc).^2)*2));
% plot(t,atan2(filter(b1,a1,sigc),filter(b1,a1,sigs)))

plot(t,filter(b1,a1,sigs).*sin(2*pi*t*f));
%plot(t,filter(b1,a1,sigs));

%% list of control
sr = 30000;
SINAL = [];
SINBL = [];
freqs = logspace(log10(100),log10(200),2);

for f = 1:2
    [b,a] = butter(2,freqs(f)*2/sr,'low');
    SINBL(f,1:3) = b;
    SINAL(f,1:3) = a;
end
%% controls > 150 HZ

P = 1;
[b,a] = butter(2,85*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,40*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);

C1des = T/(1-T*C2);
C1 = tf(1,[1 0])*tf(70,[1 500])*800/P;
Tact = C1/(1+C1*C2);
hold on


bode(T);
bode(Tact);

[b,a] = tfdata(C1);
b = b{1};
a = a{1};
[bd,ad] = stoz(b,a,sr);
vpa(bd)
vpa(ad)
% 
bode(C1des);
bode(C1);

%% controller 1
P = 1;
[b,a] = butter(2,85*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,10*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);

C1des = T/(1-T*C2);
C1 = tf(1,[1 0])*tf(70,[1 67])*14/P;
Tact = C1/(1+C1*C2);
hold on


% bode(T);
% bode(Tact);

[b,a] = tfdata(C1);
b = b{1};
a = a{1};
[bd,ad] = stoz(b,a,sr);
vpa(bd)
vpa(ad)

bode(C1des);
bode(C1);

%% controller 2

P = 1;
[b,a] = butter(2,10*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,5*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);

C1des = T/(1-T*C2);
C1 = tf(1,[1 0])*tf(70,[1 67])*14;
Tact = C1/(1+C1*C2);
hold on


bode(T);
bode(Tact);

[b,a] = tfdata(C2);
b = b{1};
a = a{1};
[bd,ad] = stoz(b,a,sr);
vpa(bd)
vpa(ad)

bode(C1des);
bode(C1);

%% controller 3

P = 1;
[b,a] = butter(2,15*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,10*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);

C1des = T/(1-T*C2);
C1 = tf(1,[1 0])*tf(140^2,[1 1.1*140 (140^2)])*tf([1 150],150)*25;
Tact = C1/(1+C1*C2);

hold on
bode(C1des);
bode(C1);


hold on
bode(T);
bode(Tact);

[b,a] = tfdata(C1);
b = b{1};
a = a{1};
[bd,ad] = stoz(b,a,sr);
vpa(bd)
vpa(ad)



%% plotting
[a1,b1,c1] = bode(C1,logspace(-2,3,100000)*2*pi);
[a2,b2,c2] = bode(C1des,logspace(-2,3,100000)*2*pi);
[a3,b3,c3] = bode(T,logspace(-2,3,100000)*2*pi);
[a4,b4,c4] = bode(Tact,logspace(-2,3,100000)*2*pi);

a = figure;
a.Position(3) = 400;
a.Position(4) = 125;
hold on
subplot(1,2,1)
hold on
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a2))));
a.Color = [0 0 0];
a.LineWidth = 1;
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a1))),'--');
a.Color = [1 0 0];
a.LineWidth = 1;
axis([.1 1000 -70 40])
set(gca, 'XScale', 'log')
ylabel('magnitude (dB)','Interpreter','latex','FontSize',10);
xticks([.1 1 10 100 1000])
yticks([-60 -30 0 30]);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
a = legend('C desired','C designed','Interpreter','latex','FontSize',10);
a.Location = 'southwest';
a.Box = 'off';
subplot(1,2,2)
hold on
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a3))));
a.Color = [0 0 0];
a.LineWidth = 1;


Tact = .5*C1/(1+C1*.5*C2);
[a4,b4,c4] = bode(Tact,logspace(-2,3,100000)*2*pi);
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a4))));
a.Color = [.5 .5 .5];
a.LineWidth = .5;
Tact = .25*C1/(1+C1*.25*C2);
[a4,b4,c4] = bode(Tact,logspace(-2,3,100000)*2*pi);
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a4))));
a.Color = [.5 .5 .5];
a.LineWidth = .5;
Tact = .1*C1/(1+C1*.1*C2);
[a4,b4,c4] = bode(Tact,logspace(-2,3,100000)*2*pi);
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a4))));
a.Color = [.5 .5 .5];
a.LineWidth = .5;
Tact = C1/(1+C1*C2);
[a4,b4,c4] = bode(Tact,logspace(-2,3,100000)*2*pi);
a = plot(logspace(-2,3,100000),20*log10(squeeze(abs(a4))),'--');
a.Color = [1 0 0];
a.LineWidth = 1;
axis([.1 1000 -70 40])
set(gca, 'XScale', 'log')
xlabel('frequency (Hz)','Interpreter','latex','FontSize',10);
xticks([.1 1 10 100 1000]);
yticks([-60 -30 0 30]);
a = legend('T desired','T designed','Interpreter','latex','FontSize',10);
a.Location = 'southwest';
a.Box = 'off';
set(gca,'TickLabelInterpreter','latex','FontSize',9);
set(gcf,'color','w');


%%
set(gca,'TickLabelInterpreter','latex')

r = linspace(0,.5,100);
B = [];

for i = 1:100

P = 1;
[b,a] = butter(2,10*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,5*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);

C1des = T/(1-T*C2);
C1 = tf(1,[1 0])*tf(70,[1 67])*14/(1+.26);
Tact = C1/(1+C1*C2);

B(i) = bandwidth(Tact)/2/pi;

end

%% 
sr = 30000;
C = tf([((2*pi*1000)^2)],[1 1.4*1000*2*pi ((2*pi*1000)^2)]);
[b,a] = tfdata(C*C*C*tf([1 0 0],[1]));
b = b{1};
a = a{1};
[bd,ad] = stoz(b,a,30000);