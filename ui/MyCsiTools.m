function varargout = MyCsiTools(varargin)
% MYCSITOOLS MATLAB code for MyCsiTools.fig
%      MYCSITOOLS, by itself, creates a new MYCSITOOLS or raises the existing
%      singleton*.
%
%      H = MYCSITOOLS returns the handle to a new MYCSITOOLS or the handle to
%      the existing singleton*.
%
%      MYCSITOOLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCSITOOLS.M with the given input arguments.
%
%      MYCSITOOLS('Property','Value',...) creates a new MYCSITOOLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MyCsiTools_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MyCsiTools_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MyCsiTools

% Last Modified by GUIDE v2.5 30-Oct-2020 11:31:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyCsiTools_OpeningFcn, ...
                   'gui_OutputFcn',  @MyCsiTools_OutputFcn, ...
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


% --- Executes just before MyCsiTools is made visible.
function MyCsiTools_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MyCsiTools (see VARARGIN)

% Choose default command line output for MyCsiTools
handles.output = hObject;
global fileNameList
global RootPath
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyCsiTools wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MyCsiTools_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in l_fileBox.
function l_fileBox_Callback(hObject, eventdata, handles)
% hObject    handle to l_fileBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns l_fileBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from l_fileBox
    global RootPath
    global fileNameList
    global num
    fileIndex= get(handles.l_fileBox,'value');
    filename=[RootPath,'\',fileNameList{fileIndex}];%存储文件的路径及名称
    csi_trace = read_bf_file(filename);
    num=length(csi_trace)
    set(handles.t_num,'string',num)
    csi_entry = csi_trace{1}
    set(handles.t_Ntx,'string',['Ntx:',num2str(csi_entry.Ntx)])
    set(handles.t_Nrx,'string',['Nrx:',num2str(csi_entry.Nrx)])
    set(handles.t_rssi_a,'string',['rssi_a:',num2str(csi_entry.rssi_a)])
    set(handles.t_rssi_b,'string',['rssi_b:',num2str(csi_entry.rssi_b)])
    set(handles.t_rssi_c,'string',['rssi_c:',num2str(csi_entry.rssi_c)])
    set(handles.t_noise,'string',['noise:',num2str(csi_entry.noise)])
    set(handles.t_rate,'string',['rate:',num2str(csi_entry.rate)])
    set(handles.t_agc,'string',['agc:',num2str(csi_entry.agc)])
    set(handles.t_perm,'string',['perm:',num2str(csi_entry.perm)])
    antennaCountNrx=csi_entry.Nrx
    for i =1:antennaCountNrx
        antennaList{i}=['第',num2str(i),'根天线']
    end
    antennaList{i+1}=['全选']
    set(handles.p_antennaIndex,'string',antennaList)
    antennaCountNtx=csi_entry.Ntx
    set(handles.t_timestamp_low_data,'string',csi_entry.timestamp_low)
    set(handles.t_bfee_count_data,'string',csi_entry.bfee_count)
    
    set(handles.e_low,'string',1)
    set(handles.e_high,'string',num)
    
    
     set(handles.s_low,'max',num)
     set(handles.s_low,'min',1)
    set(handles.s_high,'max',num)
     set(handles.s_high,'min',1)
    
    set(handles.s_low,'value',1)
    set(handles.s_low,'sliderstep',[1/num,1/num])
    set(handles.s_high,'value',num)
    set(handles.s_high,'sliderstep',[1/num,1/num])
    
    
% --- Executes during object creation, after setting all properties.
function l_fileBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l_fileBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function fileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global RootPath
    %选择文件夹路径
    RootPath = uigetdir
    disp(RootPath)
    DirOutput = dir(fullfile(RootPath))
    fileIndex=find(cat(1,DirOutput.isdir)<1)
    global fileNameList
    fileNameList={DirOutput(fileIndex).name}
    set(handles.l_fileBox,'string',fileNameList)
    

% --- Executes on selection change in p_antennaIndex.
function p_antennaIndex_Callback(hObject, eventdata, handles)
% hObject    handle to p_antennaIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p_antennaIndex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p_antennaIndex


% --- Executes during object creation, after setting all properties.
function p_antennaIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_antennaIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p_dataIndex.
function p_dataIndex_Callback(hObject, eventdata, handles)
% hObject    handle to p_dataIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p_dataIndex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p_dataIndex


% --- Executes during object creation, after setting all properties.
function p_dataIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_dataIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in b_readCsi.
function b_readCsi_Callback(hObject, eventdata, handles)
% hObject    handle to b_readCsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global RootPath
    global fileNameList
    fileIndex= get(handles.l_fileBox,'value');
    filename=[RootPath,'\',fileNameList{fileIndex}];%存储文件的路径及名称
    csi_trace = read_bf_file(filename);
    low=str2num(get(handles.e_low,'string'))    
    high=str2num(get(handles.e_high,'string'))
    yLow=0
    yHigh=0
    antennaChoice=get(handles.p_antennaIndex,'value')
    if antennaChoice>csi_trace{1}.Nrx
        disp('全选了')
    end
     h = waitbar(0,'Please wait...');
    for i=low:high%这里是取的数据包的个数
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry); %提取csi矩阵
        %第一个发送端
        csi_s1 =csi(1,:,:);
        %第二个接收端
        csi_s1_r1 =csi(1,antennaChoice,:);
        csi1=abs(squeeze(csi_s1_r1).');          %提取幅值(降维+转置)
        %进度显示
        waitbar(i/(high-low),h)
        %获取30个子载波数据
        for j=1:30
            subcarrier_list(j,i)=csi1(:,j);
            if yHigh<csi1(:,j) 
                yHigh=csi1(:,j)      
            end
        end    
    end
    close(h)
     %需要在GUI界面插入axes框
    axes(handles.a_csi_show);      %打开的文件显示在第一个图   
    set(gca,'XLim',[low high])
    cla    
    %画图
    for j=1:30
        x=subcarrier_list(j,:).'
        plot(x)
        hold on  
    end
    axis([low,high,yLow,yHigh])



function e_low_Callback(hObject, eventdata, handles)
% hObject    handle to e_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_low as text
%        str2double(get(hObject,'String')) returns contents of e_low as a double
    e_low_value=get(handles.e_low,'string')
    e_high_value=get(handles.e_high,'string')
    if str2num(e_low_value)<str2num(e_high_value)
        set(handles.s_low,'value',str2num(e_low_value))
    end
    



% --- Executes during object creation, after setting all properties.
function e_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_high_Callback(hObject, eventdata, handles)
% hObject    handle to e_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_high as text
%        str2double(get(hObject,'String')) returns contents of e_high as a double
    e_low_value=get(handles.e_low,'string')
    e_high_value=get(handles.e_high,'string')
    if str2num(e_low_value)<str2num(e_high_value)
        set(handles.s_high,'value',str2num(e_high_value))
    end

% --- Executes during object creation, after setting all properties.
function e_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function s_low_Callback(hObject, eventdata, handles)
% hObject    handle to s_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global num
    s_low_value=floor(get(handles.s_low,'value'))
    s_high_value=(get(handles.s_high,'value'))
    if s_low_value<s_high_value
        set(handles.e_low,'string',floor(s_low_value))
    else
        set(handles.s_low,'value',str2num(get(handles.e_low,'string')))
    end
% --- Executes during object creation, after setting all properties.
function s_low_CreateFcn(hObject, ~, handles)
% hObject    handle to s_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s_high_Callback(hObject, eventdata, handles)
% hObject    handle to s_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global num              
    s_low_value=floor(get(handles.s_low,'value'))
    s_high_value=(get(handles.s_high,'value'))
    if s_low_value<s_high_value
        set(handles.e_high,'string',floor(s_high_value))
    else
        set(handles.s_high,'value',str2num(get(handles.e_high,'string')))
    end
        
        
        
        

% --- Executes during object creation, after setting all properties.
function s_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
