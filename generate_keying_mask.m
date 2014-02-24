function [ thresholded_diff ] = generate_keying_mask( scene, background, dbg, blur )

    %params
    MIN_THRESHOLD = 16;
    THRESHOLD_MULT = 0.9;
    EROSIONS = 1;
    THICKENINGS = 2;


    [X,Y] = size(background);
    diff = zeros(X,Y);
    
    
    %get abs differences between background, scene:
    for i=1:X,
        for j=1:Y,
            b = background(i, j);
            s = scene(i, j);
            diff(i, j) = max(b, s) - min(b, s);
        end
    end
    
    if dbg > 0
        imshow(diff)
        pause(10);
    end
    
    
    %create histogram:
    edges = zeros(256,1);
    for i = 1 : 256;
        edges(i) = i-1;
    end
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
    for i=1:X,
        for j=1:Y,
            if diff(i, j) >= threshold
                thresholded_diff(i,j) = 255;
            end
        end
    end
    
    thresholded_diff = bwmorph(thresholded_diff, 'clean', 1);
    if blur > 0
        gauss_filter = fspecial('gaussian', 4, 3.5);
        thresholded_diff = imfilter(thresholded_diff, gauss_filter, 'same');
    end
    
    
    
    thresholded_diff = bwmorph(thresholded_diff, 'majority', 4);
    %thresholded_diff = bwmorph(thresholded_diff, 'erode', EROSIONS);
    %thresholded_diff = bwmorph(thresholded_diff, 'thicken', THICKENINGS);
    %thresholded_diff = bwmorph(thresholded_diff, 'clean', 1);


end

