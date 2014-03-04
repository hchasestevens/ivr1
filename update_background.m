function [ grey_back, prev_frames ] = update_background( frame_num, grey_back, prev_frames, mask, current_scene, background_lookback, readjustment_threshold, initial_frame )

    [X, Y] = size(mask);
    CHUNKS = 8; % number of horizontal strips to split image into
    increment = X * Y / CHUNKS;
    
    % Convert images to 1D vectors
    prev_frames{frame_num} = reshape(mask, 1, X*Y);
    temp_grey = reshape(grey_back, 1, X*Y);
    temp_scene = reshape(current_scene, 1, X*Y);
    
    % Only start updating the background after we have enough frames to
    % work with
    if frame_num > background_lookback + initial_frame
        
        % Update the background reference in chunks
        for chunk=1:CHUNKS,
            % Compute coordinates of the chunk in the 1D image vector
            i = 1+((chunk - 1)*increment);
            j = chunk*increment;
            
            % Extract the chunks from the previous and current frame
            prev = prev_frames{frame_num - background_lookback}(i:j);
            cur = prev_frames{frame_num}(i:j);
            
            % If the difference between the two chunks is sufficient,
            % update the background
            diff = double(sum(abs(prev - cur))) / double((X*Y));
            if diff <= (readjustment_threshold / sqrt(CHUNKS))
                temp_grey(i:j) = temp_scene(i:j);
            end
        end
    end
    
    % Convert the background reference image to a 2D matrix before return
    grey_back = reshape(temp_grey, X, Y);

end

