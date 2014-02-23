function [ current_objects ] = get_objects( mask, matrix_size )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    [X, Y] = size(mask);
    current_objects = {};
    current_objects{40} = {};
    current_object_n = 0;
    step_size = double(matrix_size) / double(2);
    
    for i=1:step_size:(X - matrix_size),
        for j=1:step_size:(Y - matrix_size),
            nonzero = sum(mask(i:(i+matrix_size), j:(j+matrix_size)));
            
            if nonzero ~= 0
               %determine if there are shared pixels:
               %[~, Z] = size(current_objects);
               Z = current_object_n;
               obj_index = 0;
               
               %check --
               for i2=i:i+matrix_size,
                   if obj_index ~= 0
                       break
                   end
                   for j2=j:j+matrix_size,
                       if obj_index ~= 0
                           break
                       end
                       for k=1:Z,
                           if obj_index ~= 0
                               break
                           end
                           [~, T] = size(current_objects{k});
                           for l=1:T,
                               if current_objects{k}{T} == [i2, j2],
                                   obj_index = k;
                                   break
                               end
                           end
                       end
                   end
               end
%                
%                %check leftmost column
%                for j2=j:j+matrix_size,
%                    if obj_index ~= 0
%                        break
%                    end
%                    for k=1:Z,
%                        if obj_index ~= 0
%                            break
%                        end
%                        [~, T] = size(current_objects{k});
%                        for l=1:T,
%                            if current_objects{k}{T} == [i, j2],
%                                obj_index = k;
%                                break
%                            end
%                        end
%                    end
%                end
               
               %create new object if none found 
               if obj_index == 0
                   obj_index = Z+1;
                   current_objects{obj_index} = {};
                   current_object_n = current_object_n + 1;
               end
               
               %add nonzero pixels to current object
               for i2=i:i + matrix_size,
                   for j2=j:j + matrix_size,
                       if mask(i2, j2) ~= 0,
                           [~, T] = size(current_objects{obj_index});
                           current_objects{obj_index}{T+1} = [i2, j2];
                       end
                   end
               end
            end
        end
    end
    

end

