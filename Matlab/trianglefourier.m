function out = trianglefourier(N,t,f)
out = zeros(1,length(t));
for n = 0:N-1
    out = out + ((-1).^n)*sin(2*pi*f*(2*n+1)*t)./((2*n+1).^2);
end
out = out*8/(pi^2);
end