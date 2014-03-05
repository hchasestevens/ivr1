function [ img ] = draw_line( img, x1, y1, x2, y2 )
	% Compute a set of points for the x and y axes
    cpts = linspace(x1,x2,500);  
    rpts = linspace(y1,y2,500); 

	% Get the linear indices corresponding to these points
    index = sub2ind(size(img),round(rpts),round(cpts));

	% Set the color of the points on the line to red
    img(index) = 1.0;
end

