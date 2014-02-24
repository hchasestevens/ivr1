
file_dir = './GOPR0005/'; %put here one of the folder locations with images;
filenames = dir([file_dir '*.jpg']);

frame = imread([file_dir filenames(1).name]);
filenames(1).name
grey_back = rgb2gray(imread([file_dir filenames(1).name]));

%figure(1); h1 = imshow(bwmorph(grey_back, 'clean', 1));
%figure(1); h1 = imshow(frame);
%figure(1); h1 = imshow(apply_mask(generate_keying_mask(frame, grey_back, 0, 0), frame));
figure(2); h2 = imshow(apply_mask(generate_keying_mask(frame, grey_back, 0, 0), frame));

READJUSTMENT_THRESH = 1e-4;
BACKGROUND_LOOKBACK = 5;
[X, Y] = size(grey_back);
[N, x] = size(filenames);
prev_frames = {};
prev_frames{N} = []; % preallocation
object_history = {};
object_history{N} = {};

% Read one frame at a time.
for k = 1 : size(filenames,1)
    frame = imread([file_dir filenames(k).name]);
    scene = rgb2gray(frame);
    %mask = generate_keying_mask(scene, grey_back, 0, 0);
    mask_blur = generate_keying_mask(scene, grey_back, 0, 1);
    %masked_frame = apply_mask(mask, frame);
    masked_frame_blur = apply_mask(mask_blur, frame);
    
    %from original:
    set(h2, 'CData', masked_frame_blur);
    drawnow('expose');
    
    prev_frames{k} = reshape(mask_blur, 1, X*Y);
    if k > BACKGROUND_LOOKBACK
        diff = double(sum(abs(prev_frames{k-BACKGROUND_LOOKBACK} - prev_frames{k}))) / double((X*Y));
        if diff <= READJUSTMENT_THRESH
            %disp('bu');
            grey_back = scene;
        end
    end
    
    %[~, num_objects] = size(get_objects(mask_blur, 10));
    conn_comp = bwconncomp(mask_blur);
    
    %clean_frame = bwmorph(frame, 'clean', 1);
    
%     masked_frame_blur = find_blobs(mask_blur, 4);
%     masked_frame_blur = repmat(double(masked_frame_blur)./255,[1 1 3]);
    
    %set(h1, 'CData', masked_frame);
    %drawnow('expose');
    
    disp(['showing frame ' num2str(k) ', current objects: ' num2str(conn_comp.NumObjects)]);
end

