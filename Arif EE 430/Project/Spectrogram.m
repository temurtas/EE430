clear all;
close all;
%%
%determine the window type and lentgh and shift
wlength=500;
shift=100;
window = hamming(wlength); % can be gausswin,hamming,hann,tukeywin,blackman
%%
%load a sound file
[mywave,fs]=wavread('scholarsr1_16.wav');
%%
%form the STFT matrix
row=ceil((1+wlength)/2);
col=1+fix((length(mywave)-wlength)/shift);
stft=zeros(row,col);

%%
%fill the STFT matrix by calculating fft for all windows
i=0;
k=1;
while(i+wlength<=length(mywave))
    win = mywave(i+1:i+wlength).*window;
    W = fft(win, wlength);
    stft(:,k) = W(1:row);
    i=i+shift;
    k=k+1;
end    

%%
%form the time and frequency vectors
t = (wlength/2:shift:length(mywave)-wlength/2-1)/fs;
f = (0:row-1)*fs/wlength;

%%
%figure the spectrogram
imagesc(t,f,20*log10(abs(stft)));
axis xy
xlabel('Time (sec)');
ylabel('Frequency (Hz)');