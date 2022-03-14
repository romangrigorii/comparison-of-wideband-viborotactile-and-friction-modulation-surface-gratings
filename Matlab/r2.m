function out = r2(y,ydata)
out = 1 - (sum((y - ydata).^2)/sum((ydata - mean(ydata)).^2));
end
