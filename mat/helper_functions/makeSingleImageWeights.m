function [ weights ] = makeSingleImageWeights( image, settings )
%weights = MAKESINGLEIMAGEWEIGHTS(image) multiplies an image by its
%    transpose, getting the weight matrix associated with just that image

this_image_flat = image(:);
weights = this_image_flat*this_image_flat';
weights = int8(weights);
end

