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
        
        vel = (obj.y - obj.prev_y) / double(time - obj.prev_t);
        t = vel / GRAVITY;

        if abs(t) < TIME_DIFF
            % We only care about apexes of balls
            if isball(obj.x, obj.y, obj.idxlist)
                object_history_new{time}{obj_i}.apex_found = 1;
            end
        end
    end
end


