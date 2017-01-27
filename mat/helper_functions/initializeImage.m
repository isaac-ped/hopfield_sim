function imageStart = initializeImage( handles )
%imageStart = INITIALIZEIMAGE(handles) initializes the image to be used in
%   the network

settings = gatherSettings(handles);
image_indices = get(handles.startingImage_lb,'value');
ratios = get(handles.ratio_table,'data');
ratios = ratios/sum(ratios);
image_nums = rand(settings.sizeX, settings.sizeY);
ratio_so_far = 0;
for i=1:length(ratios)
    ratio_so_far = ratio_so_far + ratios(i);
    image_nums(image_nums<ratio_so_far) = image_indices(i);
end
imageStart = nan(settings.sizeX, settings.sizeY);
for image_i=1:length(image_nums)
    image_index = image_nums(image_i);
    if image_index>length(handles.library)
        this_image = ones(settings.sizeX,settings.sizeY);
    else 
        this_image = handles.library(image_index).image;
    end
    imageStart(image_nums==image_index) = this_image(image_nums==image_index);
end

percNoise = str2double(get(handles.noise_edit,'string'));
imageStart = noisyImage(imageStart, percNoise, handles);

end

