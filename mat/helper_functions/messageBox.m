function varargout = messageBox(varargin)
% MESSAGEBOX MATLAB code for messageBox.fig
%      MESSAGEBOX, by itself, creates a new MESSAGEBOX or raises the existing
%      singleton*.
%
%      H = MESSAGEBOX returns the handle to a new MESSAGEBOX or the handle to
%      the existing singleton*.
%
%      MESSAGEBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MESSAGEBOX.M with the given input arguments.
%
%      MESSAGEBOX('Property','Value',...) creates a new MESSAGEBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before messageBox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to messageBox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help messageBox

% Last Modified by GUIDE v2.5 10-Mar-2014 14:53:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @messageBox_OpeningFcn, ...
                   'gui_OutputFcn',  @messageBox_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before messageBox is made visible.
function messageBox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to messageBox (see VARARGIN)

% Choose default command line output for messageBox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% The point of this whole function is just to show a message on the
% screen
set(handles.infoText,'string',varargin{1});

% UIWAIT makes messageBox wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = messageBox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
