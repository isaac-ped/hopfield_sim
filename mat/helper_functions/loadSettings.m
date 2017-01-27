function [settings, imageLib] = loadSettings( settingsFile, handles , doImageLib)
%settings = LOADSETTINGS(settingsFile, handles) sets all of the values in
% the settings panel to the values specified in the saved settingsFile

settings = load(settingsFile);
settings = settings.settings;
set(handles.speed_edit,'string',num2str(settings.speed));
set(handles.sizeX_edit,'string',num2str(settings.sizeX));
set(handles.sizeY_edit,'string',num2str(settings.sizeY));
set(handles.learningRateMean_edit,'string',num2str(settings.learningRateMean));
set(handles.learningRateSD_edit,'string',num2str(settings.learningRateSD));
set(handles.useTemperature_cb,'value',settings.useTemperature);
set(handles.temperature_edit,'string',num2str(settings.temperature));
set(handles.flippedNoise_rb,'value',settings.flippedNoise);
set(handles.randomNoise_rb,'value',~settings.flippedNoise);
set(handles.synchronous_rb,'value',settings.synchronous);
set(handles.asynchronous_rb,'value',~settings.synchronous);
set(handles.imageLibLoc_edit,'string',settings.imageLibLoc);
if ~exist('doImageLib','var') || doImageLib
    imageLib = loadImageLib(settings.imageLibLoc,handles);
end
set(handles.stopOnMatch_cb,'value',settings.stopOnMatch);
set(handles.pMatch_edit,'string',num2str(settings.pMatch));
end

