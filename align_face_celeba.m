function [img_align, landmarks_align] = align_face_celeba(img_orig, landmarks_orig)
%% This MATLAB function provides the face alignment method used in generating CelebA dataset ('align&cropped images').
%
%% Args:
% 'img_orig': the original face image
% 'landmarks_orig': the position of five facial landmarks on the original face image, which should be given in the following form:
%
%  landmarks_orig = [lefteye_x     lefteye_y
%                    righteye_x    righteye_y
%                    nose_x        nose_y
%                    leftmouth_x   leftmouth_y
%                    rightmouth_x  rightmouth_y];
%
%% Returns:
% 'img_align': the aligned face image with the size of 218*178
% 'landmarks_align': the position of five facial landmarks on the aligned face image

	% crop faces in celeba_align
	% bbox = [33.117700 144.882300 41.605820 172.394180]; % [x1, x2, y1, y2]
	% bbox = [10.000000 168.000000 14.553191 199.446809]; % [x1, x2, y1, y2]

	pos_align = [70.745     112
		  		 108.237    112
	      		 89.432     153.514];

	t = cp2tform([landmarks_orig([1 2], :); mean(landmarks_orig([4 5], :))], pos_align, 'nonreflective similarity');
	r = makeresampler({'cubic', 'nearest'}, 'replicate');
	img_align = imtransform(img_orig, t, r, 'XYScale', 1, 'XData', [1 178], 'YData', [1 218]);
	landmarks_align = tformfwd(t, landmarks_orig);
