function imageLib = loadImageLib(imageLibLoc, handles)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if exist(fullfile(imageLibLoc,'imageLib.mat'))
    imageLib = load(fullfile(imageLibLoc,'imageLib.mat'));
else
    imageLib = struct();
    imageLib.weightMatrix = [];
    imageLib.library = struct();
    imageLib.library.path = [];
    imageLib.library.name = [];
    imageLib.library.matfile = [];
    imageLib.library.image = [];
    imageLib.library(:) = [];
end
fillLibraryList(handles, imageLib.library);

end

