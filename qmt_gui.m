function varargout = qmt_gui(varargin)
% QMT_GUI MATLAB code for qmt_gui.fig
%      QMT_GUI, by itself, creates a new QMT_GUI or raises the existing
%      singleton*.
%
%      H = QMT_GUI returns the handle to a new QMT_GUI or the handle to
%      the existing singleton*.
%
%      QMT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QMT_GUI.M with the given input arguments.
%
%      QMT_GUI('Property','Value',...) creates a new QMT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qmt_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qmt_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qmt_gui

% Last Modified by GUIDE v2.5 23-Nov-2013 15:48:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qmt_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @qmt_gui_OutputFcn, ...
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


% --- Executes just before qmt_gui is made visible.
function qmt_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qmt_gui (see VARARGIN)

% Choose default command line output for qmt_gui
handles.output = hObject;



% Y-Y
% addpath('/home/yeiq36/Dropbox/qmt_clean/');
% Y-Y
% Update handles structure
MNI_logo = imread('logos/mni_logo.jpg');
axes(handles.logo_axes);
set(handles.logo_axes,'Position',[3 39.6923 10 10]);
imshow(MNI_logo);
McGill_logo = imread('logos/mcgill-logo.png');
axes(handles.logo_axes2);
set(handles.logo_axes2,'Position',[13.5 39.6923 10 10]);
imshow(McGill_logo);
guidata(hObject, handles);

% UIWAIT makes qmt_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = qmt_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function studyID_field_Callback(hObject, eventdata, handles)
% hObject    handle to studyID_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of studyID_field as text
%        str2double(get(hObject,'String')) returns contents of studyID_field as a double


% --- Executes during object creation, after setting all properties.
function studyID_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studyID_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function work_folder_field_Callback(hObject, eventdata, handles)
% hObject    handle to work_folder_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of work_folder_field as text
%        str2double(get(hObject,'String')) returns contents of work_folder_field as a double


% --- Executes during object creation, after setting all properties.
function work_folder_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to work_folder_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in work_folder_button.
function work_folder_button_Callback(hObject, eventdata, handles)
% hObject    handle to work_folder_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% YG
workdir = uigetdir;
if ischar(workdir)
    set(handles.work_folder_field,'String', cat(2,workdir, '/'));
    set(handles.mask_field,'String', cat(2,workdir, '/masks/mask.mnc'));
    set(handles.B0_field,'String', cat(2,workdir, '/b0/b0.mnc'));
    set(handles.B1_field,'String', cat(2,workdir, '/b1/b1.mnc'));
    set(handles.T1_field,'String', cat(2,workdir, '/t1/t1.mnc'));
    set(handles.dR1_field,'String', cat(2,workdir, '/dr1/dr1.mnc'));
    set(handles.label_field,'String', cat(2,workdir, '/masks/label.mnc'));
end
guidata(hObject, handles);
%Y-Y


function mask_field_Callback(hObject, eventdata, handles)
% hObject    handle to mask_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mask_field as text
%        str2double(get(hObject,'String')) returns contents of mask_field as a double


% --- Executes during object creation, after setting all properties.
function mask_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mask_button.
function mask_button_Callback(hObject, eventdata, handles)
% hObject    handle to mask_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
[filename filepath] = uigetfile([get(handles.work_folder_field,'String') '*.*']);
if ischar(filename)
    set(handles.mask_field,'String',fullfile(filepath,filename));
end
guidata(hObject, handles);
%Y-Y


function B0_field_Callback(hObject, eventdata, handles)
% hObject    handle to B0_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B0_field as text
%        str2double(get(hObject,'String')) returns contents of B0_field as a double


% --- Executes during object creation, after setting all properties.
function B0_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B0_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in B0_button.
function B0_button_Callback(hObject, eventdata, handles)
% hObject    handle to B0_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Y-Y
[filename filepath] = uigetfile([get(handles.work_folder_field,'String') '*.*']);
if ischar(filename)
    set(handles.B0_field,'String',fullfile(filepath,filename));
end
guidata(hObject, handles);
%Y-Y


