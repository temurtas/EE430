function varargout = guispec(varargin)
% GUISPEC MATLAB code for guispec.fig
%      GUISPEC, by itself, creates a new GUISPEC or raises the existing
%      singleton*.
%
%      H = GUISPEC returns the handle to a new GUISPEC or the handle to
%      the existing singleton*.
%
%      GUISPEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISPEC.M with the given input arguments.
%
%      GUISPEC('Property','Value',...) creates a new GUISPEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guispec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guispec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guispec

% Last Modified by GUIDE v2.5 25-Jan-2016 11:34:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guispec_OpeningFcn, ...
                   'gui_OutputFcn',  @guispec_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guispec is made visible.
function guispec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guispec (see VARARGIN)

% Choose default command line output for guispec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.counter,'String','Waiting for my MASTER');
% UIWAIT makes guispec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guispec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Record.
function Record_Callback(hObject, eventdata, handles)
% hObject    handle to Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs=str2num(get(handles.Fs,'String'));
time=str2num(get(handles.time,'String'));
wsize=str2num(get(handles.WindowSize,'String'));
dftsize=str2num(get(handles.dftsize,'String'));

h=dsp.AudioRecorder('SampleRate',fs);
h2=dsp.SpectrumAnalyzer('SampleRate',fs,...
                        'FrequencyResolutionMethod','WindowLength',...
                        'Window','Rectangular',...
                        'FFTLengthSource','Property',...
                        'WindowLength',wsize,...
                        'FFTLength',dftsize);
                    
set(handles.counter,'String','Recording..');
k=0;

while length(k)/fs<time
    y=step(h);
    y(:,2)=[];

    h2.WindowLength=str2num(get(handles.WindowSize,'String'));
    wtype=get(handles.popup,'Value');
    switch wtype
    case 1
        out=hamming(length(y)).*y;
    case 2
       out=rectwin(length(y)).*y;
    case 3
        out=triang(length(y)).*y;
    case 4
        out=gausswin(length(y)).*y;
    case 5
        out=blackman(length(y)).*y;
    case 6
        out=tukeywin(length(y)).*y;
    end
    step(h2,out);
    k=[k;y];
end

set(handles.counter,'String','Done');
pause(2);
set(handles.counter,'String','Waiting for my MASTER');
handles.fs=str2num(get(handles.Fs,'String'));
handles.y=k;length(k)
guidata(hObject,handles);

function WindowSize_Callback(hObject, eventdata, handles)
% hObject    handle to WindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WindowSize as text
%        str2double(get(hObject,'String')) returns contents of WindowSize as a double


% --- Executes during object creation, after setting all properties.
function WindowSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Overlap_Callback(hObject, eventdata, handles)
% hObject    handle to Overlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Overlap as text
%        str2double(get(hObject,'String')) returns contents of Overlap as a double


% --- Executes during object creation, after setting all properties.
function Overlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Overlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fs_Callback(hObject, eventdata, handles)
% hObject    handle to Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fs as text
%        str2double(get(hObject,'String')) returns contents of Fs as a double


% --- Executes during object creation, after setting all properties.
function Fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
y=handles.y;
fs=handles.fs;
order=600;
audio=dsp.SignalSource('SamplesPerFrame',fs);
audio.Signal=y;
player=dsp.AudioPlayer('SampleRate',fs,...
                        'ChannelMappingSource','Property',...
                        'ChannelMapping',[1 2]);
                   
if(fs>32000)
b1=fir1(order,32/fs*2);[h1,f1]=freqz(b1,1);
b2=fir1(order,[32/fs*2 64/fs*2]);[h2,f2]=freqz(b2,1);
b3=fir1(order,[64/fs*2 125/fs*2]);[h3,f3]=freqz(b3,1);
b4=fir1(order,[125/fs*2 250/fs*2]);[h4,f4]=freqz(b4,1);
b5=fir1(order,[250/fs*2 500/fs*2]);[h5,f5]=freqz(b5,1);
b6=fir1(order,[500/fs*2 1000/fs*2]);[h6,f6]=freqz(b6,1);
b7=fir1(order,[1000/fs*2 2000/fs*2]);[h7,f7]=freqz(b7,1);
b8=fir1(order,[2000/fs*2 4000/fs*2]);[h8,f8]=freqz(b8,1);
b9=fir1(order,[4000/fs*2 8000/fs*2]);[h9,f9]=freqz(b9,1);
b10=fir1(order,[8000/fs*2 16000/fs*2]);[h10,f10]=freqz(b10,1);
[b52,a52]=cheby1(3,1,[250/fs*2 500/fs*2],'bandpass');
end

