%% audiorecorder
clear all
clc
close all
%%

recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');
play(recObj);
y = getaudiodata(recObj);
figure
plot(y); %time domain
z = abs(fftshift(fft(y)));
figure
t=length(z)/2;
freq=(-t+1):1:t;
% plot(freq,z); %freq domain
%plot(psd(spectrum.periodogram,y,'Fs',fs,'NFFT',length(signal)));
freq2=0:1:t;
for k=1:1:t+1
    zz(k,1)=z(t+k-1,1);
end
figure
plot(freq2,zz);
[y_max index] = max(zz)
indexstr=num2str(index);
 f = fit(freq2.',zz,'gauss4')
plot(f);
coeffs= coeffvalues(f);
for i=1:1:4
    coeffsb(i)=coeffs(3*i-1);
end
minfark=abs(coeffsb(1)-index);
best=coeffsb(1);
for i=1:1:4
    fark=abs(coeffsb(i)-index);
    if fark<minfark
    minfark=fark;
    best=coeffsb(i);
    end
end

volume=17.70356+15.59223*exp(-(best-882.18942)/53.33018)+106.74048*exp(-(best-882.189)/451.75)+53.155*exp(-(best-882.189)/2302.44); % in cm3


if volume < 97.14
    depth=-3.59788+0.22699*volume-0.00102*volume*volume;
end
if volume > 97.14
    depth=((volume-97.14)/(pi*2.25*2.25))+9;
end
