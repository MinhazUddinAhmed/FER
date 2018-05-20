function varargout = GUI_Facial_Expression_AUTO_Collector_For_Easy(varargin)
% GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR MATLAB code for GUI_Facial_Expression_AUTO_Collector.fig
%      GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR, by itself, creates a new GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR or raises the existing
%      singleton*.
%
%      H = GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR returns the handle to a new GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR or the handle to
%      the existing singleton*.
%
%      GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR.M with the given input arguments.
%
%      GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR('Property','Value',...) creates a new GUI_FACIAL_EXPRESSION_AUTO_COLLECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Facial_Expression_AUTO_Collector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Facial_Expression_AUTO_Collector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Facial_Expression_AUTO_Collector

% Last Modified by GUIDE v2.5 18-Jan-2017 12:57:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Facial_Expression_AUTO_Collector_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Facial_Expression_AUTO_Collector_OutputFcn, ...
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


% --- Executes just before GUI_Facial_Expression_AUTO_Collector is made visible.
function GUI_Facial_Expression_AUTO_Collector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Facial_Expression_AUTO_Collector (see VARARGIN)

% Choose default command line output for GUI_Facial_Expression_AUTO_Collector
handles.output = hObject;

axes(handles.axes1);
global vid;
vid = webcam();
hImage = image(zeros(640,480,3),'Parent', handles.axes1);
preview(vid, hImage);

imdb_length = 0;
assignin('base','imdb_length',imdb_length);
set(handles.imdb_length, 'string', imdb_length);


img_sample = imread('Sample Image.png');
axes(handles.axes2);
imshow(img_sample);
axes(handles.axes3);
imshow(img_sample);

set(handles.Set_checker,'selectedobject',handles.radiobutton1); % Training
set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Angry
set(handles.Push_Checker,'selectedobject',handles.radiobutton11); % Add

run ../../matlab/vl_setupnn
msgbox('Finish Matconvnet Setup!', 'Notice','Help');

% Update handles structure
guidata(hObject, handles);

%--------------------------------------------Embedded Function-----------------------------------------------------%
function [ img_crop ] = embedded_Image_Cropping_Func( img, C1, C2 )
% Generate cropping box
ito_distance = sqrt((C1(1,1) - C2(1,1))^2 + (C1(1,2) - C2(1,2))^2); % calculate interocular distance
inter_point = [(C1(1,1) + C2(1,1))/2, (C1(1,2) + C2(1,2))/2];
x = inter_point(1,1)-1.6*ito_distance/2;
y = inter_point(1,2)-1.3*ito_distance/2;
w = 3.0*ito_distance/2;
h = 4.5*ito_distance/2;
bbox_crop = [ x y w h ];
img_crop = imcrop(img, bbox_crop); % crop or loose


% UIWAIT makes GUI_Facial_Expression_AUTO_Collector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Facial_Expression_AUTO_Collector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Gathering.
function Gathering_Callback(hObject, eventdata, handles)
% hObject    handle to Gathering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
img = snapshot(vid);
axes(handles.axes2);
assignin('base','img',img);
%assignin('base','img_crop',img);
imshow(img);

% ----------MTCNN Face Detector----------
%minimum size of face
minsize=20;

%path of toolbox
caffe_path='./';
pdollar_toolbox_path='./external/toolbox-master'
caffe_model_path='./model'
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

%use cpu
%caffe.set_mode_cpu();
caffe_('set_mode_cpu');

%gpu_id=0;
%caffe.set_mode_gpu();	
%caffe.set_device(gpu_id);

%three steps's threshold
threshold=[0.6 0.7 0.7]

%scale factor
factor=0.709;

%load caffe models
prototxt_dir =strcat(caffe_model_path,'/det1.prototxt');
model_dir = strcat(caffe_model_path,'/det1.caffemodel');
PNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det2.prototxt');
model_dir = strcat(caffe_model_path,'/det2.caffemodel');
RNet=caffe.Net(prototxt_dir,model_dir,'test');	
prototxt_dir = strcat(caffe_model_path,'/det3.prototxt');
model_dir = strcat(caffe_model_path,'/det3.caffemodel');
ONet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir =  strcat(caffe_model_path,'/det4.prototxt');
model_dir =  strcat(caffe_model_path,'/det4.caffemodel');
LNet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);	
img = evalin('base', 'img');

