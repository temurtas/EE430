function varargout = EE430_Term_Project(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EE430_Term_Project_OpeningFcn, ...
                   'gui_OutputFcn',  @EE430_Term_Project_OutputFcn, ...
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

function EE430_Term_Project_OpeningFcn(hObject, eventdata, handles, varargin)

handles.recObj = audiorecorder(44100, 16, 1);
handles.status = 0;
handles.output = hObject;
handles.windowType = 1;


guidata(hObject, handles);


function varargout = EE430_Term_Project_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function window_Callback(hObject, eventdata, handles)
windowLength = str2num(get(handles.windowlen,'String'));
windowLength = floor(44.1*windowLength);
handles.windowType = get(handles.window, 'Value');
switch handles.windowType
    case 1
        win=ones(1,windowLength); 
    case 2
        win=hann(windowLength)';
    case 3
        win=hamming(windowLength)'; 
    case 4
        win=gausswin(windowLength)'; 
    case 5
        win=blackman(windowLength)'; 
    case 6
        win=chebwin(windowLength)'; 
    case 7
        win=flattopwin(windowLength)'; 
    case 8
        win=kaiser(windowLength)'; 
    case 9
        win=taylorwin(windowLength)';
    case 10
        win=tukeywin(windowLength)';  
end
handles.win = win;
handles.status = 0;
guidata(hObject, handles);

function windowlen_Callback(hObject, eventdata, handles)
handles.status = 0;
guidata(hObject, handles);

function windowlen_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function window_CreateFcn(hObject, eventdata, handles)
handles.win = ones(1,22050);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);
set(hObject, 'String', {'Rectangular','Hann','Hamming','Gauss','Blackman','Chebwin', 'Flat Top','Kaiser','Taylor','Tukey'})

function starter_Callback(hObject, eventdata, handles)
if handles.status == 0
    handles.status = 1;
end
check = 0;
if handles.status
 windowLength = str2num(get(handles.windowlen,'String'));
    windowLength = floor(44.1*windowLength);
tic
record(handles.recObj);
pause(1.5);
i = 1;
measurementArray = zeros(1,2);
handles.height = 0;
set(handles.outputtext, 'String', 'Please start blowing');
while toc<=11.5
   windowLength = floor(str2num(get(handles.windowlen,'String'))*44.1);
    sample = getaudiodata(handles.recObj);
    handles.samplingFrequency = 44100;
    handles.sample = sample(length(sample)-windowLength+1 : length(sample))'.*handles.win;
    frequency = frequencyEstimator(handles.sample,handles.samplingFrequency);
    pause(0.1)
    measurementArray(i) = frequency;
    
    if frequency
        i = i+1;
        check = 1;
    else if check
        average = mean(measurementArray(1:length(measurementArray)-1));
 
        x = average;
        handles.height = -11.03+0.07997*x-0.000062*x^2;
        handles.height = round(handles.height*100)/100;
        set(handles.outputtext, 'String', strcat('The height of the water in the bottle is',{'  '},num2str(handles.height)));
        drawnow;
        i = 1;
        measurementArray = zeros(1,2);
        check = 0;
        end
    end
end
set(handles.outputtext, 'String', strcat('Last measurement is',{' '},num2str(handles.height),{'   '},'Please start again'));
drawnow;
end
guidata(hObject, handles);

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_CreateFcn(hObject, eventdata, handles)
handles.status = 0;
guidata(hObject, handles);

function pushspect_Callback(hObject, eventdata, handles)
clear handles.recObj
handles.recObj = audiorecorder(16000, 16, 1);
record(handles.recObj);
axes(handles.axes1);
handles.winShift = str2num(get(handles.winshift,'String'));
duration = str2num(get(handles.recordduration,'String'));
windowLength = str2num(get(handles.windowlen,'String'));
handles.windowLength = floor(44.1*windowLength);
tic
while toc<=duration
    set(handles.outputtext, 'String','Recording');
    drawnow;
end
handles.signal = getaudiodata(handles.recObj);
set(handles.outputtext, 'String','recording is being processed');
drawnow;
spect(handles.signal,handles.windowLength,handles.winShift,handles.win);
set(handles.outputtext, 'String', 'Processing is completed');
guidata(hObject, handles);

function winshift_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function recordduration_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function outputtext_CreateFcn(hObject, eventdata, handles)

function pushspect_CreateFcn(hObject, eventdata, handles)

function axes1_CreateFcn(hObject, eventdata, handles)

function starter_CreateFcn(hObject, eventdata, handles)

function recordduration_Callback(hObject, eventdata, handles)

function winshift_Callback(hObject, eventdata, handles)
