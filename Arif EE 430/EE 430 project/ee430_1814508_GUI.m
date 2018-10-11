function varargout = ee430_1814508_GUI(varargin)
% EE430_1814508_GUI MATLAB code for ee430_1814508_GUI.fig
%      EE430_1814508_GUI, by itself, creates a new EE430_1814508_GUI or raises the existing
%      singleton*.
%
%      H = EE430_1814508_GUI returns the handle to a new EE430_1814508_GUI or the handle to
%      the existing singleton*.
%
%      EE430_1814508_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EE430_1814508_GUI.M with the given input arguments.
%
%      EE430_1814508_GUI('Property','Value',...) creates a new EE430_1814508_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ee430_1814508_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ee430_1814508_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ee430_1814508_GUI

% Last Modified by GUIDE v2.5 02-Jan-2015 21:38:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ee430_1814508_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ee430_1814508_GUI_OutputFcn, ...
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


% --- Executes just before ee430_1814508_GUI is made visible.
function ee430_1814508_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ee430_1814508_GUI (see VARARGIN)

% Choose default command line output for ee430_1814508_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ee430_1814508_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ee430_1814508_GUI_OutputFcn(hObject, eventdata, handles) 
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
cla
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 3);
disp('End of Recording.');
%play(recObj);
y = getaudiodata(recObj);
z = abs(fftshift(fft(y)));
t=length(z)/2;
freq=(-t+1):1:t;
freq2=0:1:t;
for k=1:1:t+1
    zz(k,1)=z(t+k-1,1);
end
f = fit(freq2.',zz,'gauss4');
[y_max index] = max(zz);
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
beststr=num2str(best);
set(handles.edit1,'string', beststr)
plot (freq2,zz);
axis([0 max(freq2) 0 max(zz)]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on
hold on
plot(f);

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
    depth=((volume-97.14)/(pi*2.25*2.25))+8.4;
end
depthstr=num2str(depth);
set(handles.edit2,'string', depth)


% --- Executes on button press in pushbutton2.




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
