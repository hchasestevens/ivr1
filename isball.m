function [ ball_status ] = isball(center_x, center_y, idxlist)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    UNCONFIRMED = false;
    CONFIRMED = true;
    THRESHOLD = .9;

    ball_status = UNCONFIRMED;
    
    area = max(size(idxlist));
    radius = area / pi;
    
    inside = 0;
    
    for i=1:area,
        [X, Y] = getxy(idxlist(i));
        dx = abs(center_x - X);
        dy = abs(center_y - Y);
        
        if double(dx^2+dy^2) <= radius,
            inside = inside + 1;
        end
        
    end

    if double(inside)/double(area) > double(THRESHOLD)
        ball_status = CONFIRMED;
    end
    
end