function B1_field_Callback(hObject, eventdata, handles)
% hObject    handle to B1_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B1_field as text
%        str2double(get(hObject,'String')) returns contents of B1_field as a double


% --- Executes during object creation, after setting all properties.
function B1_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B1_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in B1_button.
function B1_button_Callback(hObject, eventdata, handles)
% hObject    handle to B1_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
[filename filepath] = uigetfile([get(handles.work_folder_field,'String') '*.*']);
if ischar(filename)
    set(handles.B1_field,'String',fullfile(filepath,filename));
end
guidata(hObject, handles);
%Y-Y

function T1_field_Callback(hObject, eventdata, handles)
% hObject    handle to T1_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T1_field as text
%        str2double(get(hObject,'String')) returns contents of T1_field as a double


% --- Executes during object creation, after setting all properties.
function T1_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T1_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in T1_button.
function T1_button_Callback(hObject, eventdata, handles)
% hObject    handle to T1_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
[filename filepath] = uigetfile([get(handles.work_folder_field,'String') '*.*']);
if ischar(filename)
    set(handles.T1_field,'String',fullfile(filepath,filename));
end
guidata(hObject, handles);
%Y-Y

function dR1_field_Callback(hObject, eventdata, handles)
% hObject    handle to dR1_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dR1_field as text
%        str2double(get(hObject,'String')) returns contents of dR1_field as a double


% --- Executes during object creation, after setting all properties.
function dR1_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dR1_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dR1_button.
function dR1_button_Callback(hObject, eventdata, handles)
% hObject    handle to dR1_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
[filename filepath] = uigetfile([get(handles.work_folder_field,'String') '*.*']);
if ischar(filename)
    set(handles.dR1_field,'String',fullfile(filepath,filename));
end
guidata(hObject, handles);
%Y-Y

function label_field_Callback(hObject, eventdata, handles)
% hObject    handle to label_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of label_field as text
%        str2double(get(hObject,'String')) returns contents of label_field as a double


% --- Executes during object creation, after setting all properties.
function label_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to label_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in label_button.
function label_button_Callback(hObject, eventdata, handles)
% hObject    handle to label_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
[filename filepath] = uigetfile([get(handles.work_folder_field,'String') '*.*']);
if ischar(filename)
    set(handles.label_field,'String',fullfile(filepath,filename));
end
guidata(hObject, handles);
%Y-Y

% --- Executes on button press in maskDisp_button.
function maskDisp_button_Callback(hObject, eventdata, handles)
% hObject    handle to maskDisp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Y-Y
axes(handles.display_axes);
mincDisplayImage(get(handles.mask_field,'String'));
guidata(hObject, handles);
%Y-Y


% --- Executes on button press in B0disp_button.
function B0disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to B0disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
axes(handles.display_axes);
mincDisplayImage(get(handles.B0_field,'String'),get(handles.mask_field,'String'));
guidata(hObject, handles);
%Y-Y

% --- Executes on button press in B1disp_button.
function B1disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to B1disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
axes(handles.display_axes);
mincDisplayImage(get(handles.B1_field,'String'),get(handles.mask_field,'String'));
guidata(hObject, handles);
%Y-Y

% --- Executes on button press in T1disp_button.
function T1disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to T1disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
axes(handles.display_axes);
mincDisplayImage(get(handles.T1_field,'String'),get(handles.mask_field,'String'));
guidata(hObject, handles);
%Y-Y

% --- Executes on button press in dR1disp_button.
function dR1disp_button_Callback(hObject, eventdata, handles)
% hObject    handle to dR1disp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
axes(handles.display_axes);
mincDisplayImage(get(handles.dR1_field,'String'),get(handles.mask_field,'String'));
guidata(hObject, handles);
%Y-Y

% --- Executes on button press in ROIdisp_button.
function ROIdisp_button_Callback(hObject, eventdata, handles)
% hObject    handle to ROIdisp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
axes(handles.display_axes);
mincDisplayImage(get(handles.label_field,'String'),get(handles.mask_field,'String'));
guidata(hObject, handles);
%Y-Y



