function [ object_history_new ] = assign_apexes( time, object_history)

    if time <= 1
        % We don't have the necessary history of the objects to evaluate
        return
    end
    
    object_history_new = object_history;
    
    Z = max(size(object_history{time}));
    
    GRAVITY = 9.8;
    TIME_DIFF = 0.04;
    
    for obj_i=1:Z,
        obj = object_history{time}{obj_i};
        
        % If we already found the apex for this object, skip it
        if obj.apex_found ~= 0
            continue
        end

        % Find an object in the previous timeslice that has the same id as
        % this one
        T = max(size(object_history{time - 1}));
        matching_id = '';
        for i=1:T,
            if strcmp(object_history{time - 1}{i}.id, obj.id)
                matching_id = T;
            end
        end

        % If we found a match, see if it is at the apex by calculating the
        % velocity
        if strcmp(matching_id, '')
        else
            matched_obj = object_history{time - 1}{matching_id};
            vel = (obj.y - matched_obj.y);
            t = vel / GRAVITY;

            if abs(t) < TIME_DIFF
                % We only care about apexes of balls
                if isball(obj.x, obj.y, obj.idxlist)
                    object_history_new{time}{obj_i}.apex_found = 1;
                end
            end
        end
    end
end

