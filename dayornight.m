function [points] = dayornight(Im_cell)
    % point scores to be returned
    points = zeros(1, length(Im_cell));
    for i = 1:length(Im_cell)
        a = Im_cell{i};
        % Create mask from HSV colour threshold
        [BW,maskedRGBImage] = createMaskHSV(a);
        % Process after mask
        [rows, cols] = size(a);
        AreaImage = rows*cols;
        % figure, imshow(a), title('Original')
        % figure, imshow(BW), title('Binary Image')
        s = regionprops(BW,'area');
        svals = [s.Area];
        % Assumes images are taken upright (top third)
        topBW = BW(1:(rows/3),1:(cols/3)/3);
        tod = sum(topBW(:) == 0)/numel(topBW)
        if tod > 0.55
            points(i) = 2;
        end
    end
end