function [ image ] = resizeImage( imagePath, settings )
%image = RESIZEIMAGE(imagePath, settings)
%   resizes an image to the size specified in the settings, and thresholds
%   it (usings the arbitrary limit of 100. TODO: customizable?)

image = double(imread(imagePath));
image = imresize(image, [settings.sizeX, settings.sizeY]);
image = mean(image, 3);
image(image<=100) = -1;
image(image>100) = 1;


end

