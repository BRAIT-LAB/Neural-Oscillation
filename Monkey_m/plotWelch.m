for i = 1:128
    freq = f(2:100);
    plot(freq,EyesOpenedWelch(i,2:100))
    title(num2str(i))
    pause;
    close;
end

for i = 1:128
    freq = f(2:100);
    plot(freq,EyesClosedWelch(i,2:100))
    pause;
    close;
end

for i = 1:128
    freq = f(2:100);
    plot(freq,AnesthetizedWelch(i,2:100))
    pause;
    close;
end