function [ ] = disp_bt_fnames( scene_fname, back_fname, dbg)

    background = imread(back_fname);
    scene = imread(scene_fname);
    grey_back = rgb2gray(background);
    grey_scene = rgb2gray(scene);
    imshow(background_threshold(grey_scene, grey_back, dbg));
%     hsv_back = rgb2hsv(background);
%     hsv_scene = rgb2hsv(scene);
%     
%     [X, Y, Z] = size(hsv_back);
%     hue_back = zeros(X, Y);
%     hue_scene = zeros(X, Y);
%     for i=1:X,
%         for j=1:Y,
%             hue_back(i, j) = hsv_back(i, j, 1);
%             hue_scene(i, j) = hsv_scene(i, j, 1);
%         end
%     end
%     imshow(hue_scene);
%     pause(5);
    
%     imshow(background_threshold(hue_scene, hue_back, dbg));
end

