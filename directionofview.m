function [points] = directionofview(Im_cell, imageIndex)
    % point scores to be returned
    points = zeros(1, length(Im_cell));
    for i = 1:length(Im_cell)
        queryImage = rgb2gray(Im_cell{i});
        % Find best fit images from direction list
        imageIDs = retrieveImages(queryImage,imageIndex);
        bestMatch = imageIDs(1); % Take first best match image
        bestImage = imread(imageIndex.ImageLocation{bestMatch});
        points(i) = bestMatch;
        % figure
        % imshowpair(queryImage,bestImage,'montage')
    end
    % Assign points (certain angles of view get the same points)
    for i = 1:length(points)
        if (points(i) == 2 || points(i) == 7 || points(i) == 4 || points(i) == 8)
            points(i) = 3;
        else
            points(i) = 0;
        end
    end
end