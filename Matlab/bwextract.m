sigin = H1in(~Di)/mean(H1in(~Di));
sigout = C1out(~Di)/mean(C1out(~Di));

d = 5;
step = sr/d;

L = length(sigin);
S = round(L/step);

bb = [];
aa = [];

fun = @(x,xdata) x(1)*xdata(1,:) + x(2)*xdata(2,:) + x(3)*xdata(3,:) + x(4)*xdata(4,:) + x(5)*xdata(5,:);

[b,a] = butter(2,5*1/sr,'low');
xstart = [flip(b),-flip(a(2:3))];
%xstart = [.1 .1 .1 -1 2];
xlimL = [0 0 0 -1.00001 1.9];
xlimH = [.0001 .0001 .0001 -.97 2.1];

for s = 1:S-1
    xin = [];
    for i = 1:step-2
        xin = [xin;[sigin(((s-1)*step + i):((s-1)*step +i+2)).',sigout(((s-1)*step + i):((s-1)*step +i+1)).']];
    end
    xin = xin.';
    
%     xin = sigin(((s-1)*step+1):s*step);
%     xout = sigout(((s-1)*step+1):s*step);
    
    x = lsqcurvefit(fun,xstart,xin,zeros(1,step-2),xlimL,xlimH,optimset('Display','off'));
    
    bb = [bb;flip(x(1:3))];
    aa = [aa;[1,-flip(x(4:5))]];
    s
end
    