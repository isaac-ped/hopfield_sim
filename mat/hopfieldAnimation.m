function varargout = hopfieldAnimation(varargin)
% HOPFIELDANIMATION MATLAB code for hopfieldAnimation.fig
%      HOPFIELDANIMATION, by itself, creates a new HOPFIELDANIMATION or raises the existing
%      singleton*.
%
%      H = HOPFIELDANIMATION returns the handle to a new HOPFIELDANIMATION or the handle to
%      the existing singleton*.
%
%      HOPFIELDANIMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOPFIELDANIMATION.M with the given input arguments.
%
%      HOPFIELDANIMATION('Property','Value',...) creates a new HOPFIELDANIMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hopfieldAnimation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hopfieldAnimation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hopfieldAnimation

% Last Modified by GUIDE v2.5 05-Jun-2014 15:01:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hopfieldAnimation_OpeningFcn, ...
                   'gui_OutputFcn',  @hopfieldAnimation_OutputFcn, ...
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


% --- Executes just before hopfieldAnimation is made visible.
function hopfieldAnimation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hopfieldAnimation (see VARARGIN)

% Choose default command line output for hopfieldAnimation
handles.output = hObject;
handles.usableImageExtensions = {'png','jpg','jpeg'};

addpath('helper_functions')
set(handles.settings_panel,'visible','off');
if ~exist('settings.mat','file')
    settings = makeDefaultSettings();
    handles.settings = settings;
    save('settings.mat','settings');
end
messageBox_h = messageBox('Loading settings and images...');
[settings,imageLib] = loadSettings('settings.mat',handles);
handles.settings = settings;
handles.library = imageLib.library;
handles.weightMatrix = imageLib.weightMatrix;
colormap gray;
close(messageBox_h);

global running;
running = false;
global iter;
iter = 0;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes hopfieldAnimation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hopfieldAnimation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in simulation_toggle.
function simulation_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to simulation_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simulation_toggle
if get(hObject,'value')
    set(handles.settings_panel,'visible','off')
    set(handles.simulation_panel,'visible','on')
    set(handles.settings_toggle,'value',false)
else
    set(hObject,'value',true)
end
uicontrol(handles.blankText)


% --- Executes on button press in settings_toggle.
function settings_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to settings_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of settings_toggle
if get(hObject,'value')
    set(handles.settings_panel,'visible','on')
    set(handles.simulation_panel,'visible','off')
    set(handles.simulation_toggle,'value',false)
else
    set(hObject,'value',true)
end
uicontrol(handles.blankText)

% --- Executes on selection change in imageLib_lb.
function imageLib_lb_Callback(hObject, eventdata, handles)
% hObject    handle to imageLib_lb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageLib_lb contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageLib_lb
selected_index = get(hObject,'value');
set(handles.library_axes,'visible','on');
axes(handles.library_axes);
set(handles.temperature_axes,'visible','off');
cla(handles.temperature_axes);
set(handles.learningRate_axes,'visible','off');
cla(handles.learningRate_axes);
imagesc(handles.library(selected_index).image);
axis off

% --- Executes during object creation, after setting all properties.
function imageLib_lb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageLib_lb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in importImage_button.
function importImage_button_Callback(hObject, eventdata, handles)
% hObject    handle to importImage_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName, pathName] = uigetfile(fullfile(handles.settings.imageLibLoc,'*.png;*.jpg'));
if fileName==0
    return;
end
messageBox_h = messageBox(sprintf('Loading %s...',fileName));
%add a new image when this button is pressed
try
    newItem = processImage(pathName, fileName, handles.settings);
    if isstruct(newItem)
        handles.library(end+1) = newItem;
    end
    handles.weightMatrix = makeWeights(handles.library, handles)
catch e
    disp(e)
    keyboard;
end
close(messageBox_h)
fillLibraryList(handles, handles.library)
guidata(hObject, handles);

% --- Executes on button press in removeImage_button.
function removeImage_button_Callback(hObject, eventdata, handles)
% hObject    handle to removeImage_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.imageLib_lb,'value');
handles.library(index_selected) = [];
fillLibraryList(handles, handles.library);
guidata(hObject, handles);

% --- Executes on button press in imageLibLoc_button.
function imageLibLoc_button_Callback(hObject, eventdata, handles)
% hObject    handle to imageLibLoc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'settings')
    [pathName] = uigetdir(handles.settings.imageLibLoc,'Image library folder');
else 
    [pathName] = uigetdir('.','Image Library folder');
end
if isempty(pathName)
    return;
