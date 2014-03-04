function [ object_history_new ] = assign_apexes( time, object_history)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        % Marking cc centers (for later use):
    
    object_history_new = object_history;
    
    Z = max(size(object_history{time}));
    
    GRAVITY = 9.8;
    TIME_DIFF = 0.04;
    
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

                if abs(t) < TIME_DIFF && obj.apex_found == 0
                    if isball(obj.x, obj.y, obj.idxlist)
                        object_history_new{time}{obj_i}.apex_found = 1;
                    end
                end
            end
        end
    end
end

