function [ object_history ] = assign_apexes( time, object_history)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        % Marking cc centers (for later use):
    
    Z = max(size(object_history{time}));
    
    GRAVITY = 9.8;
    
    if time > 1
        for obj_i=1:Z,
            obj = object_history{time}{obj_i};
            T = max(size(object_history{time - 1}));
            matching_id = '';
            for i=1:T,
                if strcmp(object_history{time - 1}{i}.id, obj.id)
                    matching_id = T;
                end
            end
            if strcmp(matching_id, '')
            else
                matched_obj = object_history{time - 1}{matching_id};
                vel = (obj.y - matched_obj.y);
                t = vel / GRAVITY;
                obj.y_apex = (vel * t - .5 * GRAVITY * t^2);
                obj.y_apex
            end
        end
    end
end