end
if exist(fullfile(pathName, 'imageLib.mat'),'file')
    imgLib = load(fullfile(pathName, 'imageLib.mat'));
    handles.library = imgLib.library;
    handles.weightMatrix = imgLib.weightMatrix;
    handles.settings.imageLibLoc = pathName;
else
    for ext_i=1:length(handles.usableImageExtensions)
        ext = handles.usableImageExtensions{ext_i};
        if ~exist('imgFiles','var')
            imgFiles = dir(fullfile(pathName,['*.' ext]));
        else
            imgFiles = [imgFiles dir(fullfile(pathName, ['*.' ext]))];
        end
    end
    if ~isempty(imgFiles)
        choice = questdlg(sprintf('imageLib.mat does not exist in that folder'),...
            'New ImageLib?','Import Images','Cancel','Cancel');
        if strcmp(choice,'Cancel')
            return
        elseif strcmp(choice, 'Import Images')
            handles.library = importFolder(pathName, handles);
            handles.settings.imageLibLoc = pathName;
            handles.weightMatrix = makeWeights(handles.library, handles);
            library = handles.library;
            weightMatrix = handles.weightMatrix;
            save(fullfile(handles.settings.imageLibLoc,'imageLib.mat'),'library','weightMatrix');
        end
            
    else
        choice = questdlg(sprintf('imageLib.mat does not exist in that folder, nor do images'),...
            'New ImageLib?','Clear imageLib','cancel','cancel');
        if strcmp(choice,'cancel')
            return
        elseif strcmp(choice,('Clear imageLib'))
            handles.library(:) = [];
            handles.settings = gatherSettings(handles);
            handles.settings.imageLibLoc = pathName;
            settings = handles.settings;
            save('./settings.mat','settings');
        end
    end
end
set(handles.imageLibLoc_edit,'string',handles.settings.imageLibLoc);
fillLibraryList(handles, handles.library);
guidata(hObject, handles);

function imageLibLoc_edit_Callback(hObject, eventdata, handles)
% hObject    handle to imageLibLoc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageLibLoc_edit as text
%        str2double(get(hObject,'String')) returns contents of imageLibLoc_edit as a double


% --- Executes during object creation, after setting all properties.
function imageLibLoc_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageLibLoc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in importFolder_button.
function importFolder_button_Callback(hObject, eventdata, handles)
% hObject    handle to importFolder_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
settings = gatherSettings(handles);
[pathName] = uigetdir(fullfile(settings.imageLibLoc));
foundAny = false;
newLibItems = importFolder(pathName, handles);
if isempty(newLibItems)
    messageBox(sprintf('Found no images in %s',pathName));
else
    handles.library(end+1:end+length(newLibItems)) = newLibItems;
    handles.weightMatrix = makeWeights(handles.library, handles);
    library = handles.library;
    weightMatrix = handles.weightMatrix;
    save(fullfile(settings.imageLibLoc,'imageLib.mat'),'library','weightMatrix');
    fillLibraryList(handles, handles.library)
    guidata(hObject, handles);
end


function newItems = importFolder(pathName, handles)

for ext_i = 1:length(handles.usableImageExtensions)
    ext = handles.usableImageExtensions{ext_i};
    extFiles = dir(fullfile(pathName,['*.',ext]));
    for file_i = 1:length(extFiles)
        fileName = extFiles(file_i).name;
        messageBox_h = messageBox(sprintf('Loading %s...',fileName));
        try
            if exist('newItems','var')
                newItem = processImage(pathName, fileName, gatherSettings(handles));
                if isstruct(newItem)
                    newItems(end+1) = newItem;
                end
                
            else
                newItem = processImage(pathName, fileName, gatherSettings(handles));
                if isstruct(newItem)
                    newItems = newItem;
                end
            end
        catch e
            disp(e)
            keyboard;
        end
        foundAny = true;
        close(messageBox_h)
    end
end

function speed_edit_Callback(hObject, eventdata, handles)
% hObject    handle to speed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed_edit as text
%        str2double(get(hObject,'String')) returns contents of speed_edit as a double


% --- Executes during object creation, after setting all properties.
function speed_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sizeX_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sizeX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeX_edit as text
%        str2double(get(hObject,'String')) returns contents of sizeX_edit as a double


% --- Executes during object creation, after setting all properties.
function sizeX_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sizeY_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sizeY_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeY_edit as text
%        str2double(get(hObject,'String')) returns contents of sizeY_edit as a double


