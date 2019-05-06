function [points] = orientation(Im_cell)
    % Define points vector to store results
    points = zeros(1, length(Im_cell));
    
    for i = 1:length(Im_cell)
        I = Im_cell{i};
        % Check orientation
        [rows, cols, d] = size(I);
        if (rows/cols > 0.8) % Square/Portrait
           if (rows/cols > 1.15) % Portrait
               points(i) = 0;
           else
               points(i) = 1; % Square
           end
        else 
            points(i) = 2;
        end        
        % Check for black space
        grayImage = rgb2gray(I);
        allZeroColumns = all(grayImage == 0, 1);
        allZeroRows = all(grayImage == 0, 2);
        % Check for either/both border types
        prows = rows/20; pcols = cols/20;
        % If theres a vertical borders (left-right) of min 5% of image size
        if (any(allZeroColumns(1:round(pcols))) && any(allZeroColumns(round(end-pcols):end)))
            points(i) = 0;
        end
        % If there are any horizontal borders (top-bottom) of min 5% of image size
        if (any(allZeroRows(1:round(prows))) && any(allZeroRows(round(end-prows)/20:end)))
            points(i) = 0;
        end
    end
end