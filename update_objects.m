function [ history, new_objs ] = update_objects( time, history, conn_comp, lookback, dist_threshold, size_threshold )

    [~, Z] = size(conn_comp.PixelIdxList);
    lower_size_thresh = size_threshold(1);
    upper_size_thresh = size_threshold(2);
          
    % Get the centers of the connected components
    props = regionprops(conn_comp, 'centroid');
    cc_centers = cat(1, props.Centroid);

    new_objs = 0;
    history{time} = {};
    
    obj_index = 0;
    
    for z=1:Z,
        
		% Check if the component is too large or too small
		% to be considered an object
        area = max(size(conn_comp.PixelIdxList{z}));
        if area < lower_size_thresh || area > upper_size_thresh
            continue % 2small2careabout
        end
        
        obj_index = obj_index + 1;
        
        comp_x = cc_centers(z, 1);
        comp_y = cc_centers(z, 2);
        lowest_dist = 1000000;
        no_obj_match = 1;
        lowest_dist_x = -1;
        lowest_dist_y = -1;
        lowest_dist_t = -1;
        
        % Check for nearby objects in multiple timeslices
        for time_slice=max(1, time - lookback - 1):time-1
            num_objs = max(size(history{time_slice}));
        
            for i=1:num_objs,
                past_obj_x = history{time_slice}{i}.x;
                past_obj_y = history{time_slice}{i}.y;
                
                % Calculate distance to object. Using time as well since we
                % want older observations to have less weight
                dist_ = sqrt((comp_x - past_obj_x)^2 + (comp_y - past_obj_y)^2 + abs(time - time_slice)^3);
                
                % found new closest obj from our sordid past
                if (dist_ < lowest_dist) && (dist_ < dist_threshold)
                    lowest_dist_id = history{time_slice}{i}.id;
                    lowest_dist_x = history{time_slice}{i}.x;
                    lowest_dist_y = history{time_slice}{i}.y;
                    lowest_dist_t = time_slice;
                    lowest_dist_apexfound = history{time_slice}{i}.apex_found;
                    lowest_dist = dist_;
                    no_obj_match = 0;
                end
            end
        end
        
        new_objs = new_objs + no_obj_match;
        if no_obj_match == 1
            apex_found = 0;
            lowest_dist_x = comp_x;
            lowest_dist_y = comp_y;
            lowest_dist_t = time;
            lowest_dist_id = strcat(num2str(time), '_', num2str(z));
        else
            apex_found = lowest_dist_apexfound;
        end

        % Store the object in the history 
        history{time}{obj_index} = struct('x', comp_x, 'y', comp_y, ...
            'id', lowest_dist_id, ...
            'y_apex', -1, 'apex_found', apex_found, ...
            'idxlist', conn_comp.PixelIdxList{z}, ...
            'prev_x', lowest_dist_x, 'prev_y', lowest_dist_y, 'prev_t', lowest_dist_t);
    end
    
end

