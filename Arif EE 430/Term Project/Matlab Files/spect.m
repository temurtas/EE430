function spect(soundFile,winLength,winShift,win)

    %%% check if it is necessary to take transpose
    if(size(soundFile,1) > 5)
        soundFile = soundFile';
    end
    
    %%% check for the length errors
    if( length(soundFile) < winLength )
    soundFile = [soundFile zeros(1,winLength-length(x))];
    end
   
    if( winShift > winLength )
    disp(' Window Shift length cannot be greater than the length of the window ');
    end
    figure;
    

            
        %%% unimportant initials
        %shorttft = zeros(3,winLength*100);
        ini = 1;    %%% initial point of the window
        i=1;        %%% counter of vertical lines
    
        %%% fill the matrix representing STFTs
    while( ini + winLength -1 <= length(soundFile) )
        
        shorttft(i,:) = abs(fft(soundFile( ini : ini+winLength-1 ).*win,winLength*100));
        ini = ini + winShift;
        i = i+1 ;
        
    end
    
    %%% define the axis names
    time = 0 : size(shorttft,1)-1;
    freq = linspace(0,pi,winLength*50);

    %%% take dB
shorttftDB=(20*log10(shorttft))';
    %%% plot a surface plot
surf(time,freq,shorttftDB(1:winLength*50,:))
shading interp
    %%% change the view angle 
view(2)
xlabel('Time Axis','Fontsize',12)
ylabel('Frequency(Hz)','Fontsize',12)
title('Spectrogram','Fontsize',14)
colorbar
ylim([0 pi]);
xlim([0 size(shorttft,1)]);    