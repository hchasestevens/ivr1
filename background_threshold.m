function [ diff ] = generate_keying_mask( scene, background, dbg )

    %params
    MIN_THRESHOLD = 16;
    THRESHOLD_MULT = 0.75;
    EROSIONS = 2;
    THICKENINGS = 3;


    [X,Y] = size(scene);
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
    end
    
    
%     %create histogram:
%     edges = zeros(256,1);
%     for i = 1 : 256;
%         edges(i) = i-1;
%     end
%     vec = reshape(diff, 1, X*Y);      % turn image into long array
%     histogram = histc(vec, edges)';        % do histogram
%     
%     if dbg > 0
%         %plot(histogram)
%     end
%     
%     
%     %smoothing hist:
%     threshold = findthresh(histogram, 6, 0); % params taken from lab
%     threshold = THRESHOLD_MULT * threshold;
%     threshold = max(threshold, MIN_THRESHOLD);
%     
%     thresholded_diff = zeros(X, Y);
%     for i=1:X,
%         for j=1:Y,
%             if diff(i, j) >= threshold
%                 thresholded_diff(i,j) = 255;
%             end
%         end
%     end
%     
%     %thresholded_diff = bwmorph(thresholded_diff, 'erode', EROSIONS);
%     %thresholded_diff = bwmorph(thresholded_diff, 'thicken', THICKENINGS);
%     %thresholded_diff = bwmorph(thresholded_diff, 'clean', 1);


end

