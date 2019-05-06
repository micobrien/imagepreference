function [points] = comparesails(Im_cell)
    % Define array of points to be returned
    points = zeros(1, length(Im_cell));
    ref = imread('SIA_train/SIA_tr01.jpg');
    % Mask image from predefined HSV segmentation
    [BWref,maskedRGBImageref] = createMasksails(ref);
    BWref = mat2gray(BWref); % to image type for comparison
    
    for i = 1:length(Im_cell)
        a = Im_cell{i};
        %Create mask from HSV colour threshold
        [BW,maskedRGBImage] = createMasksails(a);
        % Process after mask
        BW = mat2gray(BW);
        % Resize images to be the same for comparison
        % Get size of existing image A. 
        [rowsA colsA numberOfColorChannelsA] = size(BW); 
        % Get size of existing image B. 
        [rowsB colsB numberOfColorChannelsB] = size(BWref); 
        % See if lateral sizes match. 
        if rowsB ~= rowsA || colsA ~= colsB;
        % Size of B does not match A, so resize B to match A's size. 
        BWref = imresize(BWref, [rowsA colsA]); 
        end
        % Get structural similarity to known image with consistent
        % illumination of sails
        [ssimval, ssimmap] = ssim(BW,BWref)
        points(i) = ssimval;
        % figure, imshow(BW)
    end
    points = rescale(points,0,3)
end