% --- Executes during object creation, after setting all properties.
function sizeY_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeY_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go_button.
function go_button_Callback(hObject, eventdata, handles)
% hObject    handle to go_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Recover global variable
global running
global iter
% If the imgae doesn't exist, initialize it
if ~isfield(handles,'currImage')
    handles.currImage = initializeImage(handles);
end

% Swap the state of the animation
running = ~running;

% It it's not running, switch the button to 'GO' and end
if ~running
    set(handles.go_button,'string','Go');
    set(handles.reset_button,'enable','on');
    set(handles.step_button,'enable','on');
    return;
end

% Otherwise, set the button to 'STOP', and get the sum of the weights in
% the image library
set(handles.go_button,'string','Stop');
set(handles.reset_button,'enable','off');
set(handles.step_button,'enable','off');
weights = handles.weightMatrix;

settings = gatherSettings(handles);
allLibrary = handles.library(1).image;
allLibrary = cat(3, allLibrary, handles.library(1).image.*-1);
for i=2:length(handles.library);
    allLibrary = cat(3, allLibrary, handles.library(i).image);
    allLibrary = cat(3, allLibrary, handles.library(i).image.*-1);
end
% while it's running...
while running
    % if enough iterations have gone by, update the image
    if mod(iter, settings.speed)==0 || settings.synchronous
        axes(handles.simulation_axes);
        imagesc(handles.currImage);
        axis off;
        colormap(bone);
        drawnow;
        set(handles.iterations_text,'string',num2str(iter));
        if settings.stopOnMatch
            repImage = repmat(handles.currImage,[1,1,length(handles.library)*2]);
            matches = repImage==allLibrary;
            numMatches = squeeze(sum(sum(matches, 1),2));
            pMatches = numMatches./numel(handles.currImage);
            if any(pMatches>(settings.pMatch./100))
                running = false;
                set(handles.go_button,'string','Go');
                set(handles.reset_button,'enable','on');
                set(handles.step_button,'enable','on');
            end
        end
    end

    %  Update the network
    handles.currImage = update(handles.currImage, weights, settings);
    iter = iter+1;
end
guidata(hObject, handles);

% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currImage = initializeImage(handles);
axes(handles.simulation_axes);
imagesc(handles.currImage);
set(handles.iterations_text,'string','0')
axis off;
global iter;
iter = 0;
guidata(hObject,handles)


function noise_edit_Callback(hObject, eventdata, handles)
% hObject    handle to noise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_edit as text
%        str2double(get(hObject,'String')) returns contents of noise_edit as a double


% --- Executes during object creation, after setting all properties.
function noise_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in startingImage_lb.
function startingImage_lb_Callback(hObject, eventdata, handles)
% hObject    handle to startingImage_lb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns startingImage_lb contents as cell array
%        contents{get(hObject,'Value')} returns selected item from startingImage_lb
selected = get(hObject,'value');
data = repmat(1,length(selected),1);
set(handles.ratio_table,'rowname',1:length(selected),'data',data);

% --- Executes during object creation, after setting all properties.
function startingImage_lb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startingImage_lb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function learningRateMean_edit_Callback(hObject, eventdata, handles)
% hObject    handle to learningRateMean_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learningRateMean_edit as text
%        str2double(get(hObject,'String')) returns contents of learningRateMean_edit as a double


% --- Executes during object creation, after setting all properties.
function learningRateMean_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learningRateMean_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temperature_edit_Callback(hObject, eventdata, handles)
% hObject    handle to temperature_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temperature_edit as text
%        str2double(get(hObject,'String')) returns contents of temperature_edit as a double
axes(handles.temperature_axes);
temperature = str2double(get(hObject,'string'));
set(handles.temperature_axes,'visible','on');
plotTemperature(handles);

% --- Executes during object creation, after setting all properties.
function temperature_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temperature_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applySettings_button.
function applySettings_button_Callback(hObject, eventdata, handles)
% hObject    handle to applySettings_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
settings = gatherSettings(handles);
isAnythingChanged = false;
for image_i = 1:length(handles.library)
    if ~all(size(handles.library(image_i).image)==[settings.sizeX, settings.sizeY]) 
        messageBox_h = messageBox(sprintf('Reprocessing %s...',handles.library(image_i).name));
        handles.library(image_i) = processImage(...
            handles.library(image_i).path, ...
            handles.library(image_i).name, ...
            settings);
        close(messageBox_h);
        isAnythingChanged = true;
    end
end
set(handles.library_axes,'visible','off');
library = handles.library;

if settings.useLearningRate
    itemLearningRates = normrnd(settings.learningRateMean, settings.learningRateSD, size(library));
else
    itemLearningRates = ones(size(library));
end

