function varargout = GUI_Active_Learning_For_IMDB(varargin)
% GUI_ACTIVE_LEARNING_FOR_IMDB MATLAB code for GUI_Active_Learning_For_IMDB.fig
%      GUI_ACTIVE_LEARNING_FOR_IMDB, by itself, creates a new GUI_ACTIVE_LEARNING_FOR_IMDB or raises the existing
%      singleton*.
%
%      H = GUI_ACTIVE_LEARNING_FOR_IMDB returns the handle to a new GUI_ACTIVE_LEARNING_FOR_IMDB or the handle to
%      the existing singleton*.
%
%      GUI_ACTIVE_LEARNING_FOR_IMDB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ACTIVE_LEARNING_FOR_IMDB.M with the given input arguments.
%
%      GUI_ACTIVE_LEARNING_FOR_IMDB('Property','Value',...) creates a new GUI_ACTIVE_LEARNING_FOR_IMDB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Active_Learning_For_IMDB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Active_Learning_For_IMDB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Active_Learning_For_IMDB

% Last Modified by GUIDE v2.5 18-Jan-2017 13:24:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Active_Learning_For_IMDB_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Active_Learning_For_IMDB_OutputFcn, ...
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


% --- Executes just before GUI_Active_Learning_For_IMDB is made visible.
function GUI_Active_Learning_For_IMDB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Active_Learning_For_IMDB (see VARARGIN)

% Choose default command line output for GUI_Active_Learning_For_IMDB
handles.output = hObject;

imdb_length = 0;
assignin('base','imdb_length',imdb_length);
set(handles.imdb_length, 'string', imdb_length);

img_sample = imread('Sample Image.png');
axes(handles.axes1);
imshow(img_sample);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Active_Learning_For_IMDB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Active_Learning_For_IMDB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
load(filepath);
assignin('base','imdbc',imdbc);
imdb_length = size(imdbc.images.labels,2);
set(handles.imdb_length, 'string', imdb_length);
assignin('base','imdb_length',imdb_length);

set(handles.IMDB_Index, 'string', 1);
img = imdbc.images.data(:,:,:,1);
axes(handles.axes1);
imshow(img);
assignin('base','img',img);

%--------------------Check the Radio Button------------------------%

label_content = imdbc.images.labels(1,1);
set_content = imdbc.images.set(1,1);

switch label_content
    case 1
        set(handles.Label_checker,'selectedobject',handles.radiobutton1); % Angry
    case 2
        set(handles.Label_checker,'selectedobject',handles.radiobutton2); % Disgust
    case 3
        set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Fear
    case 4
        set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Happy
    case 5
        set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Sadness
    case 6
        set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Surprise
    case 7
        set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Neutral
end

switch set_content
    case 1
        set(handles.Set_checker,'selectedobject',handles.radiobutton9); % Training
    case 3
        set(handles.Set_checker,'selectedobject',handles.radiobutton8); % Validation
end



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
% Clear the variables
clearstr = 'clear all';
evalin('base',clearstr);
% Delete the figure
delete(handles.figure1);
%quit; % only for make exe file for quit program

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdbc = evalin('base', 'imdbc');
save_folder = 'imdbc.mat';
[file,path] = uiputfile(save_folder,'Save file name');
save_path = fullfile([path file]);
save(save_path,'imdbc');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdbc = [];
assignin('base','imdbc',imdbc);
imdb_length = 0;
set(handles.imdb_length, 'string', imdb_length);
set(handles.IMDB_Index, 'string', imdb_length);
assignin('base','imdb_length',imdb_length);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TestNumber = str2double(get(handles.IMDB_Index, 'string'));
TestNumber = TestNumber-1;
if TestNumber <= 0
    TestNumber = 1;
    msgbox('Can not go previous!', 'Error','Error');
else
    %--------------------Check the Radio Button------------------------%
    imdbc = evalin('base', 'imdbc');
    img = imdbc.images.data(:,:,:,TestNumber);
    axes(handles.axes1);
    imshow(img);
    assignin('base','img',img);

    label_content = imdbc.images.labels(1,TestNumber);
    set_content = imdbc.images.set(1,TestNumber);

    switch label_content
        case 1
            set(handles.Label_checker,'selectedobject',handles.radiobutton1); % Angry
        case 2
            set(handles.Label_checker,'selectedobject',handles.radiobutton2); % Disgust
        case 3
            set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Fear
        case 4
            set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Happy
        case 5
            set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Sadness
        case 6
            set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Surprise
        case 7
            set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Neutral
    end

    switch set_content
        case 1
            set(handles.Set_checker,'selectedobject',handles.radiobutton9); % Training
        case 3
            set(handles.Set_checker,'selectedobject',handles.radiobutton8); % Validation
    end    
end
set(handles.IMDB_Index, 'string', TestNumber);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TestNumber = str2double(get(handles.IMDB_Index, 'string'));
IMDB_length = str2double(get(handles.imdb_length, 'string'));
TestNumber = TestNumber+1;
if TestNumber > IMDB_length
    TestNumber = IMDB_length;
    msgbox('Can not go next!', 'Error','Error');
else
    %--------------------Check the Radio Button------------------------%
    imdbc = evalin('base', 'imdbc');
    img = imdbc.images.data(:,:,:,TestNumber);
    axes(handles.axes1);
    imshow(img);
    assignin('base','img',img);

    label_content = imdbc.images.labels(1,TestNumber);
    set_content = imdbc.images.set(1,TestNumber);

    switch label_content
        case 1
            set(handles.Label_checker,'selectedobject',handles.radiobutton1); % Angry
        case 2
            set(handles.Label_checker,'selectedobject',handles.radiobutton2); % Disgust
        case 3
            set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Fear
        case 4
            set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Happy
        case 5
            set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Sadness
        case 6
            set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Surprise
        case 7
            set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Neutral
    end

    switch set_content
        case 1
            set(handles.Set_checker,'selectedobject',handles.radiobutton9); % Training
        case 3
            set(handles.Set_checker,'selectedobject',handles.radiobutton8); % Validation
    end
end
set(handles.IMDB_Index, 'string', TestNumber);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img_crop = evalin('base', 'img');

%선택된 라디오랑 바구는 것
checker_radio_label = get(handles.Label_checker,'SelectedObject');
checker_content_label = get(checker_radio_label,'String');

checker_radio_set = get(handles.Set_checker,'SelectedObject');
checker_content_set = get(checker_radio_set,'String');

switch checker_content_label
       case 'Angry'
           label_val = 1;
       case 'Disgust'
           label_val = 2;
       case 'Fear'
           label_val = 3;
       case 'Happy'
           label_val = 4;
       case 'Sadness'
           label_val = 5;
       case 'Surprise'
           label_val = 6;
       case 'Neutral'
           label_val = 7;
end

switch checker_content_set
       case 'Training'
           set_val = 1;
       case 'Validation'
           set_val = 3;
end

imdb_length = evalin('base', 'imdb_length');

if imdb_length == 0    

else
   imdbc = evalin('base', 'imdbc');   
   [w,h,d,imdb_length] = size(imdbc.images.data);    
   img_crop = imresize(img_crop, [w,h]);   
end

imdb_index = str2double(get(handles.IMDB_Index, 'string'));

imdbc.images.data(:,:,:,imdb_index) = img_crop;
imdbc.images.labels(1,imdb_index) = label_val; 
imdbc.images.set(1,imdb_index) = set_val;

assignin('base','imdbc',imdbc);
