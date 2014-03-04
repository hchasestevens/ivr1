function [ output ] = apply_mask( mask, image )
    [X, Y, Z] = size(image);
    output = zeros(X, Y, Z);
    
    for i=1:X,
        for j=1:Y,
            if mask(i, j) >= 1
                % Convert to RGB with values ranging from 0 to 1
                output(i, j, :) = double(image(i, j, :)) / double(256);
            end
        end
    end
end

