function [ weights ] = makeWeights( library, handles, itemLearningRates)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
settings = gatherSettings(handles);
weights = zeros(settings.sizeX.*settings.sizeY,'int8');
 for image_i = 1:length(library)
    this_weight = load(library(image_i).matfile,'weights');
    this_weight = this_weight.weights; 
    if settings.useLearningRate && exist('itemLearningRates','var')
        this_weight(rand(size(this_weight),'single')>itemLearningRates(image_i)) = 0;
    end
    weights = weights+this_weight;

end
weights = single(weights)./length(library);
weights(1:(size(weights)+1):numel(weights)) = 0;
end

