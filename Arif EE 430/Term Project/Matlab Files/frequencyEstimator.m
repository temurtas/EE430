function estimatedFrequency = frequencyEstimator(signal, samplingFrequency)

signal = signal - mean(signal);
signalFFT = fft(signal,10*length(signal));
signalFFT = abs(signalFFT(1:floor(length(signalFFT)/2)));
axisFrequency = samplingFrequency*0.5*linspace(0,1,length(signalFFT));



plot(axisFrequency, signalFFT,'LineWidth',2); axis([2  5000 0 max(signalFFT)]);
xlabel('Frequency')
ylabel('Magnitude')
hold(gca,'on')

signalFFT(axisFrequency<=70) = [];
axisFrequency(axisFrequency<=70) = [];
signalFFT(axisFrequency>=5000) = [];
axisFrequency(axisFrequency>=5000) = [];

[peakyy, peakxx] = findpeaks(signalFFT,'npeaks',10,'minpeakdistance',1000,'minpeakheight',500);
peakx = axisFrequency(peakxx);

[~,I] = sort(peakx(1,:));
peaky = peakyy(I)';
peakx = peakx(I);


harmonicCheck = zeros(1,length(peakx));
for i = 1:length(peakx)
    divisionMatrix = peakx / peakx(i);
    keep = 0;
    for j = i+1 : length(peakx)
        row = 0;
        if(divisionMatrix(j)<=2.03 && divisionMatrix(j) >= 1.97)
            harmonicCheck(i) = harmonicCheck(i)+1+keep;
        row = 1;
        end
        
        if(divisionMatrix(j)<=3.03 && divisionMatrix(j) >= 2.97)
            harmonicCheck(i) = harmonicCheck(i)+1+keep;
        row = 1;
        end
        
        if(divisionMatrix(j)<=4.03 && divisionMatrix(j) >= 3.97)
             harmonicCheck(i) = harmonicCheck(i)+1+keep;
        row = 1;
        end
        
        if(divisionMatrix(j)<=5.05 && divisionMatrix(j) >= 4.95)
             harmonicCheck(i) = harmonicCheck(i)+1+keep;
        row = 1;
        end
        
        if(divisionMatrix(j)<=6.05 && divisionMatrix(j) >= 5.95)
             harmonicCheck(i) = harmonicCheck(i)+1+keep;
        row = 1;
        end
       
        if row == 0
        keep = 0;
        else
            keep = keep + row;
        end
    end
end

[~, estimatedFrequency] = max(harmonicCheck);
if peakyy(estimatedFrequency)>= 75
estimatedFrequency = peakx(estimatedFrequency);
else estimatedFrequency = 0;
end
    

if max(harmonicCheck) <= 1
estimatedFrequency = 0;
end

if(sum(size(peakx))<=1)
    estimatedFrequency = 0;
end

if sum(size(peakx)>=2)
stem(peakx,peaky,'r','LineWidth',3);
end
hold(gca,'off')

end