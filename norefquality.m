function [points] = norefquality(Im_cell)
    % Define array to score no reference quality tests
    scores = zeros(1, length(Im_cell));
    points = zeros(1, length(Im_cell));
    
    imds = imageDatastore('SIA_train');
    %opinionScores = [90 100 30 50 60 40 0 20 10 70]; %Tests
    % Scores defined through subjective Train
    opinionScores = [100 27 73 67 33 60 20 7 53 93 80 13 40 46 87]; 
    model = fitbrisque(imds,opinionScores'); % create brisque model from training set
    for i = 1:length(Im_cell)
        I = Im_cell{i};
        brisqueI = brisque(I,model); % apply model to each image
        scores(i) = brisqueI;
    end
    % Assign points (by order only)
    points = rescale(scores,0,length(Im_cell))
end

