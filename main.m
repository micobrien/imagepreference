%% EGH444 Digital Image Processing - Semester 2, 2018
% Problem Solving Task - Subjective Image Preference Automation
% Authors: Michael O'Brien, Harrison White, Kenneth Stowe
clear all, close all, clc

%% Solution Implementation
% Load images (test and train)
test_Im = loadimages('SIA_test');
train_Im = loadimages('SIA_train');
demo_Im = loadimages('SIA_val'); % For assessment purposes

% Define point system array
test_points = zeros(1, length(test_Im));
train_points = zeros(1, length(train_Im));
demo_points = zeros(1, length(demo_Im)); % For assessment purposes

% EDIT THIS TO CHANGE WHICH SET OF IMAGES IS RUN
imset = train_Im;
pointset = train_points;

% Apply criteria tests
%% 1. Classifier (GoogleNet) to search for 'Good' or 'Bad' objects in the image
% This looks for boats in the water or obstructions in the foreground to
% reduce score, and looks for the Harbour brigde, and detects white sails
% as 'space shuttle' or 'airship' - shown to be positive in training. This
% is done with a pretrained convolutional neural network

output1 = evalc('criteria1 = vision(imset)');
% criteria1 = vision(test_Im);
criteria1

%% 2. Time of Day analysis
% This looks at the brightest area of the region via colour thresholding in
% HSV to determine whether the image has been taken at night or during the
% day

output2 = evalc('criteria2 = dayornight(imset)');
% criteria2 = dayornight(test_Im);
criteria2

%% 3. Direction of View - ineffective?
% This looks at the orientation of the Opera House in an image - classified
% by 8 positions (N, S, E, W, NE, NW, SE, SW) by comparing sturctural
% similarities of a known base image facing that orientation
dirn_im = imageDatastore('directions');
imageIndex = indexImages(dirn_im);

output3 = evalc('criteria3 = directionofview(imset, imageIndex)');
% criteria3 = directionofview(test_Im, imageIndex);
criteria3

%% 4. Object Illumination Consistency
% This looks at the sails of the opera house in the image and locates via
% colour thresholding in L*a*b, images where the sails are more consistently 
% illuminated (less shadows) are favoured

output4 = evalc('criteria4 = comparesails(imset)');
% criteria4 = comparesails(test_Im)
criteria4

%% 5. Image Quality and Resolution
% This looks at the entire image and makes a determination of relative
% quality based on resolution and colour encoding, under the assumption
% that the application of these images are in a 4x6in photos

output5 = evalc('criteria5 = refquality(imset)');
% criteria5 = refquality(train_Im)
criteria5

%% 6. Image Orientation and Black Space
% This looks at the orientation of the image (where landscape images are 
% favorable) and checks if there are any black borders/cropping also as
% this is undesirable

output6 = evalc('criteria6 = orientation(imset)');
% criteria6 = orientation(train_Im)
criteria6

%% 7. General No Reference Image Assessment based on Training Set
% This uses a BRISQUE model created for the training set to provide
% additional analysis based on subjective preference

output7 = evalc('criteria7 = norefquality(imset)');
% criteria7 = norefquality(test_Im)
criteria7

%% Apply Point System
% Combine criteria points (with weightings)
% Normalise point scores
pointset = criteria1 + criteria2 + criteria3 + criteria4 + criteria5 + criteria6 + criteria7;
% Sort images per combined scores
orderindex = linspace(1, length(imset), length(imset));
[pts_sort, order] = sort(pointset, 'descend');
% Display image ordering
rowsneeded = (length(imset))/5;
figure,
for i=1:length(imset)
    subplot(rowsneeded, 5, i)
    imshow(imset{order(i)});
    title(['Rank ',num2str(i), ', Image No: ', num2str(order(i))]);
end

%% Functions
% Used to load images from subfolders given the name of the folder as a string 
function [imageArray] = loadimages(foldername)
    myFolder = foldername;
    if ~isdir(myFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    filePattern = fullfile(myFolder, '*.jpg');
    jpegFiles = dir(filePattern);
    for k = 1:length(jpegFiles)
      baseFileName = jpegFiles(k).name;
      fullFileName = fullfile(myFolder, baseFileName);
      fprintf(1, 'Now reading %s\n', fullFileName);
      imageArray{k} = imread(fullFileName);
      %imshow(imageArray{k});  % Display image.
      %drawnow; % Force display to update immediately.
    end
end


