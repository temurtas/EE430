function varargout = MyTuner(varargin)
% MYTUNER MATLAB code for MyTuner.fig
%      MYTUNER, by itself, creates a new MYTUNER or raises the existing
%      singleton*.
%
%      H = MYTUNER returns the handle to a new MYTUNER or the handle to
%      the existing singleton*.
%
%      MYTUNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYTUNER.M with the given input arguments.
%
%      MYTUNER('Property','Value',...) creates a new MYTUNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MyTuner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MyTuner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MyTuner

% Last Modified by GUIDE v2.5 10-Jan-2015 23:41:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyTuner_OpeningFcn, ...
                   'gui_OutputFcn',  @MyTuner_OutputFcn, ...
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


% --- Executes just before MyTuner is made visible.
function MyTuner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MyTuner (see VARARGIN)

% Choose default command line output for MyTuner
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyTuner wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MyTuner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tone;
double k;
int i;
Fs=44100;
tone=wavrecord(Fs*4,Fs);
w = hamming(Fs*4);
fftofsound=fft(tone.*w);
figure;
plot(abs(fftofsound));
[~,peakfreq]=max(abs(fftofsound));
peakfreq=peakfreq/4;
set(handles.result,'String',num2str(peakfreq));
set(handles.hz,'String','Hz');
k=round(12*log2(peakfreq/16.35));
set(handles.actual,'String','Exact frequency is: ');
set(handles.actualfreq,'String',num2str(16.35*(2^(k/12))));
set(handles.hz2,'String','Hz');
i=0;
while(k>=12)
    k=k-12;
    i=i+1;
end
set(handles.number,'String',num2str(i));
if(k==1||k==3||k==6||k==8||k==10)
    set(handles.diyez,'String','#');
else
    set(handles.diyez,'String','');
end
if(k<5)
    k=floor(k/2);
else
    k=ceil(k/2);
end
    
set(handles.nota,'String',char(65+mod(k+2,7)));