checksum=1;
katsayi=1;
gecici=0;
gecici2=0;
if(get(handles.radiobutton3,'Value')==1)
while(~isDone(audio))
    tic;
    temp=step(audio);
    gain1=get(handles.slider1,'Value');
    gain2=get(handles.slider2,'Value');
    gain3=get(handles.slider3,'Value');
    gain4=get(handles.slider4,'Value');
    gain5=get(handles.slider5,'Value');
    gain6=get(handles.slider6,'Value');
    gain7=get(handles.slider7,'Value');
    gain8=get(handles.slider8,'Value');
    gain9=get(handles.slider9,'Value');
    gain10=get(handles.slider10,'Value');
    
    
    if(~get(handles.checkbox2,'Value'))
        out=filter(gain1*b1+gain2*b2+gain3*b3+gain4*b4+gain5*b5+gain6*b6+gain7*b7+gain8*b8+gain9*b9+gain10*b10,1,temp);
    else
        out=filter(gain1*b1+gain2*b2+gain3*b3+gain4*b4+gain6*b6+gain7*b7+gain8*b8+gain9*b9+gain10*b10,1,temp)+filter(b52,a52,temp);
    end
    
    gecici=[gecici;out];
    gecici2=[gecici2;temp];
    
    slip=get(handles.checkbox3,'Value');
    rev=get(handles.checkbox7,'Value');
    
    
    if(rev)
        out=filter([0.8 zeros(1,3999) 1],[1 zeros(1,3999) .7],temp);
    end
    
     if(get(handles.slider19,'Value')~=checksum)
         player.SampleRate=get(handles.slider19,'Value')*fs;
         katsayi=get(handles.slider19,'Value');
         checksum=get(handles.slider19,'Value');
    end
   
 
    step(player,[out circshift(out,5000*slip)]);
    
    plot(temp,'parent',handles.axes3);title('Original Signal','parent',handles.axes3);drawnow;
    plot(out,'parent',handles.axes1);title('Filtered Signal','parent',handles.axes1);drawnow;
 
  
    pause(1/katsayi-.1-toc);
end
else
    while(~isDone(audio))
    tic;
    temp=step(audio);
    slip=get(handles.checkbox3,'Value');
    rev=get(handles.checkbox7,'Value');
         if(rev)
          out=filter([0.8 zeros(1,3900) 1],[1 zeros(1,3900) .7],temp);
         else
           out=temp;
         end
    
          if(get(handles.slider19,'Value')~=checksum)
         player.SampleRate=get(handles.slider19,'Value')*1.5/1.2*fs;
         katsayi=get(handles.slider19,'Value')*1.5/1.2;
         checksum=get(handles.slider19,'Value');
          end
    step(player,[out circshift(out,1024*5*slip)]);

    pause(1/katsayi-.1-toc);
    end
end

if(get(handles.checkbox8,'Value'))
%%%%%%%%%%%%%%%%%%%%

n=round((length(gecici)-1000)/(1000)+0.5);
for k=1:1:n+1
    free1=circshift(gecici,-(k-1)*(1000));
    main(:,k)=free1(1:1000);
end
z=20*log10((abs(fft(main))));
%%%%%%%%%%%%%%%%%%%
n=round((length(gecici2)-1000)/(1000)+0.5);
for k=1:1:n+1
    free2=circshift(gecici2,-(k-1)*(1000));
    main(:,k)=free2(1:1000);
end
z2=20*log10((abs(fft(main))));
%%%%%%%%%%%%%%%%%%%%%
figure;
xaxis=(1000/2:1000:1000*n+1000/2)/fs;
yaxis=0:fs/1000:fs*(1000-1)/1000;
imagesc(xaxis,yaxis,z);colormap jet;xlabel('Time');ylabel('Frequency(Hz)');title('Spectrogram of Filtered Signal');
%%%%%%%%%%%%%%%%%%%%%
figure;
xaxis=(1000/2:1000:1000*n+1000/2)/fs;
yaxis=0:fs/1000:fs*(1000-1)/1000;
imagesc(xaxis,yaxis,z2);colormap jet;xlabel('Time');ylabel('Frequency(Hz)');title('Spectrogram of Non-Filtered Signal');
%%%%%%%%%%%%%%%%%%%%%
end

% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
fs=handles.fs;
y=handles.y;

time=str2num(get(handles.time,'String'));
wsize=str2num(get(handles.WindowSize,'String'));
overlap=str2num(get(handles.Overlap,'String'));
dftsize=str2num(get(handles.dftsize,'String'));

t=1/fs:1/fs:length(y)/fs;
n=round((length(y)-wsize)/(wsize-overlap)+0.5);
for k=1:1:n+1
    temp=circshift(y,-(k-1)*(wsize-overlap));
    main(:,k)=temp(1:wsize);
end

wtype=get(handles.popup,'Value');
switch wtype
    case 1
        main=main.*(hamming(wsize)*ones(1,n+1));
    case 2
        main=main.*(rectwin(wsize)*ones(1,n+1));
    case 3
        main=main.*(triang(wsize)*ones(1,n+1));
    case 4
        main=main.*(gausswin(wsize)*ones(1,n+1));
    case 5
        main=main.*(blackman(wsize)*ones(1,n+1));
    case 6
        main=main.*(tukeywin(wsize)*ones(1,n+1));
end
z=20*log10((abs(fft(main,dftsize))));
xaxis=(wsize/2:wsize-overlap:(wsize-overlap)*n+wsize/2)/fs;
yaxis=0:fs/dftsize:fs*(dftsize-1)/dftsize;

imagesc(xaxis,yaxis,z,'parent',handles.axes1);colormap jet;
mesh(z,'parent',handles.axes2);
plot(t,y,'parent',handles.axes3);



function Counter_Callback(hObject, eventdata, handles)
% hObject    handle to Counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Counter as text
%        str2double(get(hObject,'String')) returns contents of Counter as a double

% --- Executes during object creation, after setting all properties.
function Counter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chirp.
function chirp_Callback(hObject, eventdata, handles)
% hObject    handle to chirp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
time=str2num(get(handles.time,'String'));
fs=str2num(get(handles.Fs,'String'));

y=chirp(1/fs:1/fs:time,100,2,1000,'quadratic');
handles.y=y';
handles.fs=fs;

guidata(hObject,handles);


% --- Executes on selection change in popup.
function popup_Callback(hObject, eventdata, handles)
% hObject    handle to popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup


% --- Executes during object creation, after setting all properties.

function popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popup.
function popup_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directory=uigetfile();
[y,fs]=audioread(directory);
y(:,2)=[];

