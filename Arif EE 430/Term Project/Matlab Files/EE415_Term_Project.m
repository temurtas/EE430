function varargout = EE415_Term_Project(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EE415_Term_Project_OpeningFcn, ...
                   'gui_OutputFcn',  @EE415_Term_Project_OutputFcn, ...
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

function EE415_Term_Project_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
load initialData;
set(handles.outputtext,'String','Waiting for opeation');
handles.imPhantomSheppLogan = imPhantomSheppLogan;
handles.imGorilla = imGorilla;
handles.imCharlie = imCharlie;
handles.imButterfly = imButterfly;
handles.imPhantomContrast = imPhantomContrast;
handles.imPhantomSpatial = imPhantomSpatial;
handles.imMetuEEE = imMetuEEE;
handles.imSquare = imSquare;

sampleImage = handles.imPhantomSheppLogan;
handles.sampleImage = sampleImage;

axes(handles.axes1);
cla;
imagesc(sampleImage); colormap gray; colorbar; title('Original Image','FontSize',16);
guidata(hObject, handles);

function varargout = EE415_Term_Project_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function objectselect_Callback(hObject, eventdata, handles)

axes(handles.axes1);
cla;

imageSelection = get(handles.objectselect, 'Value');
switch imageSelection
    case 8
        imagesc(handles.imCharlie); colormap gray; colorbar; title('Charlie Chaplin','FontSize',16);
        sampleImage = handles.imCharlie;
    case 6
        imagesc(handles.imGorilla); colormap gray; colorbar; title('a Male Mandrill','FontSize',16);
        sampleImage = handles.imGorilla;
    case 7
        imagesc(handles.imButterfly); colormap gray; colorbar; title('Butterfly','FontSize',16);
        sampleImage = handles.imButterfly;
    case 1
        imagesc(handles.imPhantomSheppLogan); colormap gray; colorbar; title('Head Phantom','FontSize',16);
        sampleImage = handles.imPhantomSheppLogan;
    case 2
        imagesc(handles.imSquare); colormap gray; colorbar; title('Impulse','FontSize',16);
        sampleImage = handles.imSquare;
    case 3
        imagesc(handles.imPhantomContrast); colormap gray; colorbar; title('Phantom for Contrast Resolution','FontSize',16);
        sampleImage = handles.imPhantomContrast;
    case 4
        imagesc(handles.imPhantomSpatial); colormap gray; colorbar; title('Phantom for Spatial Resolution','FontSize',16);
        sampleImage = handles.imPhantomSpatial;
    case 5
        imagesc(handles.imMetuEEE); colormap gray; colorbar; title('Logo of the Department','FontSize',16);
        sampleImage = handles.imMetuEEE;
end
handles.sampleImage = sampleImage;
guidata(hObject, handles);

function objectselect_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Phantom','Square','Contrast Resolution','Spatial Resolution','Metu EEE','Baboon', 'Butterfly','Charlie Chaplin'})

function pushradon_Callback(hObject, eventdata, handles)
set(hObject,'Enable','off');
set(hObject,'String','Please Wait');
set(handles.pushiradon,'Enable','off');
set(handles.pushiradon,'String','Please Wait');
drawnow;
object = handles.sampleImage;

angleStepSize = str2num(get(handles.stepsize,'String'));
sampleNumber = str2num(get(handles.samplenumber,'String'));

set(handles.outputtext, 'String', 'Projections are being taken');
drawnow;
[handles.projection handles.t] = radonTransformgui(object,angleStepSize,sampleNumber, handles);


handles.angleStepSize = angleStepSize;
handles.critical = floor([ 0 15 30 45 60 75 90 105 120 135 150 165 ]/angleStepSize +1);
set(handles.outputtext, 'String', 'Projections from the selected image has been taken');
set(hObject,'Enable','on');
set(hObject,'String','Take Projections');
set(handles.pushiradon,'Enable','on');
set(handles.pushiradon,'String','Start Back Projection');
guidata(hObject, handles);

function pushradon_CreateFcn(hObject, eventdata, handles)

function pushiradon_Callback(hObject, eventdata, handles)
set(hObject,'Enable','off');
set(hObject,'String','Please Wait');
set(handles.pushradon,'Enable','off');
set(handles.pushradon,'String','Please Wait');
set(handles.outputtext, 'String', 'Image is being reconstructed');
drawnow;
axes(handles.axes2);
filterStatus = get(handles.filter,'Value');

imageSize = str2num(get(handles.imsize,'String'));

if filterStatus == 1
    filterStatus = 'yes';
else filterStatus = 'no';
end

handles.imageObtained = inverseRadonTransformgui(handles.projection, imageSize, filterStatus,handles);


drawnow;
imagesc(handles.imageObtained); colormap gray; colorbar; title('Image Obtained','FontSize',16);
set(handles.outputtext, 'String', 'Back projection image has been obtained');
set(hObject,'Enable','on');
set(hObject,'String','Start Back Projection');
set(handles.pushradon,'Enable','on');
set(handles.pushradon,'String','Take Projections');
drawnow;
guidata(hObject, handles);

function projectionangle_Callback(hObject, eventdata, handles)

axes(handles.axes2);
cla;
t = handles.t;
projection = handles.projection;
critical = handles.critical;
angleStepSize = handles.angleStepSize;
projectionAngle = get(handles.projectionangle, 'Value');
switch projectionAngle
    case 1
        plot(t,projection(critical(1),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(1)-1)*angleStepSize))) 
    case 2
        plot(t,projection(critical(2),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(2)-1)*angleStepSize)))
    case 3
        plot(t,projection(critical(3),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(3)-1)*angleStepSize)))
    case 4
        plot(t,projection(critical(4),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(4)-1)*angleStepSize)))
    case 5
        plot(t,projection(critical(5),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(5)-1)*angleStepSize))) 
    case 6
        plot(t,projection(critical(6),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(6)-1)*angleStepSize)))
    case 7
        plot(t,projection(critical(7),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(7)-1)*angleStepSize)))
    case 8
        plot(t,projection(critical(8),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(8)-1)*angleStepSize)))
    case 9
        plot(t,projection(critical(9),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(9)-1)*angleStepSize)))
    case 10
        plot(t,projection(critical(10),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(10)-1)*angleStepSize)))
    case 11
        plot(t,projection(critical(11),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(11)-1)*angleStepSize)))
    case 12
        plot(t,projection(critical(12),:), 'Linewidth', 2), title(strcat('p(t) for teta =',{' '},num2str((critical(12)-1)*angleStepSize)))
end
guidata(hObject, handles);

function projectionangle_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'0', '15', '30', '45','60','75', '90', '105','120','135', '150', '165'})

function stepsize_Callback(hObject, eventdata, handles)

function stepsize_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function samplenumber_Callback(hObject, eventdata, handles)

function samplenumber_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function outputtext_CreateFcn(hObject, eventdata, handles)

function pushiradon_CreateFcn(hObject, eventdata, handles)

function imsize_Callback(hObject, eventdata, handles)

function imsize_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function filter_Callback(hObject, eventdata, handles)

function filter_CreateFcn(hObject, eventdata, handles)

function magnify1_Callback(hObject, eventdata, handles)
figure; imagesc(handles.sampleImage); colormap gray; colorbar; title('Original Image');

function magnify2_Callback(hObject, eventdata, handles)
figure; imagesc(handles.imageObtained); colormap gray; colorbar; title('Reconstructed Image');
