function [ x, y ] = getxy( coord )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    global frame_x
    y = mod(coord, frame_x);
    x = idivide(cast(coord, 'uint32'), cast(frame_x, 'uint32'));

end

