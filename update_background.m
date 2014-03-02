function [ grey_back, prev_frames ] = update_background( frame_num, grey_back, prev_frames, mask, current_scene, background_lookback, readjustment_threshold )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [X, Y] = size(mask);
    CHUNKS = 8;
    increment = X * Y / CHUNKS;
    prev_frames{frame_num} = reshape(mask, 1, X*Y);
    temp_grey = reshape(grey_back, 1, X*Y);
    temp_scene = reshape(current_scene, 1, X*Y);
    
    if frame_num > background_lookback
        for chunk=1:CHUNKS,
            i = 1+((chunk - 1)*increment);
            j = chunk*increment;
            prev = prev_frames{frame_num - background_lookback}(i:j);
            cur = prev_frames{frame_num}(i:j);
            diff = double(sum(abs(prev - cur))) / double((X*Y));
            if diff <= (readjustment_threshold / sqrt(CHUNKS))
                temp_grey(i:j) = temp_scene(i:j);
            end
        end
    end
    
    grey_back = reshape(temp_grey, X, Y);

end

