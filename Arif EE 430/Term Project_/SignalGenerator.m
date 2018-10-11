function varargout = SignalGenerator(varargin)
% SIGNALGENERATOR MATLAB code for SignalGenerator.fig
%      SIGNALGENERATOR, by itself, creates a new SIGNALGENERATOR or raises the existing
%      singleton*.
%
%      H = SIGNALGENERATOR returns the handle to a new SIGNALGENERATOR or the handle to
%      the existing singleton*.
%
%      SIGNALGENERATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNALGENERATOR.M with the given input arguments.
%
%      SIGNALGENERATOR('Property','Value',...) creates a new SIGNALGENERATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SignalGenerator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SignalGenerator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SignalGenerator

% Last Modified by GUIDE v2.5 07-Dec-2014 22:56:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SignalGenerator_OpeningFcn, ...
                   'gui_OutputFcn',  @SignalGenerator_OutputFcn, ...
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

% --- Executes just before SignalGenerator is made visible.
function SignalGenerator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SignalGenerator (see VARARGIN)


% Choose default command line output for SignalGenerator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using SignalGenerator.
if strcmp(get(hObject,'Visible'),'off')
 % SignalGenerator_OutputFcn(hObject, eventdata, handles);
end

% UIWAIT makes SignalGenerator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SignalGenerator_OutputFcn(hObject, eventdata, handles)
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

%% Parameters

% sampling: 10 kHz
fs = 10000;

% For a second
t = 0:1/fs:1;

% Time vector for a small portion of the signal (to be able to see the signal plot)
ts=0:1/fs:500/fs;

%% Signal Generation

% sine function
x1 = sin(2*pi*1000*t);
x1s= sin(2*pi*1000*ts);

% chirp waveform
x2 = chirp(t,2000,1,4000,'linear'); 
x2s= chirp(ts,2000,1,4000,'linear'); 

%% .WAV files

% file path
wavefile='signal.wav';


%% Plots

m = length(x1);         % Window length
n = pow2(nextpow2(m));  % Transform length
f = (-n/2:n/2-1)*(fs/n);

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        axes(handles.axes1);
        cla;
        plot(ts,x1s);
        title('Generated Waveform');
        xlabel('Time (sec)');
        
        axes(handles.axes2);
        cla;
        fft_x1=abs(fft(x1,n));
        fftshft=fftshift(fft_x1);
        plot(f,abs(fftshft));
        title('Fourier Transform of Generated Waveform');
        xlabel('Frequency (Hz)');
        
        axes(handles.axes3);
        spectrogram(x1, rectwin(100), 50, 1000, fs,'yaxis');
        
        % write to file
        wavwrite(x1,fs,32,wavefile);
    case 2
        axes(handles.axes1);
        cla;
        plot(ts,x2s);
        title('Generated Waveform');
        xlabel('Time (sec)');
        
        axes(handles.axes2);
        fft_x2=abs(fft(x2,n));
        fftshft2=fftshift(fft_x2);
        plot(f,abs(fftshft2));
        title('Fourier Transform of Generated Waveform');
        xlabel('Frequency (Hz)');
        
        axes(handles.axes3);
        spectrogram(x2, rectwin(100), 50, 1000, fs,'yaxis');
        % write to file
        wavwrite(x2,fs,32,wavefile);
end


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
