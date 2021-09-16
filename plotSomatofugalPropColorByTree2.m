

function plotSomatofugalPropColorByTree2 (mnProperties, parameters, metric, propName, sym, siz, cmap, showOnlyTree, yScaleFactor)
    
    zeroOrderSegments = mnProperties.data.zeroOrderSegments;
    
    somatofugalProp = [];
    group_array = {};
    x = [];
    
    if showOnlyTree
        somatof = getSomatofugalProperties (mnProperties, parameters, metric, showOnlyTree);
        b = somatof.(propName);
        aux = 0;
        for j = 1:length(b)
            aux = aux + parameters.somatofugalParams.step;
            somatofugalProp = [somatofugalProp; b{j}];
            for k = 1:length(b{j})
                x = [x; aux];
                group_array = [group_array; num2str(showOnlyTree)];
            end
        end
        h = plot(x, yScaleFactor .* somatofugalProp, 'lineStyle', 'none', 'Marker', sym, 'MarkerSize', siz, 'Color', cmap(showOnlyTree,:));
        
    else
        for i = 1:length(zeroOrderSegments)

            somatof = getSomatofugalProperties3 (mnProperties, parameters, metric, i, 0);
            b = somatof.(propName);
            aux = 0;

            for j = 1:length(b)
                aux = aux + parameters.somatofugalParams.step;
                somatofugalProp = [somatofugalProp; b{j}];
                for k = 1:length(b{j})
                    x = [x; aux];
                    group_array = [group_array; num2str(i)];
                end
            end

        end
        plot2DScatter( x, yScaleFactor .* somatofugalProp, group_array, sym, siz, cmap);
    end
    
    
    
end