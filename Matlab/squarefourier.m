function out=squarefourier(N,t,f)
out = zeros(1,length(t));
for n = 1:N
    out = out + sin(2*pi*f*(2*n-1)*t)./(2*n-1)/f;
end
out = out*4/pi;
end