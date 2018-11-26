% EE 430 Digital Signal Processing MATLAB Tutorial
% PART 2 - INTRODUCTION TO AUDIO PROCESSING WITH MATLAB 
% M-File 5
% Audio Processing

close all

[x1,Fs1]=wavread('scholarsr1_16.wav');
h1=1/9*[1 1 1 1 1 1 1 1 1 ];
y1=conv(x1,h1);
sound(y1,Fs1);
sound(y1,2*Fs1);
sound(y1,Fs1/2);


h2=[1 -1];
y2=conv(x1,h2);
sound(y2,Fs1);

[x2,Fs2]=wavread('scholars_white_16.wav');
[b,a] = butter(8, 0.2); %generate a low pass filter

y3 = filter(b,a,x2);
sound(y3,Fs2);

fft_x1=fft(x1);
fft_x1=fftshift(fft_x1);
w=linspace(-Fs1/2,Fs1/2,length(x1));
plot(w,abs(fft_x1));

fft_y1=fft(y1);
fft_y1=fftshift(fft_y1);
w=linspace(-Fs1/2,Fs1/2,length(y1));
figure
plot(w,abs(fft_y1));

fft_y2=fft(y2);
fft_y2=fftshift(fft_y2);
w=linspace(-Fs1/2,Fs1/2,length(y2));
figure
plot(w,abs(fft_y2));

fft_2=fft(x2);
fft_2=fftshift(fft_2);
w=linspace(-Fs2/2,Fs2/2,length(x2));
figure
plot(w,abs(fft_2));

fft_y3=fft(y3);
fft_y3=fftshift(fft_y3);
w=linspace(-Fs2/2,Fs2/2,length(y3));
figure
plot(w,abs(fft_y3));


Fs=44100;
%Generate a chirp signal
t=0:1/Fs:3;%duration in seconds
f0=20;%starting frequency
t1=1;%time at t1
f1=1000;%frequency at time t1
y=chirp(t,f0,t1,f1);

sound(y,Fs);

wavwrite(y,Fs,'chirp_sound.wav')

[b,a] = butter(8, 0.02); %generate a low pass filter

yFiltered1 = filter(b,a,y);

sound(yFiltered1,Fs)

[b,a] = butter(8, 0.04,'high'); %generate a high pass filter

yFiltered2 = filter(b,a,y);

sound(yFiltered2,Fs)

fft_y=fft(y);
fft_y=fftshift(fft_y);
w=linspace(-Fs/2,Fs/2,length(y));
figure
plot(w,abs(fft_y));

fft_yFiltered1=fft(yFiltered1);
fft_yFiltered1=fftshift(fft_yFiltered1);
w=linspace(-Fs/2,Fs/2,length(yFiltered1));
figure
plot(w,abs(fft_yFiltered1));

fft_yFiltered2=fft(yFiltered2);
fft_yFiltered2=fftshift(fft_yFiltered2);
w=linspace(-Fs/2,Fs/2,length(yFiltered2));
figure
plot(w,abs(fft_yFiltered2));