% --- Executes on button press in qmt_button.
function qmt_button_Callback(hObject, eventdata, handles)
% hObject    handle to qmt_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
study = qmt_off_data(get(handles.work_folder_field,'String'));
set(hObject,'UserData',study);
guidata(hObject, handles);
%Y-Y



% --- Executes on button press in BIC_checkbox.
function BIC_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BIC_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BIC_checkbox

% Y-Y

% *******************************************************************
% take this part off when completing part for customized sequencs
% *******************************************************************
if get(hObject,'Value') == get(hObject,'Min')
    uiwait(warndlg('Only support BIC standard sequence for the moment'));
    set(hObject,'Value',get(hObject,'Max'));
end
% *******************************************************************
if get(hObject,'Value') == get(hObject,'Max')
    set(handles.seqMenu,'Enable','On');
else
    set(handles.seqMenu,'Enable','Off');
end
guidata(hObject, handles);
%Y-Y


% --- Executes on selection change in seqMenu.
function seqMenu_Callback(hObject, eventdata, handles)
% hObject    handle to seqMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqMenu


% --- Executes during object creation, after setting all properties.
function seqMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function norm_scale_bar_Callback(hObject, eventdata, handles)
% hObject    handle to norm_scale_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Y-Y
% Sync the values of slider and box
temp=get(hObject,'Value');
set(handles.norm_scale_field,'String',num2str(temp));
guidata(hObject, handles);
%Y-Y

% --- Executes during object creation, after setting all properties.
function norm_scale_bar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to norm_scale_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function norm_scale_field_Callback(hObject, eventdata, handles)
% hObject    handle to norm_scale_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of norm_scale_field as text
%        str2double(get(hObject,'String')) returns contents of norm_scale_field as a double

%Y-Y
% Sync the values of slider and box
temp1=min(str2double(get(hObject,'String')),get(handles.norm_scale_bar,'Max'));
temp2=max(temp1,get(handles.norm_scale_bar,'Min'));
set(handles.norm_scale_bar,'Value',(temp2));
set(handles.norm_scale_field,'String',num2str(temp2));
guidata(hObject, handles);
%Y-Y

% --- Executes during object creation, after setting all properties.
function norm_scale_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to norm_scale_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function B0_shift_bar_Callback(hObject, eventdata, handles)
% hObject    handle to B0_shift_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Y-Y
% Sync the values of slider and box
temp=get(hObject,'Value');
set(handles.B0_shift_field,'String',num2str(temp));
guidata(hObject, handles);
%Y-Y


% --- Executes during object creation, after setting all properties.
function B0_shift_bar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B0_shift_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function B0_shift_field_Callback(hObject, eventdata, handles)
% hObject    handle to B0_shift_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B0_shift_field as text
%        str2double(get(hObject,'String')) returns contents of B0_shift_field as a double


%Y-Y
% Sync the values of slider and box
temp1=min(str2double(get(hObject,'String')),get(handles.B0_shift_bar,'Max'));
temp2=max(temp1,get(handles.B0_shift_bar,'Min'));
set(handles.B0_shift_bar,'Value',(temp2));
set(handles.B0_shift_field,'String',num2str(temp2));
guidata(hObject, handles);
%Y-Y

% --- Executes during object creation, after setting all properties.
function B0_shift_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B0_shift_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function B1_scale_bar_Callback(hObject, eventdata, handles)
% hObject    handle to B1_scale_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Y-Y
% Sync the values of slider and box
temp=get(hObject,'Value');
set(handles.B1_scale_field,'String',num2str(temp));
guidata(hObject, handles);
%Y-Y

% --- Executes during object creation, after setting all properties.
function B1_scale_bar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B1_scale_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function B1_scale_field_Callback(hObject, eventdata, handles)
% hObject    handle to B1_scale_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B1_scale_field as text
%        str2double(get(hObject,'String')) returns contents of B1_scale_field as a double

%Y-Y
% Sync the values of slider and box
temp1=min(str2double(get(hObject,'String')),get(handles.B1_scale_bar,'Max'));
temp2=max(temp1,get(handles.B1_scale_bar,'Min'));
set(handles.B1_scale_bar,'Value',(temp2));
set(handles.B1_scale_field,'String',num2str(temp2));
guidata(hObject, handles);
%Y-Y

