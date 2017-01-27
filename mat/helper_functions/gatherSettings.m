function settings = gatherSettings(handles )
%settings = GATHERSETTINGS(handles) gathers all of the settings from the
% settings panel into a single struct.
settings = struct();
settings.speed = str2double(get(handles.speed_edit,'string'));
settings.sizeX = str2double(get(handles.sizeX_edit,'string'));
settings.sizeY = str2double(get(handles.sizeY_edit,'string'));
settings.useLearningRate = get(handles.learningRate_cb,'value');
settings.learningRateMean = str2double(get(handles.learningRateMean_edit,'string'));
settings.learningRateSD = str2double(get(handles.learningRateSD_edit,'string'));
settings.useTemperature = get(handles.useTemperature_cb,'value');
settings.temperature = str2double(get(handles.temperature_edit,'string'));
settings.flippedNoise = get(handles.flippedNoise_rb,'value');
settings.synchronous = get(handles.synchronous_rb,'value');
settings.imageLibLoc = get(handles.imageLibLoc_edit,'string');
settings.stopOnMatch = get(handles.stopOnMatch_cb,'value');
settings.pMatch = str2double(get(handles.pMatch_edit,'string')); 

end

