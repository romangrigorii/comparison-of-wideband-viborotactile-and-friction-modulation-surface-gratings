function y = lanczos(x,N,sr,order)
y = zeros(size(x));
switch order
    case 1
        m = (N-1)/2;        
        for i = m:length(x)- m
            for k = 1:m
                y(i) = y(i) + (x(i-k)-x(i+k))*k;
            end
            y(i) = y(i)*3*sr/(m*(m+1)*(2*m+1));
        end
end       
end