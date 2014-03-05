function [ img ] = draw_line( img, x1, y1, x2, y2 )
    % source: http://stackoverflow.com/questions/2464637/matlab-drawing-a-line-over-a-black-and-white-image/14308558#14308558
    % distances according to both axes
    xn = abs(x2-x1);
    yn = abs(y2-y1);

    % interpolate against axis with greater distance between points;
    % this guarantees statement in the under the first point!
    if (xn > yn)
        xc = x1 : sign(x2-x1) : x2;
        yc = round( interp1([x1 x2], [y1 y2], xc, 'linear') );
    else
        yc = y1 : sign(y2-y1) : y2;
        xc = round( interp1([y1 y2], [x1 x2], yc, 'linear') );
    end

    % 2-D indexes of line are saved in (xc, yc), and
    % 1-D indexes are calculated here:
    ind = sub2ind( size(img), yc, xc );

    % draw line on the image (change value of '255' to one that you need)
    img(ind) = 1.0;

    % another approach in case we need it:
%     rpts = linspace(x1,x2,1000);   %# A set of row points for the line
%     cpts = linspace(y1,y2,1000);   %# A set of column points for the line
%     index = sub2ind(size(img),round(rpts),round(cpts));  %# Compute a linear index
%     img(index) = 1.0;  %# Set the values to the max value of 255 for uint8

end
