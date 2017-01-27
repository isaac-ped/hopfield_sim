function [ item ] = newLibItem( path, name, matfile, image )
%item = NEWLIBITEM(path, name, matfile, image)
%    quick way to create a new struct containing image info
item = struct();
item.path = path;
item.name = name;
item.matfile = matfile;
item.image = image;
end

