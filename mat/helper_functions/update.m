function [ output ] = update( input, weights, settings)
%UPDATE(input, weights) updates a randomly chosen cell in the
% input matrix using the weight matrix.
% Input can be n-dimensional, though has to match in size with the weight
% matrix.
input_flat = input(:);

if ~settings.synchronous
    node_num = randi(length(input_flat),1);
    new_val = sum(weights(:,node_num).*input_flat);
    if ~settings.useTemperature
        if new_val>0
            input_flat(node_num) = 1;
        elseif new_val<0
            input_flat(node_num) = -1;
        else
            input_flat(node_num) = randsample([-1,1],1);
        end
    else
        p = 1./(1+exp(-1/settings.temperature.*new_val));
        if p>rand(1)
            input_flat(node_num) = 1;
        else
            input_flat(node_num) = -1;
        end
    end
    output = reshape(input_flat, size(input));
else
    output = weights*input_flat;
    if ~settings.useTemperature
        output(output>0) = 1;
        output(output<0) = -1;
        output(output==0) = randsample([-1,1],nnz(output==0));
    else
        p = 1./(1+exp(-1/settings.temperature.*output));
        rand_vals = rand(size(output));
        output(p>rand_vals) = 1;
        output(p<=rand_vals) = -1;
    end
    output = reshape(output, size(input));
end
end

