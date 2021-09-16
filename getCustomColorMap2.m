

function cmap = getCustomColorMap2 (name, numOfElements, varargin)
    
    upperLim = varargin{1}; % number from 0 to 1;
    bias = varargin{2}; % number from 0 to 1;
    
    cmap_aux1 = get256ColorsCMAP(name);
    cmap_aux2 = bias + cmap_aux1(1:floor(upperLim*256), :);

    segmentLength = length(cmap_aux2)/(numOfElements + 1); %% avoiding extremes

    cmap_aux3 = zeros(numOfElements, 3);

    for i = 1:numOfElements
        index = i * floor(segmentLength);
        cmap_aux3(i,:) = cmap_aux2(index,:);
    end
    cmap_aux3(cmap_aux3>1) = 1; % saturating at 1
    cmap = cmap_aux3;
end