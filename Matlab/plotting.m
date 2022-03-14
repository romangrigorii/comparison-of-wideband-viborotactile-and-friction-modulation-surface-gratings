sr = 100000;
t = linspace(0,1,sr);
[b1,a1] = butter(3,100*2/sr,'low');
[b2,a2] = butter(3,5*2/sr,'low');
ff = 200;

ph = linspace(0,pi/2,100);
phe = [];
fr = linspace(10,50,5);

mat = [];

for f = 1:length(fr)
    for p = 1:length(ph)      
        [bb,aa] = butter(2,[.6,1.4]*4*ff/sr,'stop');
        sig = sin((2*pi*t*ff) + ph(p)*sin(fr(f)*pi*2*t));
        phe(p) = sqrt(mean((ph(p)*sin(50*pi*2*t)).^2));
        sigs = sig.*sin(2*pi*t*ff);
        sigc = sig.*cos(2*pi*t*ff);
        hold on
        am = sqrt(filter(b1,a1,sigs).^2 + filter(b1,a1,sigc).^2)*2;
        am = filtfilt(bb,aa,am);
        mat(f,p) = sqrt(mean((am(end/2:end)-1).^2)); % std(am(end/2:end));
    end
end

hold on
for f = 1:length(fr)
    a = plot(phe,mat(f,:));
    a.Color =[0 0 0];
    a = text(1.15,mat(f,end),num2str(fr(f)/50.00000001,4),'Interpreter', 'Latex','FontSize',9);
end

set(gcf,'color','w');
ylabel('RMSE of estimated amplitude','Interpreter', 'Latex','FontSize',9);
xlabel('RMSE of phase control from ideal phase','Interpreter', 'Latex','FontSize',9);
set(gca,'TickLabelInterpreter','latex','FontSize',9);
set(gca,'Yscale','log')

a = text(.2,.1,'$BW_{T phase}/BW_{T magnitude}$','Interpreter', 'Latex','FontSize',9);