handles.y=y(str2num(get(handles.start,'String'))*fs:str2num(get(handles.stop,'String'))*fs);
handles.fs=fs;
guidata(hObject,handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3



function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start as text
%        str2double(get(hObject,'String')) returns contents of start as a double


% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop as text
%        str2double(get(hObject,'String')) returns contents of stop as a double


% --- Executes during object creation, after setting all properties.
function stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in terminate.
function terminate_Callback(hObject, eventdata, handles)
% hObject    handle to terminate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function dftsize_Callback(hObject, eventdata, handles)
% hObject    handle to dftsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dftsize as text
%        str2double(get(hObject,'String')) returns contents of dftsize as a double


% --- Executes during object creation, after setting all properties.
function dftsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dftsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in mix.
function mix_Callback(hObject, eventdata, handles)
% hObject    handle to mix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
y=handles.y;
fs=handles.fs;
f=str2num(get(handles.noise,'String'));
noise=0.5*cos(2*pi*f*(0:1/fs:(length(y)-1)/fs)');
noised=y+noise;
handles.noised=noised;


guidata(hObject,handles);



function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a double


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in unfiltered.
function unfiltered_Callback(hObject, eventdata, handles)
% hObject    handle to unfiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
y=handles.y;
fs=handles.fs;
noised=handles.noised;
soundsc(noised,fs);

n=round((length(noised)-1000)/(1000)+0.5);
for k=1:1:n+1
    temp=circshift(noised,-(k-1)*(1000));
    main(:,k)=temp(1:1000);
end
z=20*log10((abs(fft(main))));
figure;
xaxis=(1000/2:1000:1000*n+1000/2)/fs;
yaxis=0:fs/1000:fs*(1000-1)/1000;
imagesc(xaxis,yaxis,z);colormap jet;xlabel('Time');ylabel('Frequency(Hz)');title('Spectrogram of Non-Filtered Signal');


% --- Executes on button press in filtered.
function filtered_Callback(hObject, eventdata, handles)
% hObject    handle to filtered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
y=handles.y;
fs=handles.fs;
noised=handles.noised;
%noised=y;

wsize=fs/10;
n=round((length(noised)-wsize)/wsize+0.5);
for k=1:1:n+1
    temp=circshift(noised,-(k-1)*(wsize));
    main(:,k)=temp(1:wsize);
end

z=abs(fft(main));
eval=mean(z');
index=find(eval==max(eval))
fc=(index(1)-1)*fs/wsize;
nom=fir1(2000,[(fc-50)/fs*2 (fc+50)/fs*2],'stop');
filtered=filter(nom,1,noised);
soundsc(filtered,fs);
handles.filtered=filtered;


clear main;
clear temp;
n=round((length(filtered)-1000)/(1000)+0.5);
for k=1:1:n+1
    temp=circshift(filtered,-(k-1)*(1000));
    main(:,k)=temp(1:1000);
end
z=20*log10((abs(fft(main))));
figure;
xaxis=(1000/2:1000:1000*n+1000/2)/fs;
yaxis=0:fs/1000:fs*(1000-1)/1000;
imagesc(xaxis,yaxis,z);colormap jet;xlabel('Time');ylabel('Frequency(Hz)');title('Spectrogram of Filtered Signal');

guidata(hObject,handles);


% --- Executes on slider movement.
function slider19_Callback(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1,'Value',0.5);
set(handles.slider2,'Value',0.5);
set(handles.slider3,'Value',0.5);
set(handles.slider4,'Value',0.5);
set(handles.slider5,'Value',0.5);
set(handles.slider6,'Value',0.5);
set(handles.slider7,'Value',0.5);
set(handles.slider8,'Value',0.5);
set(handles.slider9,'Value',0.5);
set(handles.slider10,'Value',0.5);



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in allpass.
function allpass_Callback(hObject, eventdata, handles)
% hObject    handle to allpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1,'Value',1);
set(handles.slider2,'Value',1);
set(handles.slider3,'Value',1);
set(handles.slider4,'Value',1);
set(handles.slider5,'Value',1);
set(handles.slider6,'Value',1);
set(handles.slider7,'Value',1);
set(handles.slider8,'Value',1);
set(handles.slider9,'Value',1);
set(handles.slider10,'Value',1);


% --- Executes on button press in nopass.
function nopass_Callback(hObject, eventdata, handles)
% hObject    handle to nopass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1,'Value',0);
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0);
set(handles.slider4,'Value',0);
set(handles.slider5,'Value',0);
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);
set(handles.slider8,'Value',0);
set(handles.slider9,'Value',0);
set(handles.slider10,'Value',0);


% --- Executes on button press in incwsize.
function incwsize_Callback(hObject, eventdata, handles)
% hObject    handle to incwsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2num(get(handles.WindowSize,'String'));
set(handles.WindowSize,'String',num2str(x+1000));


% --- Executes on button press in decwsize.
function decwsize_Callback(hObject, eventdata, handles)
% hObject    handle to decwsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2num(get(handles.WindowSize,'String'));
set(handles.WindowSize,'String',num2str(x-1000));

% --- Executes on button press in decdftsize.
function decdftsize_Callback(hObject, eventdata, handles)
% hObject    handle to decdftsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2num(get(handles.dftsize,'String'));
set(handles.dftsize,'String',num2str(x-1000));

% --- Executes on button press in incdftsize.
function incdftsize_Callback(hObject, eventdata, handles)
% hObject    handle to incdftsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2num(get(handles.dftsize,'String'));
set(handles.dftsize,'String',num2str(x+1000));


% --- Executes on button press in toggle.
function toggle_Callback(hObject, eventdata, handles)
% hObject    handle to toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider19,'Value',1);


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
