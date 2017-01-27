function [ image ] = noisyImage( image, percentNoise, handles)
%image = NOISYIMAGE(image, percentNoise, handles) adds noise to it,
%converting "percentNoise" percent of the pixels to either their flipped
%state or random noise, depending on gatherSettings().flippedNoise

noise = rand(size(image));
threshold = 1-(percentNoise/100);
randPixels = noise>threshold;
settings = gatherSettings(handles);
if settings.flippedNoise
    image(randPixels) = (image(randPixels)==-1);
    image(image==0) = -1;
else
    image(randPixels) = randsample([-1,1],nnz(randPixels), true);
end



end

