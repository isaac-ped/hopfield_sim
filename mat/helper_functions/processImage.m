function item = processImage( path, name, settings )
%item = PROCESSIMAGE(path, name, handles, settings)
% processes a new image, calculating its weights and generating its matfile

try 
    copyfile(fullfile(path, name), ...
        fullfile(settings.imageLibLoc, name));
catch e
    if ~strcmp(e.identifier,'MATLAB:COPYFILE:SourceAndDestinationSame')
        keyboard
    end
end

fprintf('resizing...\n')
image = resizeImage(fullfile(settings.imageLibLoc, name), settings);
if all(image==0)
    item = nan;
    messageBox(sprintf('Image %s could not be processed...',name));
    return
end
[~, nameNoExt] = fileparts(name);
fprintf('making weights...\n')
weights = makeSingleImageWeights(image, settings);
matfile = fullfile(path, [nameNoExt,'_info.mat']);
fprintf('saving...\n')
save(matfile,'image','weights')
item = newLibItem(path, name, matfile, image);
fprintf('done!\n');

end