%we recommend you to set minsize as x * short side
%minl=min([size(img,1) size(img,2)]);
%minsize=fix(minl*0.1)

tic
[boudingboxes]=detect_face(img,minsize,PNet,RNet,ONet,LNet,threshold,false,factor);
toc

%faces{1,1}={boudingboxes};
%faces{1,2}={points'};

%show detection result
numbox=size(boudingboxes,1);
axes(handles.axes2);
imshow(img)
hold on; 

if numbox == 0
     %fprintf('Detect Failure!\n');
     [w,h,d] = size(img);
     position = [w/5 h/3];
     img = insertText(img,position,'Detect Failure','FontSize',60,'BoxColor','red','BoxOpacity',0.4,'TextColor','white');
else
    for j=1:numbox
        %plot(points(1:5,j),points(6:10,j),'g.','MarkerSize',10);
        r=rectangle('Position',[boudingboxes(j,1:2) boudingboxes(j,3:4)-boudingboxes(j,1:2)],'Edgecolor','g','LineWidth',3);        
        %x = points(1:2,j);
        %y = points(6:7,j);
    end
    hold off;     
end

% assignin('base','x',x);
% assignin('base','y',y);

% ----------Crop point----------
% img = evalin('base', 'img_crop');
% x = evalin('base', 'x');
% y = evalin('base', 'y');
%c1 = [x(1,1), y(1,1)];
%c2 = [x(2,1), y(2,1)];
% Image Pre-Processing
%img_crop = embedded_Image_Cropping_Func(img,c1,c2);
% assignin('base','img_crop',img_crop);
% axes(handles.axes3);
% imshow(img_crop);

% ----------Intensity Normalization----------
% img = evalin('base', 'img_crop');
% x = evalin('base', 'x');
% y = evalin('base', 'y');
% c1 = [x(1,1), y(1,1)];
% c2 = [x(2,1), y(2,1)];

if size(img_crop,3) > 1
    img_crop = rgb2gray(img_crop);
end

% Image Pre-Processing
img_crop = imadjust(img_crop);
assignin('base','img_crop',img_crop);
axes(handles.axes3);
imshow(img_crop);

% ----------Facial Expression----------
net = evalin('base', 'net');

img_crop = single(imresize(img_crop,[227,227]));
im_ = cat(3,img_crop,img_crop,img_crop);   % ��� �̹����� �÷� �̹����� ��ó�� �籸���Ѵ�.        
        
% run the CNN
res = vl_simplenn(net, im_) ;

% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;

set(handles.score_text, 'string', bestScore);
%set(handles.label_text, 'string', best);
set(handles.Expression_Label, 'string', net.meta.classes.description{best});

assignin('base','best',best);
assignin('base','scores',scores);

switch best
    case 1
        set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Angry
    case 2
        set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Disgust
    case 3
        set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Fear
    case 4
        set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Happy
    case 5
        set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Sadness
    case 6
        set(handles.Label_checker,'selectedobject',handles.radiobutton8); % Surprise
    case 7
        set(handles.Label_checker,'selectedobject',handles.radiobutton9); % Neutral
end



% --- Executes on button press in LoadIMDB.
function LoadIMDB_Callback(hObject, eventdata, handles)
% hObject    handle to LoadIMDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.mat'},'File Selector');
filepath = strcat(pathname,filename);
load(filepath);
assignin('base','imdbc',imdbc);
imdb_length = size(imdbc.images.labels,2);
set(handles.imdb_length, 'string', imdb_length);
assignin('base','imdb_length',imdb_length);



% --- Executes on button press in EXIT.
function EXIT_Callback(hObject, eventdata, handles)
% hObject    handle to EXIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
% Clear the variables
clearstr = 'clear all';
evalin('base',clearstr);
% Delete the figure
delete(handles.figure1);
%quit; % only for make exe file for quit program



% --- Executes on button press in SaveIMDB.
function SaveIMDB_Callback(hObject, eventdata, handles)
% hObject    handle to SaveIMDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imdbc = evalin('base', 'imdbc');
save_folder = 'imdbc.mat';
% save_folder = './imdbc';
% if ~exist(save_folder, 'dir')
%     mkdir(save_folder);
% end
[file,path] = uiputfile(save_folder,'Save file name');
save_path = fullfile([path file]);
save(save_path,'imdbc');
%embeded_code = sprintf('save(''%s'', ''-struct'', ''net'');',save_option);
%eval(embeded_code);


% --- Executes on button press in LoadNetwork.
function LoadNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to LoadNetwork (see GCBO)
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
msgbox('Finish Network Loading!', 'Notice','Help');



% --- Executes on button press in ReTraining.
function ReTraining_Callback(hObject, eventdata, handles)
% hObject    handle to ReTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run CNN_Train_Demo


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ----------Push the Data----------
% best = evalin('base', 'best');
% scores = evalin('base', 'scores');
img_crop = evalin('base', 'img_crop');

%���õ� ������ �ٱ��� ��
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


if strcmp(class(imdb_length),'double') == 1
    imdb_length_num = imdb_length;
else
    imdb_length_num = str2double(imdb_length);
end

imdb_index = str2double(get(handles.IMDB_Index, 'string'));


checker_radio_push = get(handles.Push_Checker,'SelectedObject');
checker_content_push = get(checker_radio_push,'String');

switch checker_content_push
    case 'Add' % If imdb's size and current index is same add new line
        imdbc.images.data(:,:,:,imdb_length_num+1) = img_crop;
        imdbc.images.labels(1,imdb_length_num+1) = label_val; 
        imdbc.images.set(1,imdb_length_num+1) = set_val;
        imdb_length = size(imdbc.images.labels,2);
        set(handles.imdb_length, 'string', imdb_length);
        set(handles.IMDB_Index, 'string', imdb_length);
    case 'Overwrite' % But those two value is different, overwrite the current data
        imdbc.images.data(:,:,:,imdb_index) = img_crop;
        imdbc.images.labels(1,imdb_index) = label_val; 
        imdbc.images.set(1,imdb_index) = set_val;
        imdb_length = size(imdbc.images.labels,2);
        set(handles.imdb_length, 'string', imdb_length);
end

assignin('base','imdb_length',imdb_length);
assignin('base','imdbc',imdbc);
assignin('base','img_crop_resize',img_crop);

axes(handles.axes3);
imshow(img_crop);



function label_text_Callback(hObject, eventdata, handles)
% hObject    handle to label_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of label_text as text
%        str2double(get(hObject,'String')) returns contents of label_text as a double


% --- Executes during object creation, after setting all properties.
function label_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to label_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function set_text_Callback(hObject, eventdata, handles)
% hObject    handle to set_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_text as text
%        str2double(get(hObject,'String')) returns contents of set_text as a double


% --- Executes during object creation, after setting all properties.
function set_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_text (see GCBO)
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
%imdbc = evalin('base', 'imdbc');   
imdbc = [];
assignin('base','imdbc',imdbc);
imdb_length = 0;
set(handles.imdb_length, 'string', imdb_length);
set(handles.IMDB_Index, 'string', imdb_length);
assignin('base','imdb_length',imdb_length);
%set(handles.label_text, 'string', 1);
%set(handles.set_text, 'string', 1);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run GUI_IMDB_Combiner


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
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
    axes(handles.axes3);
    imshow(img);
    assignin('base','img',img);

    label_content = imdbc.images.labels(1,TestNumber);
    set_content = imdbc.images.set(1,TestNumber);

    switch label_content
        case 1
            set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Angry
        case 2
            set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Disgust
        case 3
            set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Fear
        case 4
            set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Happy
        case 5
            set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Sadness
        case 6
            set(handles.Label_checker,'selectedobject',handles.radiobutton8); % Surprise
        case 7
            set(handles.Label_checker,'selectedobject',handles.radiobutton9); % Neutral
    end

    switch set_content
        case 1
            set(handles.Set_checker,'selectedobject',handles.radiobutton1); % Training
        case 3
            set(handles.Set_checker,'selectedobject',handles.radiobutton2); % Validation
    end    
end
set(handles.IMDB_Index, 'string', TestNumber);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
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
    axes(handles.axes3);
    imshow(img);
    assignin('base','img',img);

    label_content = imdbc.images.labels(1,TestNumber);
    set_content = imdbc.images.set(1,TestNumber);

    switch label_content
        case 1
            set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Angry
        case 2
            set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Disgust
        case 3
            set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Fear
        case 4
            set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Happy
        case 5
            set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Sadness
        case 6
            set(handles.Label_checker,'selectedobject',handles.radiobutton8); % Surprise
        case 7
            set(handles.Label_checker,'selectedobject',handles.radiobutton9); % Neutral
    end

    switch set_content
        case 1
            set(handles.Set_checker,'selectedobject',handles.radiobutton1); % Training
        case 3
            set(handles.Set_checker,'selectedobject',handles.radiobutton2); % Validation
    end
end
set(handles.IMDB_Index, 'string', TestNumber);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
img = snapshot(vid);
axes(handles.axes2);
% assignin('base','img',img);
% assignin('base','img_crop',img);
imshow(img);

[x, y] = ginput;
assignin('base','x',x);
assignin('base','y',y);
axes(handles.axes2);
hold on
plot(x(1,1),y(1,1),'o', 'markeredgecolor', 'r', 'LineWidth',2)
plot(x(2,1),y(2,1),'o', 'markeredgecolor', 'g', 'LineWidth',2)
hold off

% img = evalin('base', 'img_crop');
% x = evalin('base', 'x');
% y = evalin('base', 'y');
c1 = [x(1,1), y(1,1)];
c2 = [x(2,1), y(2,1)];
% Image Pre-Processing
img_crop = embedded_Image_Cropping_Func(img,c1,c2);
% assignin('base','img_crop',img_crop);
% axes(handles.axes3);
% imshow(img_crop);

% img = evalin('base', 'img_crop');
% x = evalin('base', 'x');
% y = evalin('base', 'y');
% c1 = [x(1,1), y(1,1)];
% c2 = [x(2,1), y(2,1)];

if size(img_crop,3) > 1
    img_crop = rgb2gray(img_crop);
end

% Image Pre-Processing
img_adjust = imadjust(img_crop);
assignin('base','img_crop',img_adjust);
axes(handles.axes3);
imshow(img_adjust);

% ----------Facial Expression----------
net = evalin('base', 'net');

img_crop = single(imresize(img_crop,[227,227]));
im_ = cat(3,img_crop,img_crop,img_crop);   % ��� �̹����� �÷� �̹����� ��ó�� �籸���Ѵ�.        
        
% run the CNN
res = vl_simplenn(net, im_) ;

% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;

set(handles.score_text, 'string', bestScore);
%set(handles.label_text, 'string', best);
set(handles.Expression_Label, 'string', net.meta.classes.description{best});

assignin('base','best',best);
assignin('base','scores',scores);

switch best
    case 1
        set(handles.Label_checker,'selectedobject',handles.radiobutton3); % Angry
    case 2
        set(handles.Label_checker,'selectedobject',handles.radiobutton4); % Disgust
    case 3
        set(handles.Label_checker,'selectedobject',handles.radiobutton5); % Fear
    case 4
        set(handles.Label_checker,'selectedobject',handles.radiobutton6); % Happy
    case 5
        set(handles.Label_checker,'selectedobject',handles.radiobutton7); % Sadness
    case 6
        set(handles.Label_checker,'selectedobject',handles.radiobutton8); % Surprise
    case 7
        set(handles.Label_checker,'selectedobject',handles.radiobutton9); % Neutral
end
