function [ grey_back, prev_frames ] = update_background( frame_num, grey_back, prev_frames, mask, current_scene, background_lookback, readjustment_threshold )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [X, Y] = size(mask);
    prev_frames{frame_num} = reshape(mask, 1, X*Y);
    if frame_num > background_lookback
        diff = double(sum(abs(prev_frames{frame_num - background_lookback} - prev_frames{frame_num}))) / double((X*Y));
        if diff <= readjustment_threshold
            grey_back = current_scene;
        end
    end

end

