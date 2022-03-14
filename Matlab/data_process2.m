%% parsing averaged data 
freq_arr = round(logspace(log10(20),log10(400),8));
load('C:\Users\atrox\Desktop\Work\Research\My projects\z Finished\A comparison of vibrotactile and friction modulation surface gratings\Data\processed data\datay.mat');

% 1 : imps
% 2 : impsm 
% 3 : force
% 4 : forcem
% 5 : nforce
% 6 : nforcem
% 7 : vels
% 8 : velsm
% 9 : kinem
                    
DATA1a = [];
DATA1b = [];
DATA1c = [];

nforecet = [];

for i = 1:13
    for f = 1:8
        imps = []; impsm = []; kinem = []; nforce = []; force = []; lforce = []; vels = []; contv = []; contf = []; hertz = []; nforcet = [];
        for t = 1:4
            data = squeeze(DATA{i,1,1}(t,f,:,:));
            imps = [imps,data(:,1).'];
            impsm = [impsm,data(:,2).'];
            kinem = [kinem,data(:,9).'];
            nforce = [nforce,data(:,5).'];
            
            kn = 1;
            for k = 1:length(data(:,3))
                if data(k,3)>0
                    kn = k; % grab last force reading
                end
            end
            
            nforcet = [nforcet,data(kn,5)];
            vels =[vels,data(kn,8).'];
            force = [force,data(kn,3).'];           
            
            data = squeeze(DATA{i,1,2}(t,f,:));
            
            contv = [contv,data(1)];
            contf = [contf,data(2)];
            hertz = [hertz,data(3)];
            
            data = squeeze(DATA{i,1,3}(t,f,:,1));            
            lforce = [lforce,median(data(data~=0 & ~isnan(data)).')];
            
        end
        
        [fs,~,~] = size(squeeze(DATA{i,2,1}));
        
        if f<=fs
            data = squeeze(DATA{i,2,1}(f,:,:));
            imps = [imps,data(:,1).'];
            impsm = [impsm,data(:,2).'];
            kinem = [kinem,data(:,9).'];
            nforce = [nforce,data(:,5).'];
        end
        
        
        DATA1a{i,f}(1,1:sum(imps~=0)) = imps(imps~=0);
        DATA1a{i,f}(2,1:sum(imps~=0)) = kinem(imps~=0);
        DATA1a{i,f}(3,1:sum(imps~=0)) = nforce(imps~=0);
        DATA1b{i,f}(1,1:4) = vels;        
        DATA1b{i,f}(2,1:4) = force;
        DATA1b{i,f}(3,1:4) = lforce;
        DATA1b{i,f}(4,1:4) = vels./lforce;
        DATA1b{i,f}(5,1:4) = force./lforce;    
        DATA1b{i,f}(6,1:4) = nforcet;
        DATA1c{i,f}(1,1:4) = contv;
        DATA1c{i,f}(2,1:4) = contf;
        DATA1c{i,f}(3,1:4) = hertz;
    end
end

%% grouping into subject/frequency matrices for first experiment using raw + aggregate data

nforce = []; imp = []; lforce = []; vel = []; force = []; timv = []; 
lvrat = []; ff = []; lfrat = []; kinemm = []; hertz = []; jndv = []; jndf = [];
lfratt = []; lvratt = [];

for f = 1:8
    for i = 1:13
        
        imp(i,f) = median(DATA1a{i,f}(1,:));
        kinemm(i,f) = median(DATA1a{i,f}(2,:));
        kinems(i,f) = std(DATA1a{i,f}(2,:));
        nforce(i,f) = median(DATA1a{i,f}(3,:));   
        
        vel(i,f) = median(DATA1b{i,f}(1,:));
        nforcet(i,f) = median(DATA1b{i,f}(6,:));   
        jndv(i,f) = std(DATA1b{i,f}(1,DATA1b{i,f}(1,:)~=0 & ~isnan(DATA1b{i,f}(1,:))))/mean(DATA1b{i,f}(1,DATA1b{i,f}(1,:)~=0 & ~isnan(DATA1b{i,f}(1,:))));
        if length(DATA1b{i,f}(1,DATA1b{i,f}(1,:)~=0 & ~isnan(DATA1b{i,f}(1,:))))<4
            jndv(i,f) = 0;
         end
        
        force(i,f) = median(DATA1b{i,f}(2,:));
        jndf(i,f) = std(DATA1b{i,f}(2,DATA1b{i,f}(2,:)~=0 & ~isnan(DATA1b{i,f}(2,:))))/mean(DATA1b{i,f}(2,DATA1b{i,f}(2,:)~=0 & ~isnan(DATA1b{i,f}(2,:))));
        if length(DATA1b{i,f}(2,DATA1b{i,f}(2,:)~=0 & ~isnan(DATA1b{i,f}(2,:))))<4
            jndf(i,f) = 0;
        end
        
        lforce(i,f) = median(DATA1b{i,f}(3,:));
        lvrat(i,f) = median(DATA1b{i,f}(4,~isnan(DATA1b{i,f}(4,:))));
        lfrat(i,f) = median(DATA1b{i,f}(5,~isnan(DATA1b{i,f}(5,:))));
        lvratt(i,f,1:4) = DATA1b{i,f}(4,:);
        lfratt(i,f,1:4) = DATA1b{i,f}(5,:);        
        timv(i,f) = median(DATA1c{i,f}(1,:));
        timf(i,f) = median(DATA1c{i,f}(2,:));
        hertz(i,f) = median(DATA1c{i,f}(3,~isnan(DATA1c{i,f}(3,:))));

        ff(i,f) = f;
    end
end

%% plotting normal force vs velocity

a = figure;
a.Position(3) = 200;
a.Position(4) = 150;

mn = mean(nforce.');
mna = nforce(:);
mia = lvrat(:);
toremove = isnan(mna) | isnan(mia);
mna = mna(~toremove);
mia = mia(~toremove);


sn = std(nforce.');
mi = [];
si = [];
for i = 1:13
    mi(i) = mean(lvrat(i,~isnan(lvrat(i,:))));
    si(i) = std(lvrat(i,~isnan(lvrat(i,:))));
end

hold on
for i = 1:length(si)
    a = plot(mn(i),mi(i),'.');
    a.MarkerSize = 7;
    a.Color = [0 0 0];
    a = plot([mn(i)-sn(i),mn(i)+sn(i)],[mi(i),mi(i)]);
    a.Color = [0 0 0];
    a = plot([mn(i),mn(i)],[mi(i)-si(i),mi(i)+si(i)]);
    a.Color = [0 0 0];
end

axis([0 1.1 0 1.5]);
yticks([0 .5 1 1.5])
ylabel('$v/F_{a}$ (Ns/m)','Interpreter', 'Latex','FontSize',9);
text(.1,1.3,'r=-0.19 p=.05','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

set(gcf,'color','w');

%% plotting normal force vs lfrat

a = figure;
a.Position(3) = 200;
a.Position(4) = 150;

mn = mean(nforce.');
mna = nforce(:);
mia = lfrat(:);
toremove = isnan(mna) | isnan(mia) | isoutlier(mia);
mna = mna(~toremove);
mia = mia(~toremove);

sn = std(nforce.');
mi = [];
si = [];
for i = 1:13
    mi(i) = mean(lfrat(i,~isnan(lfrat(i,:))));
    si(i) = std(lfrat(i,~isnan(lfrat(i,:))));
end

hold on
for i = 1:length(si)
    a = plot(mn(i),mi(i),'.');
    a.MarkerSize = 7;
    a.Color = [0 0 0];
    a = plot([mn(i)-sn(i),mn(i)+sn(i)],[mi(i),mi(i)]);
    a.Color = [0 0 0];
    a = plot([mn(i),mn(i)],[mi(i)-si(i),mi(i)+si(i)]);
    a.Color = [0 0 0];
end

axis([0 1.1 0 3.5]);
yticks([0,1,2,3])
ylabel('$F_{r}/F_{a}$','Interpreter', 'Latex','FontSize',9);
xlabel('$W$ (N)','Interpreter', 'Latex','FontSize',9);
text(.1,3,'r=0.4 p$<10^{-4}$','Interpreter', 'Latex','FontSize',10);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

set(gcf,'color','w');

%%  plotting normal force vs imps


a = figure;
a.Position(3) = 200;
a.Position(4) = 150;

mn = mean(nforce.');
mna = nforce(:);
mia = imp(:);
toremove = isnan(mna) | isnan(mia);
mna = mna(~toremove);
mia = mia(~toremove);

sn = std(nforce.');
mi = [];
si = [];
for i = 1:13
    mi(i) = mean(imp(i,~isnan(imp(i,:))));
    si(i) = std(imp(i,~isnan(imp(i,:))));
end

hold on
for i = 1:length(si)
    a = plot(mn(i),mi(i),'.');
    a.MarkerSize = 7;
    a.Color = [0 0 0];
    a = plot([mn(i)-sn(i),mn(i)+sn(i)],[mi(i),mi(i)]);
    a.Color = [0 0 0];
    a = plot([mn(i),mn(i)],[mi(i)-si(i),mi(i)+si(i)]);
    a.Color = [0 0 0];
end

axis([0 1.1 0 8]);
yticks([0,2,4,6,8])
ylabel('$|Z_{finger}|$ (Ns/m)','Interpreter', 'Latex','FontSize',9);
xlabel('$W$ (N)','Interpreter', 'Latex','FontSize',9);
%text(.1,7.5,'r=.53 p$<10^{-8}$','Interpreter', 'Latex','FontSize',10);

text(.1,7.5,'r=.86 p$<2\cdot10^{-4}$','Interpreter', 'Latex','FontSize',10);
text(.1,5.5,'r=.63 p$<2\cdot10^{-2}$','Interpreter', 'Latex','FontSize',10);
text(.1,3.5,'r=-.3 p$=0.3$','Interpreter', 'Latex','FontSize',10);

set(gca,'TickLabelInterpreter','latex','FontSize',9);

set(gcf,'color','w');


%% finding correlation curves under different power relations

crmat = {};
C = [];
for f = 1:8   
    for i = 1:13
        if ~isempty(DATA{i,1,4+f})
            C(i,f,1:201) = corr((abs(DATA{i,1,4+f}(:,1)).^pows),DATA{i,1,4+f}(:,2));
        end
    end
    f
end

C(isnan(C)) = 0;

%% finding pearsson and spearman correlation between impedance and load

C = [];
for f = 1:8
    for i = 1:13
        if ~isempty(DATA{i,1,4+f})
            C(f,i,1) = corr(DATA{i,1,4+f}(:,1),DATA{i,1,4+f}(:,2));
            C(f,i,2) = corr(DATA{i,1,4+f}(:,1),DATA{i,1,4+f}(:,2),'Type','Spearman');
        end
    end
end
            
mm = [];
ss = [];
for f = 1:8
    mm(f) = mean(C(f,~isoutlier(C(f,:,1),'mean') & C(f,:,1)~=0,1).^2);
    ss(f) = std(C(f,~isoutlier(C(f,:,1),'mean') & C(f,:,1)~=0,1).^2);
end
        
a = figure;
a.Position(3) = 200;
a.Position(4) = 150;

shadedErrorBar(1:8,mm,ss)
set(gcf,'color','w');
axis([.9,8.1,-.1,1])
xticklabels({20,31,47,72,111,170,261,400})
xticks([1,2,3,4,5,6,7,8])
set(gca,'TickLabelInterpreter','latex','FontSize',9);
xlabel('frequency(Hz)','Interpreter','latex','FontSize',9);
ylabel('$R^{2}$','Interpreter','latex','FontSize',9);

%% jnd histogram 

a = figure;
a.Position(2) = 50;
a.Position(3) = 125;
a.Position(4) = 300;
subplot(2,1,1);
hold on

jndvv = jndv(:,:);
jndvv = jndvv(:);
jndvv = jndvv(~isnan(jndvv) & jndvv~=0);

jndff = jndf(:,:);
jndff = jndff(:);
jndff = jndff(~isnan(jndff) & jndff~=0);

a = histogram(jndvv,0:.05:1,'FaceAlpha',.3);
a.FaceColor = [0 0 0];
a.EdgeColor = [0 0 0];

axis([0 1 0 27]);
xticks([0 .25 .5 .75 1]);
yticks([])
set(gcf,'color','w');
ylabel('count','Interpreter', 'Latex','FontSize',9);
xlabel('CV ($v$)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
a = plot(median(jndvv(:)),26,'.');
a.Color = [1 0 0];
a.MarkerSize = 10;
a = plot(mean(jndvv(:)),26,'.');
a.Color = [0 0 1];
a.MarkerSize = 10;

subplot(2,1,2);
hold on
jndf1 = jndf(1:4,:);
jndf1 = jndf1(:);
jndf2 = jndf(5:8,:);
jndf2 = jndf2(:);

a = histogram(jndff,0:.05:1,'FaceAlpha',.3);
a.FaceColor = [0 0 0];
a.EdgeColor = [0 0 0];
axis([0 1 0 27]);
xticks([0 .25 .5 .75 1]);
yticks([])
set(gcf,'color','w');
ylabel('count','Interpreter', 'Latex','FontSize',9);
xlabel('CV ($F_{r}$)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
a = plot(median(jndff(:)),26,'.');
a.Color = [1 0 0];
a.MarkerSize = 10;
a = plot(mean(jndff(:)),26,'.');
a.Color = [0 0 1];
a.MarkerSize = 10;

%% jnd histogram 2

a = figure;
a.Position(2) = 50;
a.Position(3) = 200;
a.Position(4) = 200;

jndvv = jndv(:);
jndvv = jndvv(~isnan(jndvv));
jndff= jndf(:);
jndff = jndff(~isnan(jndff));


hold on
a = histogram(jndvv,0:.05:1,'FaceAlpha',.3);
a.FaceColor = [1 0 0];
a.EdgeColor = [1 0 0];

axis([0 1 0 27]);
xticks([0 .25 .5 .75 1]);
yticks([])
set(gcf,'color','w');
ylabel('count','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);


a = histogram(jndff,0:.05:1,'FaceAlpha',.3);
a.FaceColor = [0 0 1];
a.EdgeColor = [0 0 1];

a = legend('$CV(v)$','$CV(F_{r})$','Interpreter','latex','FontSize',9);
%% plotting impedance

a = figure;
a.Position(2) = 100;
a.Position(3) = 450;
a.Position(4) = 150;

subplot(1,2,1);
hold on
impx = imp(nforce<.23);
impo = [];
freq = [];
mm = [];
ms = [];
for i = 1:8
    impo = [impo;imp(nforce(:,i)<.5,i)];
    ii = i*ones(1,sum(nforce(:,i)<.5));
    freq = [freq,ii];
    mm(i) = mean(imp(nforce(:,i)<.5,i));
    ms(i) = std(imp(nforce(:,i)<.5,i));
end

axis([1 8 0 12]);
yticks([0 2 4 6 8 10])
set(gcf,'color','w');
ylabel('$|Z_{finger}|$','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

a = plot(freq(:),impo(:),'o');
a.Color = [0,0,0];
a.MarkerSize = 3;

freqs = logspace(log10(20),log10(400),8);
s = freqs*2*pi*sqrt(-1);
ms = .0002;
bs = 1.5;
ks = 1000;
mp = .004;
bp = 1;
kp = 20;

ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;

N1 = ka;
D1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);

mp = .004;
bp = 1;
kp = 20;

N2 = bp + mp*s + kp./s;
D2 = 1;

k = plot(1:8,abs(N2./D2),':');
k.Color = [1,0,0];
k.LineWidth = 1;

k = plot(1:8,abs(N1./D1),'--');
k.Color = [0,0,1];
k.LineWidth = 1;

s = freqs(freq)*2*pi*sqrt(-1);
N2 = bp + mp*s + kp./s;
D2 = 1;
ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;
N1 = ka;
D1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);

% r = r2(abs(N2./D2).',impo)
% r = r2(abs(N1./D1).',impo)

%%

a = legend('data','2$^{nd}$ order fit','4$^{th}$ order fit','Interpreter','latex','FontSize',9);
a.Location = 'northwest';
a.Box = 'off';
subplot(1,2,2);
hold on

impx = imp(nforce>=.5);
impo = [];
freq = [];
mm = [];
ms = [];
for i = 1:8
    impo = [impo;imp(median(nforce.')>.5,i)];
    ii = i*ones(1,sum(median(nforce.')>=.5));
    freq = [freq,ii];
    mm(i) = mean(imp(median(nforce.')>.5,i));
    ms(i) = std(imp(median(nforce.')>.5,i));
end


axis([1 8 0 12]);
yticks([0 2 4 6 8 10])
set(gcf,'color','w');
%ylabel('finger impedance','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);

a = plot(freq(:),impo(:),'o');
a.Color = [0,0,0];
a.MarkerSize = 3;

freqs = logspace(log10(20),log10(400),8);
s = freqs*2*pi*sqrt(-1);

ms = .0002;
bs = 8;
ks = 8000;
mp = .004;
bp = 1.5;
kp = 300;

ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;
N1 = ka;
D1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);


mp = .004;
bp = 1.5;
kp = 300;

N2 = bp + mp*s + kp./s;
D2 = 1;

k = plot(1:8,abs(N2./D2),':');
k.Color = [1,0,0];
k.LineWidth = 1;

k = plot(1:8,abs(N1./D1),'--');
k.Color = [0,0,1];
k.LineWidth = 1;

% r = r2(abs(N2./D2).',impo)
% r = r2(abs(N1./D1).',impo)

set(gca,'TickLabelInterpreter','latex','FontSize',9);

%% plotting impedance 2 

a = figure;
a.Position(2) = 100;
a.Position(3) = 750;
a.Position(4) = 250;

subplot(1,3,1);
hold on
impx = imp(:,mean(nforce)<.2002);

impo = [];
freq = [];
mm = [];
ms = [];
for i = 1:8
    impo = [impo,impx(i,:)];
    ii = [i i i i];
    freq = [freq,ii];
    mm(i) = mean(impx(i,:));
    ms(i) = std(impx(i,:));
end

% a = shadedErrorBar(1:8,mm,ms);
% a.edge(1).Color = [1 1 1];
% a.edge(2).Color = [1 1 1];
axis([1 8 0 12]);
yticks([0 2 4 6 8 10])
set(gcf,'color','w');
ylabel('$|Z_{finger}|$','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

a = plot(freq,impo,'o');
a.Color = [0,0,0];
a.MarkerSize = 3;

freqs = logspace(log10(20),log10(400),8);
s = freqs*2*pi*sqrt(-1);
ms = .0002;
bs = 1;
ks = 1000;
mp = .0025;
bp = .5;
kp = 50;

ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;
N1 = ka;
D1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);

mp = .003;
bp = .5;
kp = 50;

N2 = bp + mp*s + kp./s;
D2 = 1;

k = plot(1:8,abs(N2./D2),':');
k.Color = [1,0,0];
k.LineWidth = 1;

k = plot(1:8,abs(N1./D1),'--');
k.Color = [0,0,1];
k.LineWidth = 1;

a = legend('data','2$^{nd}$ order fit','4$^{th}$ order fit','Interpreter','latex','FontSize',9);
a.Location = 'northwest';
a.Box = 'off';

% -------------------------------------------------------------------------

subplot(1,3,2);
hold on
impx = imp(:,mean(nforce)>.2002 & mean(nforce)<.5);

impo = [];
freq = [];
mm = [];
ms = [];
for i = 1:8
    impo = [impo,impx(i,:)];
    ii = [i i i i];
    freq = [freq,ii];
    mm(i) = mean(impx(i,:));
    ms(i) = std(impx(i,:));
end

% a = shadedErrorBar(1:8,mm,ms);
% a.edge(1).Color = [1 1 1];
% a.edge(2).Color = [1 1 1];

axis([1 8 0 12]);
yticks([0 2 4 6 8 10])
set(gcf,'color','w');
ylabel('$|Z_{finger}|$','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

a = plot(freq,impo,'o');
a.Color = [0,0,0];
a.MarkerSize = 3;

freqs = logspace(log10(20),log10(400),8);
s = freqs*2*pi*sqrt(-1);
ms = .0002;
bs = 2;
ks = 1500;
mp = .003;
bp = .5;
kp = 50;

ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;
N1 = ka;
D1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);

mp = .0035;
bp = .5;
kp = 50;

N2 = bp + mp*s + kp./s;
D2 = 1;

k = plot(1:8,abs(N2./D2),':');
k.Color = [1,0,0];
k.LineWidth = 1;

k = plot(1:8,abs(N1./D1),'--');
k.Color = [0,0,1];
k.LineWidth = 1;

a = legend('data','2$^{nd}$ order fit','4$^{th}$ order fit','Interpreter','latex','FontSize',9);
a.Location = 'northwest';
a.Box = 'off';


% -------------------------------------------------------------------------

subplot(1,3,3);
hold on

impx = imp(:, mean(nforce)>.5);

impo = [];
freq = [];
mm = [];
ms = [];
for i = 1:8
    impo = [impo,impx(i,:)];
    ii = [i i i i i];
    freq = [freq,ii];
    mm(i) = mean(impx(i,:));
    ms(i) = std(impx(i,:));
end

%a = shadedErrorBar(1:8,mm,ms);
%a.edge(1).Color = [1 1 1];
%a.edge(2).Color = [1 1 1];

axis([1 8 0 12]);
yticks([0 2 4 6 8 10])
set(gcf,'color','w');
%ylabel('finger impedance','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);

a = plot(freq,impo,'o');
a.Color = [0,0,0];
a.MarkerSize = 3;

% a = plot(1:8,impx);
% for i = 1:length(a)
%     a(1).Color = [.8,.8,.8];
%     a(1).LineWidth = .3;
% end


ms = .0002;
bs = 5;
ks = 10000;
mp = .003;
bp = 1;
kp = 200;

ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;
N1 = ka;
D1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);


mp = .0035;
bp = 1;
kp = 200;

N2 = bp + mp*s + kp./s;
D2 = 1;

k = plot(1:8,abs(N2./D2),':');
k.Color = [1,0,0];
k.LineWidth = 1;

k = plot(1:8,abs(N1./D1),'--');
k.Color = [0,0,1];
k.LineWidth = 1;

set(gca,'TickLabelInterpreter','latex','FontSize',9);

%% plotting models

a = figure;
a.Position(2) = 100;
a.Position(3) = 500;
a.Position(4) = 150;

freq = freq_arr;
s = sqrt(-1)*2*pi*freq;
ms = .0002;
bs = 1.5;
ks = 1000;
mp = .004;
bp = 1.25;
kp = 150;

ka = ((ms*mp).*(s.^4)) + ((ms*(bp+bs) + mp*bs).*(s.^3)) + ((ms*(ks+kp) + mp*ks + bs*bp).*(s.^2)) + ((bs*kp + bp*ks).*s) + ks*kp;

% whole finger model, peripheral force due to peripheral velocity 

N1 = (mp.*(s.^3)) + ((bs+bp).*(s.^2)) + ((ks+kp).*s);
D1 = ka;

% velocity between skin and nail due to peripheral force

N2 = (mp.*(s.^2) + bp.*s +kp).*s;
D2 = ka;

% velocity at phalange due to peripheral force

N3 = bs.*(s.^2) + ks.*s;
D3 = ka;

subplot(1,2,1);
hold on
mm = [];
ms = [];

for i = 1:13
%     a = plot(1:8,lvrat(i,:));
%     a.Color = [.7 .7 .7];
%     a.LineWidth = .3;
end

for f = 1:8
    mm(f) = mean(lvrat(~isnan(lvrat(:,f)),f));
    ms(f) = std(lvrat(~isnan(lvrat(:,f)),f));
end

% lvrato = [];
% freqs = [];
% freqsf = [];
% mmv = [];
% msv = [];
% 
% for i = 1:8
%     isin = ~isnan(lvratt(:,i,:));
%     isin = isin(:);
%     lvratox = lvratt(:,i,:);
%     lvratox = lvratox(:);
%     lvratox = lvratox(isin & lvratox~=0);
%     lvratox = lvratox(~isoutlier(lvratox,2));
%     lvrato = [lvrato;lvratox];
%     ii = i*ones(1,length(lvratox));
%     freqs = [freqs,ii];    
%     mmv(i) = mean(lvratox);
%     msv(i) = std(lvratox);
% end
% 
% a = shadedErrorBar(1:8,mmv,msv);

hold on
a = plot(1:8,mm);
a.Color = [.7 .7 .7];
a.LineWidth = 1;
for f = 1:8
    a = plot([f,f],[mm(f)-ms(f),mm(f)+ms(f)]);
    a.Color = [.7 .7 .7];
    a.LineWidth = 1;
end

a = plot(1:8,abs(N1./D1));
a.Color = [0 0 0];
a.LineWidth = 1;
axis([1 8 0 1.2]);
xticklabels(freq);
xticks(1:8);

xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',10);
ylabel('v/F','Interpreter', 'Latex','FontSize',10);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
subplot(1,2,2);
hold on

a = plot(1:8,abs(N1./D1));
a.Color = [0 0 0];
a.LineWidth = 1;

a = plot(1:8,abs(N2./D2),'--');
a.Color = [0 0 1];
a.LineWidth = 1.5;

a = plot(1:8,abs(N3./D3),':');
a.Color = [1 0 0];
a.LineWidth = 1.5;

axis([1 8 0 1.2]);
xticklabels(freq);
xticks(1:8);

set(gcf,'color','w');

set(gca,'TickLabelInterpreter','latex','FontSize',9);

xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',10);
%% fits
[k,l] = min(squeeze(sum(ztonrat,1)).');
P = pows(l);

freqs = round(logspace(log10(20),log10(400),8));
%freqs2 = freqs.'.*ones(1,13);
s = freqs(:)*2*pi*sqrt(-1);

r = [];
xdata = freqs;
X = [];

for i = 1:13
    ms = .0002;
    bs = 2.5;
    ks = 4000;
    mp = .0035;
    bp = 1;
    kp = 300;
    
    xstart = [ms bs ks mp bp kp];
    
    fun = @(x,xdata)abs((((x(1)*x(4)).*(s.^4)) + ((x(1)*(x(2)+x(5)) + x(4)*x(2)).*(s.^3)) + ((x(1)*(x(3)+x(6)) + x(4)*x(3) + x(2)*x(5)).*(s.^2)) + ((x(2)*x(6) + x(5)*x(3)).*s) + x(3)*x(6))./((x(4).*(s.^3)) + ((x(2)+x(5)).*(s.^2)) + ((x(3)+x(6)).*s)));
    %fun = @(x,xdata)abs(((x(4).*(s.^3)) + ((x(2)+x(5)).*(s.^2)) + ((x(3)+x(6)).*s))./(((x(1)*x(4)).*(s.^4)) + ((x(1)*(x(2)+x(5)) + x(4)*x(2)).*(s.^3)) + ((x(1)*(x(3)+x(6)) + x(4)*x(3) + x(2)*x(5)).*(s.^2)) + ((x(2)*x(6) + x(5)*x(3)).*s) + x(3)*x(6)));
    
    %im = imp(:,i)./(nforce(:,i).'.^P.').*(.5.^P.');
    im = imp(:,i);
    
    x = lsqcurvefit(fun,xstart,freqs,im,[ 0 0 500 .001 0 10],[.0005 10 20000 .02 10 1000],optimset('Display','off'));
    X(i,1:6) = x;
    ms = x(1);
    bs = x(2);
    ks = x(3);
    mp = x(4);
    bp = x(5);
    kp = x(6);    
      
    y = abs((((x(1)*x(4)).*(s.^4)) + ((x(1)*(x(2)+x(5)) + x(4)*x(2)).*(s.^3)) + ((x(1)*(x(3)+x(6)) + x(4)*x(3) + x(2)*x(5)).*(s.^2)) + ((x(2)*x(6) + x(5)*x(3)).*s) + x(3)*x(6))./((x(4).*(s.^3)) + ((x(2)+x(5)).*(s.^2)) + ((x(3)+x(6)).*s)));
    
    %r(i) = 1 - sum((y - imp(:,i).').^2)./sum((mean(y) - imp(:,i).').^2);
    r(i) = r2(y,imp(:,i));
    i
end

%% 
close all
hold on
c = [];
for i = 1:13
    tokeep = r>.85;
    x(1) = .0002;
    x(2) = 1.5;
    x(3) = 1000;
    x(4:6) = X(i,4:6);
    x = X(i,:);
    
    % abs(((x(4).*(s.^3)) + ((x(2)+x(5)).*(s.^2)) + ((x(3)+x(6)).*s))./(((x(1)*x(4)).*(s.^4)) + ((x(1)*(x(2)+x(5)) + x(4)*x(2)).*(s.^3)) + ((x(1)*(x(3)+x(6)) + x(4)*x(3) + x(2)*x(5)).*(s.^2)) + ((x(2)*x(6) + x(5)*x(3)).*s) + x(3)*x(6)));
    
    c(i) = corr(lvrat(:,i),abs(((x(4).*(s.^3)) + ((x(2)+x(5)).*(s.^2)) + ((x(3)+x(6)).*s))./(((x(1)*x(4)).*(s.^4)) + ((x(1)*(x(2)+x(5)) + x(4)*x(2)).*(s.^3)) + ((x(1)*(x(3)+x(6)) + x(4)*x(3) + x(2)*x(5)).*(s.^2)) + ((x(2)*x(6) + x(5)*x(3)).*s) + x(3)*x(6))));

    plot(lvrat(:,i),abs(((x(4).*(s.^3)) + ((x(2)+x(5)).*(s.^2)) + ((x(3)+x(6)).*s))./(((x(1)*x(4)).*(s.^4)) + ((x(1)*(x(2)+x(5)) + x(4)*x(2)).*(s.^3)) + ((x(1)*(x(3)+x(6)) + x(4)*x(3) + x(2)*x(5)).*(s.^2)) + ((x(2)*x(6) + x(5)*x(3)).*s) + x(3)*x(6))));
end



%% plotting lateral versus vibration force info

a = figure;
hold on
a.Position(3) = 200;
a.Position(4) = 150;

lfrato = [];
freqs = [];
mmf = [];
msf = [];

for i = 1:8
    isin = ~isnan(lfratt(median(nforce.')>0,i,:));
    isin = isin(:);
    lfratox = lfratt(median(nforce.')>0,i,:);
    lfratox = lfratox(:);
    lfratox = lfratox(isin & lfratox~=0);
    lfratox = lfratox(~isoutlier(lfratox,1));
    lfrato = [lfrato;lfratox];
    ii = i*ones(1,length(lfratox));
    freqs = [freqs,ii];    
    mmf(i) = mean(lfratox);
    msf(i) = std(lfratox);
end


a = shadedErrorBar(1:8,mmf,msf);
a.mainLine.LineWidth = 1;
a.edge(1).LineWidth = .001;
a.edge(2).LineWidth= .001;
a.patch.FaceColor = [1 0 0];
a.edge(1).Color = [1 1 1];
a.edge(2).Color = [1 1 1];

% a = shadedErrorBar(1:8,nm,ns);
% a.mainLine.LineWidth = 1;
% a.edge(1).Color = [1 1 1];
% a.edge(2).Color = [1 1 1];

axis([1 8 0 3.5]);
yticks([0 1 2 3 4 5])
set(gcf,'color','w');
ylabel('$\beta = F_{r} / F_{a}$','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));

xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
% set(gca,'Xscale','log')
% set(gca,'Yscale','log')

lm = fitlm(log(freq_arr(freqs)),lfrato);
lm.Coefficients

% text(2,3,'$\beta$ = 0.46 log($f$) - 0.74','Interpreter', 'Latex','FontSize',9);
% a = plot(1:8,log(freq_arr)*.46 - .74,'--')
% a.Color = [1 0 0];
% a.LineWidth = 1;
%a = legend('data','fit','Interpreter', 'Latex','FontSize',9);


%% plotting lateral versus velocity info
a = figure;
a.Position(3) = 210;
a.Position(4) = 150;
hold on
lvratx = lvrat;

lvrato = [];
freqs = [];
freqsf = [];
mmv = [];
msv = [];

for i = 1:8
    isin = ~isnan(lvratt(:,i,:));
    isin = isin(:);
    lvratox = lvratt(:,i,:);
    lvratox = lvratox(:);
    lvratox = lvratox(isin & lvratox~=0);
    lvratox = lvratox(~isoutlier(lvratox,2));
    lvrato = [lvrato;lvratox];
    ii = i*ones(1,length(lvratox));
    freqs = [freqs,ii];    
    mmv(i) = mean(lvratox);
    msv(i) = std(lvratox);
end

a = shadedErrorBar(1:8,mmv,msv);
a.mainLine.LineWidth = 1;
a.edge(1).LineWidth = .001;a.edge(2).LineWidth= .001;
a.patch.FaceColor = [1 0 0];
axis([1 8 0 1.4]);
yticks([0 .5 1])
set(gcf,'color','w');
a.edge(1).Color = [1 1 1];
a.edge(2).Color = [1 1 1];
ylabel('$v/F_{a}$  (m/Ns)','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);


lm = fitlm(freqs.',lvrato.');
lm.Coefficients

%% plot n force versus l force
nforce = []; forcelforcerat = []; imp = []; cr = []; lat = [];
nforceall = []; impall = []; flfratall = []; lforce = []; vel = []; force = [];

for f = 1:8
    for i = 1:13
        nforce(f,i) = median(DATA1{i,f}(5,:));
        lforce(f,i) = median(DATA3{i,f}(1,:));
        flfrat(f,i) = median(DATA1{i,f}(3,:))./median(DATA3{i,f}(1,:));
        nforceall = [nforceall,DATA1{i,f}(5,:)];
        flfratall = [flfratall,DATA1{i,f}(3,:)./mean(DATA3{i,f}(1,:))];
        imp(f,i) = mean(DATA1{i,f}(1,:));
        impall = [impall,DATA1{i,f}(1,:)];
        cr(f,i) = mean(DATA1{i,f}(9,:));
        lat(f,i) = mean(DATA3{i,f}(1,:));
        vel(f,i) = mean(DATA1{i,f}(8,:));
        force(f,i) = mean(DATA1{i,f}(3,:));
    end
end


%% velocity plot

addpath('C:\Users\atrox\Desktop\Work\Research\Code\General code\MATLAB code\plots');

a = figure;
a.Position(3) = 250;
a.Position(4) = 225;

m = []; s = []; fortt = []; veltt = []; ft = [];
for f = 1:8
    velt = []; fort = [];
    for i = 1:13
        velt = [velt,DATA2{i,f}(7,:)];
        fort = [fort,DATA2{i,f}(9,:)];        
    end    
    fortt = [fortt,fort];
    veltt = [veltt,velt];
    ft = [ft,1*ones(1,length(velt))];
    m(f) = mean(velt);% /mean(fort);
    mf(f) = mean(fort);
    s(f) = std(velt);
    
end

%m = m*mean(fortt);

hold on
a = plot(1:8,freq_arr(1)*.04./freq_arr,'--');
a.Color = [1 0 0];
a.LineWidth = 1;
a = plot(1:8,.04.*freq_arr/freq_arr(8),'--');
a.Color = [1 0 0];
a.LineWidth = 1;
a = shadedErrorBar(1:8,m,s);
%a = shadedErrorBar(1:8,m(:,7)./m(:,9)*mean(m(:,9)),s(:,7)./m(:,9)*mean(m(:,9)));
a.edge(1).Color = [1 1 1];
a.edge(2).Color = [1 1 1];
a.MainLine.LineWidth = 1;
axis([1 8 0 .04]);
yticks([0 0.01 0.02 0.03 0.04]);
set(gcf,'color','w');
%ylabel('normal force, $F_{r}$ (N)','Interpreter', 'Latex','FontSize',9);
ylabel('normal velocity, $v$ (m/s)','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

% a = plot(1:8,mf/2);
% a.Color = [0 0 1];
%% similarity judgment

a = figure;
a.Position(3) = 200;
a.Position(4) = 200;

sj = []; sj2 = [];
for i = 1:13
    sj = [sj;squeeze(DATA{i,3,2}(1:8))/10];
    sj2 = [sj2;squeeze(DATA{i,3,2}(1:8))/median(squeeze(DATA{i,3,2}(1:8)))];
end

freqs = []; mm = []; ms = []; mm2 = []; ms2 = [];
sjo = [];
for f = 1:8
    ii = [f f f f f f f f f f f f f];
    freqs = [freqs,ii(~isoutlier(sj(:,f)))];
    sjo = [sjo,sj(~isoutlier(sj(:,f)),f).'];
    mm(f) = mean(sj(~isoutlier(sj(:,f)),f));
    ms(f) = std(sj(~isoutlier(sj(:,f)),f));
    mm2(f) = mean(sj2(~isoutlier(sj(:,f)),f));
    ms2(f) = std(sj2(~isoutlier(sj(:,f)),f));
end

hold on

a = shadedErrorBar(1:8,mm,ms);
axis([1 8 0 1]);
yticks([0 .5 1])
set(gcf,'color','w');
ylabel('similairty judgment','Interpreter', 'Latex','FontSize',9);
xticks([1,2,3,4,5,6,7,8]);
xticklabels(freq_arr([1,2,3,4,5,6,7,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);

a.edge(1).Color = [1 1 1];
a.edge(2).Color = [1 1 1];

lm = fitlm(freqs.',sjo.');
lm.Coefficients

a = plot(freqs,sjo,'o');
a.MarkerSize = 3
a.Color= [0 0 0];

%% plotting nforce
a = figure;
a.Position(3) = 150;
a.Position(4) = 100;

mm = mean(kinemm.');
ms = std(kinemm.');
hold on
a = shadedErrorBar(1:8,mm,ms);

lm = fitlm(ff(:),nforce(:));
lm.Coefficients
%% time

a = figure;
a.Position(3) = 150;
a.Position(4) = 250;

timvo = timv./mean(timv);
timfo = timf./mean(timf);

mmf = [];
msf = [];
mmv = [];
msv = [];

for i = 1:8
    mmf(i) = mean(timfo(i,~isoutlier(timfo(i,:))));
    msf(i) = std(timfo(i,~isoutlier(timfo(i,:))));
    mmv(i) = mean(timvo(i,~isoutlier(timvo(i,:))));
    msv(i) = std(timvo(i,~isoutlier(timvo(i,:))));
end
    
    
subplot(2,1,1)
hold on
a = shadedErrorBar(1:8,mmv,msv);

axis([1 8 0 2]);
yticks([0 1 2]);
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex','FontSize',9);
xticks([1,8]);
xticklabels(freq_arr([1,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
ylabel('normalized time','Interpreter', 'Latex','FontSize',9);

subplot(2,1,2)
hold on
a = shadedErrorBar(1:8,mmf,msf);
axis([1 8 0 2]);
yticks([0 1 2]);
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex','FontSize',9);
xticks([1,8]);
xticklabels(freq_arr([1,8]));
xlabel('frequency (Hz)','Interpreter', 'Latex','FontSize',9);
ylabel('normalized time','Interpreter', 'Latex','FontSize',9);

%% 

a = figure;
a.Position(2) = 100;
a.Position(3) = 400;
a.Position(4) = 100;
yyaxis right
a = plot((0:(length(Z)-1))/sr,Do+1.26);
a.Color = [0 0 0];
axis([2 16 -1 0]);
xlabel('time(s)','Interpreter', 'Latex','FontSize',9);
ylabel('$W (N)$','Interpreter', 'Latex','FontSize',9);
%ylabel('$|Z_{finger}|$','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
set(gcf,'color','w');

%%
% cord  = [];
% 
% for i = 1:13
%     
%     DATA{ind,1,4}(ceil(tt/8),1:nrw,1:length(pows)) = crz;
%                     DATA{ind,1,4}(ceil(tt/8),1:nrw,1:length(pows)) = crf;