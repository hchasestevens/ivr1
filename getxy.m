function [ x, y ] = getxy( coord )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    global IMG_WIDTH
    y = mod(coord, IMG_WIDTH);
    x = idivide(cast(coord, 'uint32'), cast(IMG_WIDTH, 'uint32'));

end

