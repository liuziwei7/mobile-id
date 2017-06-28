clear; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Add dependencies
dir_lib_tsne = './utils/tSNE_matlab/';
addpath(genpath(dir_lib_tsne));

%% Set directories
dir_data = './data/gallery/lfw/';

file_features = [dir_data, 'features_gallery_mat.mat'];
file_features_tsne = [dir_data, 'features_gallery_tsne.mat'];

dir_img = [dir_data, 'img_align_cropped/'];
file_list_img = [dir_data, 'list_img_align_cropped.mat'];

dir_vis = './misc/';
file_vis_tsne = [dir_vis, 'vis_tsne_gallery.jpg'];

%% Set hyper-parameters
S = 5000; % size of full embedding image
G = zeros(S, S, 3, 'uint8');
s = 100; % size of every single image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load gallery features
load(file_features);

%% Perform t-SNE embedding
tic;
if ~exist(file_features_tsne)
    x = tsne(features_gallery, []);
    save(file_features_tsne, 'x', '-v7.3');
else 
    load(file_features_tsne);
end 
toc;
disp('t-SNE embedding completed ...');

%% Normalize t-SNE embedding
x = bsxfun(@minus, x, min(x));
x = bsxfun(@rdivide, x, max(x));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Visualize t-SNE embedding by creating a composite image
load(file_list_img);
num_img = length(name_img);

for i = 1:num_img
    
    if mod(i, 100)==0
        fprintf('%d/%d...\n', i, num_img);
    end
    
    % location
    a = ceil(x(i, 1) * (S - s) + 1);
    b = ceil(x(i, 2) * (S - s) + 1);
    a = a - mod(a-1,s) + 1;
    b = b - mod(b-1,s) + 1;
    if G(a, b, 1) ~= 0
        continue % spot already filled
    end
    
    I = imread([dir_img, name_img{i}]);
    if size(I, 3) == 1, I = cat(3, I, I, I); end
    I = imresize(I, [s, s]);
    
    G(a:a+s-1, b:b+s-1, :) = I;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save visualization result
figure(1);
imshow(G);
imwrite(G, file_vis_tsne);
