
file_dir = './GOPR0005/'; %put here one of the folder locations with images;
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
OBJECT_LOOKBACK = 8;
OBJECT_LINKING_DIST_THRESH = 19; % sqrt(13^2 + 13^2 + 3^3)
INITIAL_MEDIAN_FRAMES = 25;
INITIAL_K = 200;
[X, Y] = size(grey_back);
global frame_x
frame_x = X;
[N, x] = size(filenames);
prev_frames = {};
prev_frames{N} = []; % preallocation
initial_back_frames = zeros(INITIAL_MEDIAN_FRAMES, X, Y);
object_history = {};
object_history{N} = {};

% Read one frame at a time.
for k = INITIAL_K : size(filenames,1)
  
    pause_flag = 0;
    new_objs = 0;
    frame = imread([file_dir filenames(k).name]);
    scene = rgb2gray(frame);
    
%     if k <= INITIAL_MEDIAN_FRAMES
%         initial_back_frames(k, :, :) = scene;
%     end
%     
%     if k == INITIAL_MEDIAN_FRAMES + 1
%         grey_back = median(initial_back_frames, 1);
%         grey_back = reshape(grey_back, X, Y);
%     end
    
    mask_blur = generate_keying_mask(scene, grey_back, 0, 1);
    mask_blur = bwdist(mask_blur) <= 5;
    
    masked_frame_blur = apply_mask(mask_blur, frame);
    
    conn_comp = bwconncomp(mask_blur);
    
    [object_history, new_objs] = update_objects(k, object_history, conn_comp, OBJECT_LOOKBACK, OBJECT_LINKING_DIST_THRESH);
    object_history = assign_apexes(k, object_history);
    
    X = max(size(object_history{k}));
    for i=1:X,
        obj = object_history{k}{i};
        if obj.apex_found == 1
            frame = insertMarker(frame, [obj.x, obj.y]);
            object_history{k}{i} = struct('x', obj.x, 'y', obj.y, 'id', obj.id, 'y_apex', obj.y_apex, 'apex_found', 2, 'isball', obj.isball);
            pause_flag = 1;
            %obj.apex_found = 2;
        end
    end
    
    %from original:
    set(h2, 'CData', frame);
    drawnow('expose');
    if pause_flag == 1
        pause(3);
    end
    
    [grey_back, prev_frames] = update_background(k, grey_back, prev_frames, mask_blur, scene, BACKGROUND_LOOKBACK, READJUSTMENT_THRESH, INITIAL_K);
    
    %[~, num_objects] = size(get_objects(mask_blur, 10));
    
    %clean_frame = bwmorph(frame, 'clean', 1);
    
%     masked_frame_blur = find_blobs(mask_blur, 4);
%     masked_frame_blur = repmat(double(masked_frame_blur)./255,[1 1 3]);
    
    %set(h1, 'CData', masked_frame);
    %drawnow('expose');
    
    disp(['showing frame ' num2str(k) ', current objects: ' num2str(conn_comp.NumObjects) ' (' num2str(new_objs) ' new)']);
end

