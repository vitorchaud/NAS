

function h = plotScatter (mns, mnName_cellarray, propertyType, nameProperty1, nameProperty2, groupType, varargin)
%     display(varargin)
    
    cmap = varargin{1};
    sym = varargin{2};
    siz = varargin{3};
    doleg = varargin{4};
    if nargin >= 11 
        isCorr = varargin{5};
    else
        isCorr=0;
    end
    if nargin >= 12 
        subset = varargin{6};
    else
        subset = 'all';
    end
    
    prop1_array = 0;
    prop2_array = 0;
    
    for k = 1:length(mnName_cellarray)
        name = char(mnName_cellarray(k));
        mn = mns.(name);
        prop1 = mn.('properties').(propertyType).(nameProperty1);
        prop2 = mn.('properties').(propertyType).(nameProperty2);
        if nargin == 12 && strcmp(subset, 'branchPointsAndTerminations')
            indexes = or(mn.('properties').(propertyType).('isBranchPoint'), mn.('properties').(propertyType).('isTermination'));
%             indexes = logical(mn.('properties').(propertyType).('isTermination'));
            prop1 = prop1(indexes);
            prop2 = prop2(indexes);
        end
        prop1_array = [prop1_array; prop1];
        prop2_array = [prop2_array; prop2];
        
        if ~isCorr
            nameInGroup = mn.(groupType);
            groupCollection = cell(length(prop1), 1);
            for i=1:length(prop1)
                groupCollection(i) = cellstr(nameInGroup);
            end
            if k == 1
                groupCollection_array = groupCollection;
            elseif k > 1
                groupCollection_array = [groupCollection_array; groupCollection];
            end
        end
    end

    prop1_array = prop1_array(2:end);
    prop2_array = prop2_array(2:end);
    
    
    if ~isCorr
        h = gscatter(prop1_array, prop2_array, groupCollection_array, cmap, sym, siz, doleg);
    else
        [r,p] = corrcoef(prop1_array, prop2_array);
        str = sprintf('r = %.2f  p = %.2f', r(1,2), p(1,2));
        h_annotation = annotation('textbox', [0.17,0.88,0.1,0.1], 'EdgeColor', 'none', 'String', str, 'FontWeight', 'bold', 'FontSize', 11);
        groupCollection_array = ones(length(prop1_array), 1);
        h = gscatter(prop1_array, prop2_array, groupCollection_array, cmap, sym, siz, doleg);
        set(h_annotation, 'Position', get(gca, 'Position'));
    end
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    