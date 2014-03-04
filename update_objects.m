function [ history, new_objs ] = update_objects( time, history, conn_comp, lookback, dist_threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [~, Z] = size(conn_comp.PixelIdxList);
    props = regionprops(conn_comp, 'centroid');
    
    cc_centers = cat(1, props.Centroid);

    new_objs = 0;

    history{time} = {};
    for z=1:Z,
        comp_x = cc_centers(z, 1);
        comp_y = cc_centers(z, 2);
        lowest_dist = 1000000;
        no_obj_match = 1;
        lowest_dist_id = strcat(num2str(time), '_', num2str(z));
        lowest_dist_apexfound = 0;
        
        for time_slice=max(1, time - lookback - 1):time-1
            num_objs = max(size(history{time_slice}));
        
            for i=1:num_objs,
                past_obj_x = history{time_slice}{i}.x;
                past_obj_y = history{time_slice}{i}.y;
                dist = sqrt((comp_x - past_obj_x)^2 + (comp_y - past_obj_y)^2 + (time - time_slice)^3);
                
                % found new closest obj from our sordid past
                if (dist < lowest_dist) && (dist < dist_threshold)
                    lowest_dist_id = history{time_slice}{i}.id;
                    lowest_dist_apexfound = history{time_slice}{i}.apex_found;
                    lowest_dist = dist;
                    no_obj_match = 0;
                end
            end
        end

        new_objs = new_objs + no_obj_match;
        if no_obj_match == 1
            apex_found = 0;
        else
            apex_found = lowest_dist_apexfound;
        end
        
        %store y of last seen instance of obj
        history{time}{z} = struct('x', comp_x, 'y', comp_y, 'id', lowest_dist_id, 'y_apex', -1, 'apex_found', apex_found, 'idxlist', conn_comp.PixelIdxList{z});
    end
    
end

