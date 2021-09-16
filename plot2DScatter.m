function h = plot2DScatter( x1, x2, group_array, sym, siz, cmap)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    
    groupCollection_array_reduced = eliminateRepetitiveStringsFromCellarray(group_array);
    
    for i = 1:length(groupCollection_array_reduced)
        
        x1_grp = x1(ismember(group_array, groupCollection_array_reduced(i)));
        x2_grp = x2(ismember(group_array, groupCollection_array_reduced(i)));
        
        h = plot(x1_grp, x2_grp, 'lineStyle', 'none', 'Marker', sym, 'MarkerSize', siz, 'Color', cmap(i,:));
        hold on;
    end
    
end

