function [ is_ball ] = isball(center_x, center_y, idxlist)
    % Checks if an object is a ball by checking how many of its pixels fall
    % within an imaginary circle of the same area

    THRESHOLD = .898;

    is_ball = false;
    
	% Find the radius of a circle of the same area as the object
    area = max(size(idxlist));
    radius = area / pi;
    
    pixels_inside = 0;
    
	% Find how many pixels fall within the circle
    for i=1:area,
        [X, Y] = getxy(idxlist(i));
        dx = abs(center_x - X);
        dy = abs(center_y - Y);
        
        % Check if the pixel is within the circle
        if double(dx^2+dy^2) <= radius,
            pixels_inside = pixels_inside + 1;
        end
        
    end
    
    if double(pixels_inside)/double(area) > double(THRESHOLD)
        is_ball = true;
    end
end

