function [ x, y ] = getxy( coord )
	% Convert coordinate indexing into a 1D image into [X,Y] for a 2D one
    global IMG_WIDTH
    y = mod(coord, IMG_WIDTH);
    x = idivide(cast(coord, 'uint32'), cast(IMG_WIDTH, 'uint32'));
end

