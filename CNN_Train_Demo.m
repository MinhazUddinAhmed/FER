function varargout = CNN_Train_Demo(varargin)
% CNN_TRAIN_DEMO MATLAB code for CNN_Train_Demo.fig
%      CNN_TRAIN_DEMO, by itself, creates a new CNN_TRAIN_DEMO or raises the existing
%      singleton*.
%
%      H = CNN_TRAIN_DEMO returns the handle to a new CNN_TRAIN_DEMO or the handle to
%      the existing singleton*.
%
%      CNN_TRAIN_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CNN_TRAIN_DEMO.M with the given input arguments.
%
%      CNN_TRAIN_DEMO('Property','Value',...) creates a new CNN_TRAIN_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CNN_Train_Demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CNN_Train_Demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CNN_Train_Demo

% Last Modified by GUIDE v2.5 15-Nov-2016 11:32:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CNN_Train_Demo_OpeningFcn, ...
                   'gui_OutputFcn',  @CNN_Train_Demo_OutputFcn, ...
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

% Definition to Global Variables
function setGlobalfilepath(val)
global filepath
filepath = val;

function r = getGlobalfilepath
global filepath
r = filepath;

function setGlobalfilepath2(val)
global filepath2
filepath2 = val;

function r = getGlobalfilepath2
global filepath2
r = filepath2;


% --- Executes just before CNN_Train_Demo is made visible.
function CNN_Train_Demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CNN_Train_Demo (see VARARGIN)

% Choose default command line output for CNN_Train_Demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CNN_Train_Demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CNN_Train_Demo_OutputFcn(hObject, eventdata, handles) 
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
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
setGlobalfilepath(filepath);
set(handles.PreTrained_Model, 'string', ['Model Path:' filepath]); % update text for x loc



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
setGlobalfilepath2(filepath);
set(handles.IMDB_Path, 'string', ['Model Path:' filepath]); % update text for x loc


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run ../../matlab/vl_setupnn
fprintf('Matconvnet Setup is finished!\n');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdb_path = getGlobalfilepath2;
load(imdb_path);
pretrained_model_path = getGlobalfilepath;
initNet = load(pretrained_model_path);
opt_content  = get(handles.Option_Setting, 'string');
embeded_code = sprintf('opts = struct(%s);',opt_content);
eval(embeded_code);
fprintf('Training Start!\n');
%net = cnnTrain_Modified_V2( imdb, initNet, opts );
net = Matconvnet_CNN_Merge( imdbc, initNet, opts );
fprintf('Training Finish!\n');
save_folder = get(handles.Save_folder, 'string');
save_file = get(handles.Save_file, 'string');
save_option = fullfile([save_folder '/' save_file]);
mkdir(save_folder);
embeded_code = sprintf('save(''%s'', ''-struct'', ''net'');',save_option);
eval(embeded_code);
fprintf('Trained Model Saved!\n');




function Option_Setting_Callback(hObject, eventdata, handles)
% hObject    handle to Option_Setting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Option_Setting as text
%        str2double(get(hObject,'String')) returns contents of Option_Setting as a double


% --- Executes during object creation, after setting all properties.
function Option_Setting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Option_Setting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Save_folder_Callback(hObject, eventdata, handles)
% hObject    handle to Save_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Save_folder as text
%        str2double(get(hObject,'String')) returns contents of Save_folder as a double


% --- Executes during object creation, after setting all properties.
function Save_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Save_file_Callback(hObject, eventdata, handles)
% hObject    handle to Save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Save_file as text
%        str2double(get(hObject,'String')) returns contents of Save_file as a double


% --- Executes during object creation, after setting all properties.
function Save_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
