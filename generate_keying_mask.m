function [ thresholded_diff ] = generate_keying_mask( scene, background, dbg )

    %params
    MIN_THRESHOLD = 16;
    THRESHOLD_MULT = 0.6;

    %get differences between background, scene:
    diff = (max(background, scene) - min(background, scene));

    if dbg > 0
        imshow(diff)
        pause(10);
    end
    
    %create histogram:
    edges = linspace(0, 255, 256);

    [X, Y] = size(scene);
    vec = reshape(diff, 1, X*Y);      % turn image into long array
    histogram = histc(vec, edges)';        % do histogram
    
    if dbg > 0
        plot(histogram)
        pause(10);
    end
    
    %smoothing hist:
    threshold = findthresh(histogram, 6, 0); % params taken from lab
    threshold = THRESHOLD_MULT * threshold;
    threshold = max(threshold, MIN_THRESHOLD);

    thresholded_diff = zeros(X, Y);
    
    threshold_indices = diff > threshold;
    thresholded_diff(threshold_indices) = 255;
    %thresholded_diff = bwmorph(thresholded_diff, 'clean', 1);
end

