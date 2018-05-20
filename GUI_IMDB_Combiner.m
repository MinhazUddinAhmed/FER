function varargout = GUI_IMDB_Combiner(varargin)
% GUI_IMDB_COMBINER MATLAB code for GUI_IMDB_Combiner.fig
%      GUI_IMDB_COMBINER, by itself, creates a new GUI_IMDB_COMBINER or raises the existing
%      singleton*.
%
%      H = GUI_IMDB_COMBINER returns the handle to a new GUI_IMDB_COMBINER or the handle to
%      the existing singleton*.
%
%      GUI_IMDB_COMBINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_IMDB_COMBINER.M with the given input arguments.
%
%      GUI_IMDB_COMBINER('Property','Value',...) creates a new GUI_IMDB_COMBINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_IMDB_Combiner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_IMDB_Combiner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_IMDB_Combiner

% Last Modified by GUIDE v2.5 03-Jan-2017 14:14:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_IMDB_Combiner_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_IMDB_Combiner_OutputFcn, ...
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


% --- Executes just before GUI_IMDB_Combiner is made visible.
function GUI_IMDB_Combiner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_IMDB_Combiner (see VARARGIN)

% Choose default command line output for GUI_IMDB_Combiner
handles.output = hObject;

img_sample = imread('Sample Image.png');
axes(handles.axes1);
imshow(img_sample);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_IMDB_Combiner wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_IMDB_Combiner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdb_Index = get(handles.Index, 'string');
imdb_Index_number = str2double(imdb_Index);

IMDB_Length = get(handles.IMDB_Length, 'string');
IMDB_Length_number = str2double(IMDB_Length);
imdb_Index = get(handles.Index, 'string');
imdb_Index_number = str2double(imdb_Index);

imdb_Index_number = imdb_Index_number + 1;

if imdb_Index_number > IMDB_Length_number
    h = msgbox('Invalid Value', 'Error','error');
    imdb_Index_number = IMDB_Length_number;
end

set(handles.Index, 'string', imdb_Index_number);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdb_Index = get(handles.Index, 'string');
imdb_Index_number = str2double(imdb_Index);
imdb_Index_number = imdb_Index_number - 1;

if imdb_Index_number < 1
    h = msgbox('Invalid Value', 'Error','error');
    imdb_Index_number = 1;
end

set(handles.Index, 'string', imdb_Index_number);


function Index_Callback(hObject, eventdata, handles)
% hObject    handle to Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Index as text
%        str2double(get(hObject,'String')) returns contents of Index as a double


% --- Executes during object creation, after setting all properties.
function Index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IMDB_Length = get(handles.IMDB_Length, 'string');
IMDB_Length_number = str2double(IMDB_Length);

if IMDB_Length_number == 0
    h = msgbox('No IMDB', 'Error','error');
end

imdb_Index = get(handles.Index, 'string');
imdbc = evalin('base', 'imdb_show');

imdb_Index_num = str2double(imdb_Index);

img = imdbc.images.data(:,:,:,imdb_Index_num);
label_val = imdbc.images.labels(1,imdb_Index_num);
set_val = imdbc.images.set(1,imdb_Index_num);

set(handles.label_text, 'string', label_val);
set(handles.set_text, 'string', set_val);

axes(handles.axes1);
imshow(img);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IMDB_Length = get(handles.IMDB_Length, 'string');
IMDB_Length_number = str2double(IMDB_Length);

if IMDB_Length_number == 0
    h = msgbox('No IMDB', 'Error','error');
end

imdbc = evalin('base', 'imdbc');
save_folder = 'imdbc.mat';
[file,path] = uiputfile(save_folder,'Save file name');
save_path = fullfile([path file]);
save(save_path,'imdbc');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdb1 = evalin('base', 'imdb1');
imdb2 = evalin('base', 'imdb2');

imdbc.images.labels = cat(2,imdb1.images.labels,imdb2.images.labels);
imdbc.images.set = cat(2,imdb1.images.set,imdb2.images.set);
imdbc.images.data = cat(4,imresize(imdb1.images.data, [227 227]),imresize(imdb2.images.data, [227 227]));

imdb_length = size(imdbc.images.labels,2);
assignin('base','imdbc_Length',imdb_length);

% set(handles.IMDB_Length, 'string', imdb_length);
% set(handles.Index, 'string', 1);

assignin('base','imdbc',imdbc);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
load(filepath);
assignin('base','imdb2',imdbc);
imdb_length = size(imdbc.images.labels,2);
assignin('base','imdb2_Length',imdb_length);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
load(filepath);
assignin('base','imdb1',imdbc);
imdb_length = size(imdbc.images.labels,2);
assignin('base','imdb1_Length',imdb_length);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checker_radio = get(handles.checker,'SelectedObject');
checker_content = get(checker_radio,'String');
      
switch checker_content
   case 'IMDB1'
       imdb1 = evalin('base', 'imdb1');
       imdb_Length = evalin('base', 'imdb1_Length');
       imdb_show = imdb1;
   case 'IMDB2'
       imdb2 = evalin('base', 'imdb2');
       imdb_Length = evalin('base', 'imdb2_Length');
       imdb_show = imdb2;
   case 'IMDBC'
       imdbc = evalin('base', 'imdbc');  
       imdb_Length = evalin('base', 'imdbc_Length');
       imdb_show = imdbc;
end

imdb_Length_number =imdb_Length;
%imdb_Length_number = str2double(imdb_Length);
set(handles.IMDB_Length, 'string', imdb_Length_number);
set(handles.Index, 'string', 1);

assignin('base','imdb_show',imdb_show);
assignin('base','imdb_show_Length',imdb_Length_number);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
% Clear the variables
clearstr = 'clear all';
evalin('base',clearstr);
% Delete the figure
delete(handles.figure1);
%quit; % only for make exe file for quit program


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
load(filepath);
imdb2 = imdbc;
clear imdbc;

imdb1 = evalin('base', 'imdbc');

imdbc.images.labels = cat(2,imdb1.images.labels,imdb2.images.labels);
imdbc.images.set = cat(2,imdb1.images.set,imdb2.images.set);
imdbc.images.data = cat(4,imresize(imdb1.images.data, [227 227]),imresize(imdb2.images.data, [227 227]));

imdb_length = size(imdbc.images.labels,2);

assignin('base','imdbc_Length',imdb_length);
assignin('base','imdbc',imdbc);
