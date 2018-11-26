%% Q1a
num =[1 -sqrt(2) 1]
den=[1 0 0]
x = tf (num,den)
figure(1)
zplane(num,den)
title("Pole-Zero Diagram for the System Function at Q1")


%% Q1b
L=1000;
dw=2*pi/L;
w = -pi:dw:pi-dw;

HH=freqz(num,den,w);

figure(2)
mag=abs(HH)
plot(w,mag)
title('Magnitude Response of the System')
grid on
xlabel("frequency")
ylabel("Magnitude (dB)")

figure(3)
phase=angle(HH)
plot(w,phase)
title('Phase Response of the System')
grid on
xlabel("frequency")
ylabel("Phase (degree)")