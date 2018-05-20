function varargout = FC_SSL_Demo(varargin)
% FC_SSL_Demo MATLAB code for FC_SSL_Demo.fig
%      FC_SSL_Demo, by itself, creates a new FC_SSL_Demo or raises the existing
%      singleton*.
%
%      H = FC_SSL_Demo returns the handle to a new FC_SSL_Demo or the handle to
%      the existing singleton*.
%
%      FC_SSL_Demo('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FC_SSL_Demo.M with the given input arguments.
%
%      FC_SSL_Demo('Property','Value',...) creates a new FC_SSL_Demo or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FC_SSL_Demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FC_SSL_Demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FC_SSL_Demo

% Last Modified by GUIDE v2.5 25-Jan-2017 09:43:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FC_SSL_Demo_OpeningFcn, ...
                   'gui_OutputFcn',  @FC_SSL_Demo_OutputFcn, ...
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


% --- Executes just before FC_SSL_Demo is made visible.
function FC_SSL_Demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FC_SSL_Demo (see VARARGIN)

% Choose default command line output for FC_SSL_Demo
handles.output = hObject;

performance = [];
assignin('base','performance',performance);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FC_SSL_Demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FC_SSL_Demo_OutputFcn(hObject, eventdata, handles) 
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
net = load(filepath);

% net change to testing
f1 = size(net.layers,1);
f2 = size(net.layers,2);
net.layers{f1,f2}.type = 'softmax';
net.layers{f1,f2}.name = 'prob';

% change to class's description
net.meta.classes.description = {'Angry';'Disgust';'Fear';'Happy';'Sadness';'Surprise';'Neutral'};

assignin('base','net',net);
%run ../../matlab/vl_setupnn
msgbox('Finish Network Loading', 'Notice','Help');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
net = evalin('base', 'net');
performance = evalin('base', 'performance');
imdbc = evalin('base', 'imdbc');
imdb_length = evalin('base', 'imdb_length');

true_value = 0;
false_value = 0;

for i = 1:imdb_length
    img = imdbc.images.data(:,:,:,i);
    im_ = single(imresize(img,[227,227]));
    
    if size(im_,3) == 1
        im_ = cat(3,im_,im_,im_);   % here image was color, need to convert
        % convert one channel
    end

    % run the CNN
    res = vl_simplenn(net, im_) ;

    % show the classification result
    scores = squeeze(gather(res(end).x)) ;
    [bestScore, best] = max(scores) ;    

    gt_label = imdbc.images.labels(1,i);
    
    if gt_label == best
        true_value = true_value + 1;
        Score_list(2,i) = 1; % true
    else
        false_value = false_value + 1;
        Score_list(2,i) = 0; % false
    end
    Evaluated_Label_List(1,i) = best; % Evaluated Label
    Score_list(1,i) = bestScore;
end

TestNumber = str2double(get(handles.TestNumber, 'string'));


assignin('base','Score_list',Score_list);
assignin('base','Evaluated_Label_List',Evaluated_Label_List);

performance(1,TestNumber) = (true_value/(true_value+false_value))*100;
assignin('base','performance',performance);

msgbox('Finish Evaluation', 'Notice','Help');


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
assignin('base','imdb_length',imdb_length);


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



function TestNumber_Callback(hObject, eventdata, handles)
% hObject    handle to TestNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TestNumber as text
%        str2double(get(hObject,'String')) returns contents of TestNumber as a double


% --- Executes during object creation, after setting all properties.
function TestNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TestNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TestNumber = str2double(get(handles.TestNumber, 'string'));
TestNumber = TestNumber-1;
if TestNumber <= 0
    TestNumber = 1;
end
set(handles.TestNumber, 'string', TestNumber);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TestNumber = str2double(get(handles.TestNumber, 'string'));
TestNumber = TestNumber+1;
set(handles.TestNumber, 'string', TestNumber);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
performance = evalin('base', 'performance');
n = size(performance,2);
x_axis = 1:n;

axes(handles.axes1);
%bar(x_axis,performance,0.5, 'r');
plot(x_axis,performance,':r*');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IMDB_Length_number = evalin('base', 'imdb_length');

if IMDB_Length_number == 0
    msgbox('No IMDB', 'Error','error');
end

imdbc = evalin('base', 'imdbc');
save_folder = 'imdbc.mat';
[file,path] = uiputfile(save_folder,'Save file name');
save_path = fullfile([path file]);
save(save_path,'imdbc');


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdbc = evalin('base', 'imdbc');
Score_list = evalin('base', 'Score_list');
threshold = str2double(get(handles.Threshold, 'string'));
n = size(imdbc.images.labels,2);
thres_count = 1;
Negative_count = 1;

% Initialize
imdbc2 = [];
imdbc3 = [];

for i = 1:n
    if Score_list(2,i) == 1 % evaluation result is true
        if Score_list(1,i) < threshold  % Extract 
            imdbc2.images.data(:,:,:,thres_count) = imdbc.images.data(:,:,:,i);
            imdbc2.images.labels(1,thres_count) = imdbc.images.labels(1,i);
            imdbc2.images.set(1,thres_count) = imdbc.images.set(1,i);
            thres_count = thres_count + 1;
        end
    else  % Negative
        imdbc3.images.data(:,:,:,Negative_count) = imdbc.images.data(:,:,:,i);
        imdbc3.images.labels(1,Negative_count) = imdbc.images.labels(1,i);
        imdbc3.images.set(1,Negative_count) = imdbc.images.set(1,i);
        Negative_count = Negative_count + 1;
    end
end
assignin('base','imdbc',imdbc2); % Change to new extracted imdb
assignin('base','imdbc_N',imdbc3); % Change to new negative imdb
msgbox('Finish Extraction!', 'Notice','Help');


function Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Threshold as text
%        str2double(get(hObject,'String')) returns contents of Threshold as a double


% --- Executes during object creation, after setting all properties.
function Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% %Previous Function "Re-Training"
% imdb = evalin('base', 'imdbc');
% initNet = evalin('base', 'net');
% 
% opt_content  = get(handles.Option_Setting, 'string');
% embeded_code = sprintf('opts = struct(%s);',opt_content);
% eval(embeded_code);
% 
% fprintf('Training Start!\n');
% net = Matconvnet_CNN_Merge( imdb, initNet, opts );
% fprintf('Training Finish!\n');
% 
% save_folder = 'SSL';
% save_file = 'Temp_net.mat'
% save_option = fullfile([save_folder '/' save_file]);
% 
% if ~exist(save_folder, 'dir'), mkdir(save_folder) ; end
% 
% embeded_code = sprintf('save(''%s'', ''-struct'', ''net'');',save_option);
% eval(embeded_code);
% 
% fprintf('Trained Model Saved!\n');
imdbc = evalin('base', 'imdbc');
Evaluated_Label_List = evalin('base', 'Evaluated_Label_List');

n = size(imdbc.images.labels,2);

for i = 1:n
    imdbc.images.labels(1,i) = Evaluated_Label_List(1,i);
end

assignin('base','imdbc',imdbc); % Change to new evaluated imdb
msgbox('Finish to make SSL IMDB!', 'Notice','Help');


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


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdbc_N = evalin('base', 'imdbc_N');
assignin('base','imdbc',imdbc_N); % Change to new negative imdb
msgbox('Finish Extract Negative Data!', 'Notice','Help');


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run ../../matlab/vl_setupnn
msgbox('Finish Matconvnet Setup', 'Notice','Help');

