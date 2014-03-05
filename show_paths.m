function [ img ] = show_paths( img, object_history, time, initial_time )

    for t=time:-1:(initial_time + 1),
        object_count = max(size(object_history{t}));

        for obj_i=1:object_count,
            obj = object_history{t}{obj_i};

            % Find an object in the previous timeslice that has the same id as
            % this one
            T = max(size(object_history{t - 1}));
            matching_id = '';
            for i=1:T,
                if strcmp(object_history{t - 1}{i}.id, obj.id)
                    matching_id = T;
                end
            end

            if strcmp(matching_id, '')
            else
                matched_obj = object_history{t - 1}{matching_id};
                img = draw_line(img, obj.x, obj.y, matched_obj.x, matched_obj.y);
            end
        end
    end
end