% --- Executes during object creation, after setting all properties.
function B1_scale_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B1_scale_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prepare_button.
function prepare_button_Callback(hObject, eventdata, handles)
% hObject    handle to prepare_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
subject_id = get(handles.studyID_field,'String');
workdir = get(handles.work_folder_field,'String');
study = get(handles.qmt_button,'UserData');
sequenceID = get(handles.seqMenu,'Value');

switch sequenceID
    case 1
        study{1}.sequence = 'qmtspgr_opt';
        study{2}.sequence = 'qmtspgr2_opt';
    case 2
        study{1}.sequence = 'qmtspgr_opt_3t';
        study{2}.sequence = 'qmtspgr2_opt_3t';
    case 3
        study{1}.sequence = 'qmtspgr_uk';
        study{1}.files = study{1}.files([1,3,5,7,9,2,4,6,8,10]);       
    case 4
        study{1}.sequence = 'qmtspgr_uk_3t';
        study{1}.files = study{1}.files([1,3,5,7,9,2,4,6,8,10]); 
    otherwise
        warning('Unknown sequence');
end
for ii = 1:length(study)
  baseline{ii} = study{ii}.baseline;
  study{ii} = rmfield(study{ii},'baseline');
  if ~isempty(study{ii})
    study{ii} = get_study_info(workdir, study{ii});
  else
    warning(sprintf('Study %d is empty.',ii))
  end
  comp{ii} = collect_mt_studies(study, [ii]);
  normScale(ii) = get(handles.norm_scale_bar,'Value');
  comp{ii}.normalization_scale = ones(1,length(comp{ii}.files))*normScale(ii);
  comp{ii}.dir = workdir;
  comp{ii}.mask = get(handles.mask_field,'String');
  comp{ii}.b0_file = get(handles.B0_field,'String');
  if(fopen(comp{ii}.b0_file) == -1)
      comp{ii}=rmfield(comp{ii},'b0_file');
  end
  comp{ii}.b0_shift = ones(1,length(comp{ii}.nominal_angles))*get(handles.B0_shift_bar,'Value');
  comp{ii}.b1_file = get(handles.B1_field,'String');
  if(fopen(comp{ii}.b1_file) == -1)
      comp{ii}=rmfield(comp{ii},'b1_file');
  end
  comp{ii}.b1_scale = ones(1,length(comp{ii}.nominal_angles))*get(handles.B1_scale_bar,'Value');
  comp{ii}.t1_file = get(handles.T1_field,'String');
  comp{ii}.dr1_file = get(handles.dR1_field,'String');
  if(fopen(comp{ii}.dr1_file) == -1)
      comp{ii}=rmfield(comp{ii},'dr1_file');   
  end
  for jj = 1:length(comp{ii}.files)
      comp{ii}.baseline{jj} = char(baseline{ii});
  end
end
study = combine_studies(comp);

%-- Read in MT data and  normalize
data = read_study_data(study);

  
if(~isfield(study,'b0_file'))
  uiwait(warndlg(sprintf('BO file does not exist, using 0 for everything \nPress "Enter" to continue')));
  pause;  
  data.b0 = zeros(size(data.R1obs));
end
if(~isfield(study,'b1_file'))
  uiwait(warndlg(sprintf('B1 file does not exist, using 1 for everything \nPress "Enter" to continue')));
  pause;  
  data.b1 = ones(size(data.R1obs));
end
if(~isfield(study,'dr1_file'))
  uiwait(warndlg(sprintf('dR1 file does not exist, using 0 for everything \nPress "Enter" to continue')));
  pause;
  data.dR1obs = ones(size(data.R1obs));
end


data = normalize_mt_data(study, data);




%-- Read in labels to be used for ROI inspection of data
h = openimage(get(handles.label_field,'String'));
tmp = miinquire(get(handles.label_field,'String'),'imagesize');
n_slices = tmp(2);
lbl = getimages(h,1:n_slices);
closeimage(h);
lbl = lbl(data.mask);

