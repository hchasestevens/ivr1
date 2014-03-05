function [ img ] = show_paths( img, object_history, time, initial_time )

    for t=time:-1:(initial_time + 1), % for every time t
        object_count = max(size(object_history{t}));

        for obj_i=1:object_count, % for every old object at t
            obj = object_history{t}{obj_i};
            
            cur_object_count = max(size(object_history{time}));
            for obj_j=1:cur_object_count % for every current object
                cur_obj = object_history{time}{obj_j};

                if strcmp(obj.id, cur_obj.id) % if the old object is the current object
					% draw the old object's line to its previous position
                    img = draw_line(img, obj.x, obj.y, obj.prev_x, obj.prev_y); 
                    break
                end
            end
        end
    end
end

