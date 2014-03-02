
file_dir = './GOPR0004/'; %put here one of the folder locations with images;
filenames = dir([file_dir '*.jpg']);

frame = imread([file_dir filenames(1).name]);
filenames(1).name
grey_back = rgb2gray(imread([file_dir filenames(1).name]));

%figure(1); h1 = imshow(bwmorph(grey_back, 'clean', 1));
%figure(1); h1 = imshow(frame);
%figure(1); h1 = imshow(apply_mask(generate_keying_mask(frame, grey_back, 0, 0), frame));
figure(2); h2 = imshow(apply_mask(generate_keying_mask(frame, grey_back, 0, 0), frame));

READJUSTMENT_THRESH = 1e-5;
BACKGROUND_LOOKBACK = 5;
OBJECT_LOOKBACK = 5;
OBJECT_LINKING_DIST_THRESH = 15; % sqrt(10^2 + 10^2 + 3^3)
[X, Y] = size(grey_back);
[N, x] = size(filenames);
prev_frames = {};
prev_frames{N} = []; % preallocation
object_history = {};
object_history{N} = {};

% Read one frame at a time.
for k = 1 : size(filenames,1)
    new_objs = 0;
    frame = imread([file_dir filenames(k).name]);
    scene = rgb2gray(frame);
    %mask = generate_keying_mask(scene, grey_back, 0, 0);
    mask_blur = generate_keying_mask(scene, grey_back, 0, 1);
    %masked_frame = apply_mask(mask, frame);
    masked_frame_blur = apply_mask(mask_blur, frame);
    
    conn_comp = bwconncomp(mask_blur);
    
    [object_history, new_objs] = update_objects(k, object_history, conn_comp, OBJECT_LOOKBACK, OBJECT_LINKING_DIST_THRESH);
    
    %from original:
    set(h2, 'CData', masked_frame_blur);
    drawnow('expose');
    
    [grey_back, prev_frames] = update_background(k, grey_back, prev_frames, mask_blur, scene, BACKGROUND_LOOKBACK, READJUSTMENT_THRESH);
   
    %[~, num_objects] = size(get_objects(mask_blur, 10));
    
    %clean_frame = bwmorph(frame, 'clean', 1);
    
%     masked_frame_blur = find_blobs(mask_blur, 4);
%     masked_frame_blur = repmat(double(masked_frame_blur)./255,[1 1 3]);
    
    %set(h1, 'CData', masked_frame);
    %drawnow('expose');
    
    disp(['showing frame ' num2str(k) ', current objects: ' num2str(conn_comp.NumObjects) ' (' num2str(new_objs) ' new)']);
end