itemLearningRates(itemLearningRates>1) = 1;
axes(handles.learningRate_axes);
set(handles.learningRate_axes,'visible','on')
bar(itemLearningRates);
set(gca,'xticklabel',{handles.library.name});
legend('Learning rates')
ylim([0,1.1])

axes(handles.temperature_axes);
set(handles.temperature_axes,'visible','on');
plotTemperature(handles);

messageBox_h = messageBox('Recalculating weights...');
weightMatrix = makeWeights(library, handles, itemLearningRates);
handles.weightMatrix = weightMatrix;
close(messageBox_h)
messageBox_h = messageBox('Saving weight matrix...');
save(fullfile(settings.imageLibLoc,'imageLib.mat'),'library','weightMatrix');
guidata(hObject, handles);
save('settings.mat','settings');
close(messageBox_h);


% --- Executes on button press in revertSettings_button.
function revertSettings_button_Callback(hObject, eventdata, handles)
% hObject    handle to revertSettings_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
messageBox_h = messageBox('Loading settings...'); 
[settings] = loadSettings('settings.mat',handles, false);
close(messageBox_h);
handles.settings=settings;
guidata(hObject, handles);

% --- Executes on button press in loadSettings_button.
function loadSettings_button_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettings_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, pathName] = uigetfile('./*.mat');
if fileName==0
    return;
end
messageBox_h = messageBox(sprintf('Loading %s...',fileName));

try 
    [settings] = loadSettings('settings.mat',handles, false);
    handles.settings=settings;
    close(messageBox_h);
catch e
    close(messageBox_h);
    messageBox_h = messageBox('Invalid settings file...');
end
guidata(hObject, handles);

% --- Executes on button press in step_button.
function step_button_Callback(hObject, eventdata, handles)
% hObject    handle to step_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
weights = handles.weightMatrix;
global iter
iter = iter + 1;
set(handles.iterations_text,'string',num2str(iter));
settings = gatherSettings(handles);
    handles.currImage = update(handles.currImage, weights, settings);
    axes(handles.simulation_axes);
    imagesc(handles.currImage);
    axis off;
    colormap(bone);
    drawnow;
guidata(hObject,handles);



function pMatch_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pMatch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pMatch_edit as text
%        str2double(get(hObject,'String')) returns contents of pMatch_edit as a double

% --- Executes during object creation, after setting all properties.
function pMatch_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMatch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stopOnMatch_cb.
function stopOnMatch_cb_Callback(hObject, eventdata, handles)
% hObject    handle to stopOnMatch_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stopOnMatch_cb
if get(hObject,'value')
    set(handles.pMatch_edit,'enable','on');
else
    set(handles.pMatch_edit,'enable','off');
end



function learningRateSD_edit_Callback(hObject, eventdata, handles)
% hObject    handle to learningRateSD_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learningRateSD_edit as text
%        str2double(get(hObject,'String')) returns contents of learningRateSD_edit as a double


% --- Executes during object creation, after setting all properties.
function learningRateSD_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learningRateSD_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in learningRate_cb.
function learningRate_cb_Callback(hObject, eventdata, handles)
% hObject    handle to learningRate_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of learningRate_cb
if get(hObject,'value')
    set(handles.learningRateMean_edit,'enable','on');
    set(handles.learningRateSD_edit,'enable','on');
else
    set(handles.learningRateMean_edit,'enable','off');
    set(handles.learningRateSD_edit,'enable','off');
end

% --- Executes on key press with focus on learningRate_cb and none of its controls.
function learningRate_cb_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to learningRate_cb (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in useTemperature_cb.
function useTemperature_cb_Callback(hObject, eventdata, handles)
% hObject    handle to useTemperature_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value')
    set(handles.temperature_edit,'enable','on')
else
    set(handles.temperature_edit,'enable','off');
    set(handles.temperature_edit,'string','0');
end
plotTemperature(handles);
% Hint: get(hObject,'Value') returns toggle state of useTemperature_cb

function plotTemperature(handles)
settings = gatherSettings(handles);
set(handles.library_axes,'visible','off')
cla(handles.library_axes)
%low_lim=-1000;
%high_lim=1000;
low_lim =  (log(1/.1-1)*-settings.temperature).*1.5;
high_lim = (log(1/.9-1)*-settings.temperature).*1.5;
if low_lim==high_lim
    low_lim = -1.0001;
    high_lim = 1.0002;
end
step = (high_lim-low_lim)./100;
plot((low_lim:step:high_lim),1./(1+exp(-1/settings.temperature*(low_lim:step:high_lim))));