%-- Average data over ROI
rdata = average_mt_data(study, data, lbl);

label = {'roi'};



%-- Plot data by ROI
% axis(handles.display_axes);
% hold on
% for ii = 1:length(label)
%     for jj = 1:length(study.nominal_offsets)
%         semilogx(study.nominal_offsets{jj}, rdata.measurements{jj}(ii,:)', '.--b');
%     end
%     xlabel('frequency offset (Hz)');
%     ylabel('MTw signal');
%     title(label{ii});
%     set(gca,'XScale','log');
% end


%-- Change sign of B0 data
rdata.b0 = -rdata.b0;
data.b0 = -data.b0;
study.b0_shift = -study.b0_shift;


[fit, cache, lineshape] = mt_img(study,rdata,[],'mtspgr_rp2','mapping_4d','superlrtz_line',[study.dir 'roi_fit.mat']);
save([workdir 'preparedData.mat'],'study','data');

axes(handles.display_axes);
for ii = 1:length(label)
    show_fit(study,fit,rdata,cache,lineshape,ii,logspace(2,5));
    title(cat(2,label{ii},' fit'));
end

sd.study = study;
sd.data = data;
set(hObject,'UserData',sd);

guidata(hObject, handles);
%Y-Y


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_study_Callback(hObject, eventdata, handles)
% hObject    handle to save_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
s.ID = get(handles.studyID_field,'String');
s.Dir = get(handles.work_folder_field,'String');
s.qMT = get(handles.qmt_button,'UserData');
s.sequence = get(handles.seqMenu,'Value');
s.normScale = get(handles.norm_scale_bar,'Value');
s.mask = get(handles.mask_field,'String');
s.b0_file = get(handles.B0_field,'String');
s.b0_shift = get(handles.B0_shift_bar,'Value');
s.b1_file = get(handles.B1_field,'String');
s.b1_scale = get(handles.B1_scale_bar,'Value');
s.t1_file = get(handles.T1_field,'String');
s.dr1_file = get(handles.dR1_field,'String');
s.roi = get(handles.label_field,'String');

uisave('s');

guidata(hObject, handles);
%Y-Y


% --------------------------------------------------------------------
function loadStudy_Callback(hObject, eventdata, handles)
% hObject    handle to loadStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Y-Y
uiload;
set(handles.studyID_field,'String', s.ID);
set(handles.work_folder_field,'String', s.Dir);
set(handles.qmt_button,'UserData', s.qMT);
set(handles.seqMenu,'Value', s.sequence);
set(handles.norm_scale_bar,'Value', s.normScale);
set(handles.norm_scale_field,'String', s.normScale);
set(handles.mask_field,'String', s.mask);
set(handles.B0_field,'String', s.b0_file);
set(handles.B0_shift_bar,'Value', s.b0_shift);
set(handles.B0_shift_field,'String',s.b0_shift);
set(handles.B1_field,'String', s.b1_file);
set(handles.B1_scale_bar,'Value', s.b1_scale);
set(handles.B1_scale_field,'String', s.b1_scale);
set(handles.T1_field,'String', s.t1_file);
set(handles.dR1_field,'String', s.dr1_file);
set(handles.label_field,'String', s.roi);
guidata(hObject, handles);
%Y-Y


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load([get(handles.work_folder_field,'String') 'preparedData.mat']);

if exist([study.dir '/' get(handles.studyID_field,'String') '_f.mnc'])==2
    ppp = cell2mat(inputdlg(['Parameter files with prefix <' get(handles.studyID_field,'String') '> exist, please enter a new prefix:'],'Prefix'));
    fullprefix = [study.dir '/' ppp];
else
    fullprefix = [study.dir '/' get(handles.studyID_field,'String')];
end

[fit, cache, lineshape] = mt_img(study,data,[],'mtspgr_rp2','mapping_4d','superlrtz_line',[study.dir 'fittedData.mat']);
make_fit_mnc(data, fit, fullprefix ,[study.mask]);
guidata(hObject, handles);
