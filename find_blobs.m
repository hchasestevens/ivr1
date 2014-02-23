function [ blob_img ] = find_blobs( scene, matrix_size )

    [X,Y] = size(scene);
    blob_img = zeros(X, Y, 1);
    
    step_size = matrix_size-1;
    
    for i=1:step_size:(X - matrix_size)
        for j=1:step_size:(Y - matrix_size)
            nonzero = sum(scene(i:(i+matrix_size), j:(j+matrix_size)));
            
            if nonzero ~= 0
               %disp('nonzero');
               for i2=i:i + matrix_size
                   for j2=j:j + matrix_size
                       blob_img(i2,j2) = 255;
                   end
               end
            end
        end
    end
    
end