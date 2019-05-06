function [points] = vision(Im_cell)
    points = zeros(1, length(Im_cell));
    points = 5; % set middle value assignment as default (for images with 
    % no particular recognised features found)
    % Using pretrained classifier GoogLeNeT
    net = googlenet;
    inputSize = net.Layers(1).InputSize
    classNames = net.Layers(end).ClassNames;
    numClasses = numel(classNames);
    
    for i = 1:length(Im_cell)
        points(i) = 3; % set initial points (as test is negative, positive, neutral)
        I = Im_cell{i};
        I = imresize(I,inputSize(1:2));
        [label,scores] = classify(net,I); % Classify with pretrained net
        figure, imshow(I)
        title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");
        % Assign scores
        [~,idx] = sort(scores,'descend');
        idx = idx(5:-1:1);
        classNamesTop = net.Layers(end).ClassNames(idx)
        scoresTop = scores(idx)

        figure
        barh(scoresTop)
        xlim([0 1])
        title("Top 5 Predictions for Image No: " + num2str(i))
        xlabel('Probability')
        yticklabels(classNamesTop)
        
        % Settle a score
        % 'Good' indicators
        index = find(strcmp(classNamesTop, 'space shuttle')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.3
                points(i) = 5; 
            end
        end
        index = find(strcmp(classNamesTop, 'steel arch bridge')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.3
                points(i) = 5; 
            end
        end
        index = find(strcmp(classNamesTop, 'airship')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.2
                points(i) = 4; 
            end
        end
        index = find(strcmp(classNamesTop, 'fireboat')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.2
                points(i) = 4; 
            end
        end
        
        % 'Bad' indicators
        index = find(strcmp(classNamesTop, 'waplane')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.15
                points(i) = 2; 
            end
        end
        index = find(strcmp(classNamesTop, 'lifeboat')); % Find index of relevant term
        if isempty(index) == 1
            if scoresTop(index) > 0.4
                points(i) = 1; 
            end
        end
        index = find(strcmp(classNamesTop, 'speedboat')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.4
                points(i) = 1; 
            end
        end
        index = find(strcmp(classNamesTop, 'aircraft carrier')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.4
                points(i) = 2; 
            end
        end
                index = find(strcmp(classNamesTop, 'solar dish')); % Find index of relevant term
        if isempty(index) == 0
            if scoresTop(index) > 0.5
                points(i) = 2; 
            end
        end
        
        
    end
end



