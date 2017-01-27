function fillLibraryList( handles, imageLib )
%FILLIBRARYLIST(handles, imageLib) fills the imageLib_lb with the items in
%the imageLib struct

names = {imageLib.name};
set(handles.imageLib_lb,'string',names, 'value',1);
names = [names, 'blank'];
set(handles.startingImage_lb,'string',names, 'value',1);
end

