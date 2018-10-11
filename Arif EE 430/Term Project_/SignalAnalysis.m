function varargout = SignalAnalysis(varargin)
% SIGNALANALYSIS MATLAB code for SignalAnalysis.fig
%      SIGNALANALYSIS, by itself, creates a new SIGNALANALYSIS or raises the existing
%      singleton*.
%
%      H = SIGNALANALYSIS returns the handle to a new SIGNALANALYSIS or the handle to
%      the existing singleton*.
%
%      SIGNALANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNALANALYSIS.M with the given input arguments.
%
%      SIGNALANALYSIS('Property','Value',...) creates a new SIGNALANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SignalAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SignalAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SignalAnalysis

% Last Modified by GUIDE v2.5 07-Dec-2014 23:39:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SignalAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @SignalAnalysis_OutputFcn, ...
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

% --- Executes just before SignalAnalysis is made visible.
function SignalAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SignalAnalysis (see VARARGIN)


% Choose default command line output for SignalAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using SignalAnalysis.
if strcmp(get(hObject,'Visible'),'off')
 % SignalAnalysis_OutputFcn(hObject, eventdata, handles);
end

%%

% UIWAIT makes SignalAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SignalAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(strcmp(get(handles.pushbutton1, 'String'),'Start Receiving'))
set(handles.pushbutton1, 'String','Stop Receiving');
else
set(handles.pushbutton1, 'String','Start Receiving');   
end


%% Parameters
Fs = 10000;
duration = 1;  

t=0:1/Fs:(duration)-1/Fs;
tcorr=0:1:(2*Fs.*duration)-2;
%tcorr=tcorr./2;
t1 = 0:1/Fs:1-1/Fs;
x1 = sin(2*pi*1000*t);

while (strcmp(get(handles.pushbutton1, 'String'),'Stop Receiving'))
AI = analoginput('winsound');
addchannel(AI, 1);
             
set (AI, 'SampleRate', Fs)     
set(AI, 'SamplesPerTrigger', duration*Fs);
start(AI);
data = getdata(AI);
delete(AI) 

m = length(data);       % Window length
n = pow2(nextpow2(m));  % Transform length
f = (-n/2:n/2-1)*(Fs/n);


%% Time Domain
axes(handles.axes1);
plot(t,data);
title('Received Signal in Time Domain');
xlabel('Time (sec)');

%% Fourier Transform
fft_x1=fft(data,n);
fft_x1=fftshift(fft_x1);
w=linspace(-Fs/2,Fs/2,length(data));
axes(handles.axes2);
plot(f,abs(fft_x1));
title('Fourier Transform');
xlabel('Frequency (Hz)');



%% Spectrogram
axes(handles.axes4);
spectrogram(data, rectwin(100), 50, 1000,Fs,'yaxis');
title('Spectrogram of Received Signal');


popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        x1 = sin(2*pi*1000*t);
    case 2
        x1 = chirp(t1,2000,1,4000);
end

%% Correlation
axes(handles.axes3);
xcor=xcorr(data,x1);
plot(xcor);
title('Cross Correlation');

%% Fourier of Cross Correlation
axes(handles.axes5);
xcorfft=fft(xcor);
plot(tcorr,abs(xcorfft));
title('Fourier Transform of Cross Correlation');
xlabel('time');


%drawnow;
%ylim([-10,10]);

end 

guidata(hObject,handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'sine waveform (1 kHz)', 'chirp waveform (2-4 kHz)'});


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


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
