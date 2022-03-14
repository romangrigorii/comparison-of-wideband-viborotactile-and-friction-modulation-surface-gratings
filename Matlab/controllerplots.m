subplot(1,2,2)
[b,a] = butter(2,10*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,5*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);
[w,a,k] = bode(T,linspace(.01,10000,1000000));    
w = squeeze(w);
a = squeeze(a);
k = squeeze(k);
a = plot(k/2/pi,20*log10(w));
a.Color = [0 0 0];
a.LineWidth = 1;
set(gca,'Xscale','log')
axis([.1 1000 -65 35])

subplot(1,2,1)
C1des = T/(1-T*C2);
[w,a,k] = bode(C1des,linspace(.01,10000,1000000));    
w = squeeze(w);
a = squeeze(a);
k = squeeze(k);
a = plot(k/2/pi,20*log10(w));
a.Color = [0 0 0];
a.LineWidth = 1;
set(gca,'Xscale','log')
axis([.1 1000 -65 35])


[b,a] = butter(2,10*2/sr,'low');
[b,a] = ztos(b,a,sr);
C2 = tf(b,a);
[b,a] = butter(2,5*2/sr,'low');
[b,a] = ztos(b,a,sr);
T = tf(b,a);
C1des = T/(1-T*C2);
P = [1,2,4,8];
for i = 1:4
    C1 = tf(1,[1 0])*tf(70,[1 67])*14/P(i);
    Tact = C1/(1+C1*C2);    
    subplot(1,2,2)
    hold on
    [w,a,k] = bode(Tact,linspace(.01,10000,1000000));
    w = squeeze(w);
    a = squeeze(a);
    k = squeeze(k);
    a = plot(k/2/pi,20*log10(w));
    set(gca,'Xscale','log')
    axis([.1 1000 -65 35])
    
    if i == 1
        a.Color = [1 0 0];
        a.LineWidth = 1;
        a.LineStyle = '--';
    else
        a.Color = [.7 .7 .7];
        a.LineWidth = .75;
    end
    
    subplot(1,2,1)
    hold on
    [w,a,k] = bode(C1,linspace(.01,10000,1000000));
    w = squeeze(w);
    a = squeeze(a);
    k = squeeze(k);
    a = plot(k/2/pi,20*log10(w));
    set(gca,'Xscale','log')
    axis([.1 1000 -65 35])
    
    if i == 1
        a.Color = [1 0 0];
        a.LineWidth = 1;
        a.LineStyle = '--';
    else
        a.Color = [.7 .7 .7];
        a.LineWidth = .75;
    end
    
end
