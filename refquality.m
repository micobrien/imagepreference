function [points] = orientation(Im_cell)
    % Define points vector to store results
    points = zeros(1, length(Im_cell));
    % Assuming all images taken with same inital compression
    % All are JPEG images, for subjective ordering can assume a screen size
    % and acceptable resolution of 300ppi on a standard photo size for
    % general printing on 4x6in
    for i = 1:length(Im_cell)
        I = Im_cell{i};
        [rows, cols, d] = size(I);
        I_ppi = (sqrt(rows^2 + cols^2))/7.21; % diagonal ppi measurement
        % Check if RGB (colour or grayscale) (all in training)
        if d == 3 % if colour image
            if I_ppi < 72 % Low res
                points(i) = 1;
            elseif I_ppi > 72 && I_ppi < 300 % Standard res
                points(i) = 2;
            elseif I_ppi > 300 % High res
                points(i) = 3;
            end          
        end
        
    end
end