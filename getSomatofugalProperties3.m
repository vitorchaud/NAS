


function somatofugalProperties = getSomatofugalProperties3 (mn_struct, parameters, metric, onlyTree, onlyBranch)
    
    somatofugalParams = parameters.somatofugalParams;

    indexesOfBranchPoints = mn_struct.('data').('local').('isBranchPoint');
    indexesOfTerminations = mn_struct.('data').('local').('isTermination');
    
    if onlyTree
        zeroOrderSegments = mn_struct.('data').('zeroOrderSegments');
        stemParent = mn_struct.('data').('local').('stemParent');
        indexesTree = zeroOrderSegments(onlyTree) == stemParent;
    end
    if onlyBranch
        branch = mn_struct.('data').('local').('branch');
        indexesBranch = onlyBranch == branch;
    end
    
    if strcmp(metric, 'euclidian')  ||  strcmp(metric, 'path')
        localPropNames = parameters.('featureNames').('local').('morphological');
        for i = 1:length(localPropNames)
            name = char(localPropNames(i));
            prop = mn_struct.('data').('local').(name);
            
            count = 1;

            for d = 0 : somatofugalParams.('step') : somatofugalParams.('finalDistance')-somatofugalParams.('step')
                indexes = getCompartmentIndexesBySection5(mn_struct, d, d+somatofugalParams.('step'), 0, metric);

                if onlyTree
                    indexes = and(indexes, indexesTree);
                end
                if onlyBranch
                    indexes = and(indexes, indexesBranch);
                end
                indexes = and(indexes, or(indexesOfBranchPoints, indexesOfTerminations));

                if ~isempty(indexes)
                    somatofugalProperties.(name){count} = prop(indexes);
                end
                count = count + 1;
            end
        end
        
        
        localPropNames = parameters.('featureNames').('local').('electronic');
        for i = 1:length(localPropNames)
            name = char(localPropNames(i));
            prop = mn_struct.('data').('local').(name);
            
            % Considering only w specified by indexOfSampleFreq
            prop = prop(:,parameters.indexOfSampleFreq);

            count = 1;
            for d = 0 : somatofugalParams.('step') : somatofugalParams.('finalDistance')-somatofugalParams.('step')
                indexes = getCompartmentIndexesBySection5(mn_struct, d, d+somatofugalParams.('step'), 0, metric);

                if onlyTree
                    indexes = and(indexes, indexesTree);
                end
                if onlyBranch
                    indexes = and(indexes, indexesBranch);
                end
                indexes = and(indexes, or(indexesOfBranchPoints, indexesOfTerminations));

                if ~isempty(indexes)
                    somatofugalProperties.(name){count} = prop(indexes);
                end
                count = count + 1;
            end
        end
        
        
        % calculating additional properties which do not depend on segment
        % sizes
        
        area = mn_struct.('data').('local').('area');
        
        count = 1;
        for d = 0 : somatofugalParams.('step') : somatofugalParams.('finalDistance')-somatofugalParams.('step')
            indexes = getCompartmentIndexesBySection5(mn_struct, d, d+somatofugalParams.('step'), 0, metric);
            indexesInShell = getIndexesOfBranchesInAShell3(mn_struct, d+somatofugalParams.('step'), metric);
            if onlyTree ~= 0
                indexes = and(indexes, indexesTree);
                indexesInShell = and(indexesInShell, indexesTree);
            end
            if ~isempty(logical(indexes))
                
                somatofugalProperties.('areaInPath'){count} = sum(area(logical(indexes)));
                somatofugalProperties.('cumArea'){count} = sum(cell2mat(somatofugalProperties.('areaInPath')));
                somatofugalProperties.('numOfBranchPoints'){count} = nnz(somatofugalProperties.('isBranchPoint'){count});
                somatofugalProperties.('cumNumOfBranchPoints'){count} = sum(cell2mat(somatofugalProperties.('numOfBranchPoints')));
                somatofugalProperties.('numOfTerminations'){count} = nnz(somatofugalProperties.('isTermination'){count});
                somatofugalProperties.('cumNumOfTerminations'){count} = sum(cell2mat(somatofugalProperties.('numOfTerminations')));
                somatofugalProperties.('cumNumOfDendSegments'){count} = somatofugalProperties.('cumNumOfBranchPoints'){count} + ...
                                                                        somatofugalProperties.('cumNumOfTerminations'){count};
                somatofugalProperties.('numOfBranchesInShell'){count} = nnz(indexesInShell);
                                
            end
            count = count + 1;
        end
        
    elseif strcmp(metric, 'order')
        order = mn_struct.('data').('local').('order');
        max_order = max(order);
        localPropNames = parameters.('featureNames').('local').('morphological');
        for i = 1:length(localPropNames)
            name = char(localPropNames(i));
            prop = mn_struct.('data').('local').(name);

            count = 1;

            for j = 0:max_order
                indexes = getCompartmentIndexesBySection5(mn_struct, 0, 0, j, metric);
                if onlyTree
                    indexes = and(indexes, indexesTree);
                end
                if onlyBranch
                    indexes = and(indexes, indexesBranch);
                end
                indexes = and(indexes, or(indexesOfBranchPoints, indexesOfTerminations));

                if ~isempty(indexes)
                    somatofugalProperties.(name){count} = prop(indexes);
                end
                count = count + 1;
            end
        end
        
        
        localPropNames = parameters.('featureNames').('local').('electronic');
        for i = 1:length(localPropNames)
            name = char(localPropNames(i));
            prop = mn_struct.('data').('local').(name);
            
            prop = prop(:,parameters.indexOfSampleFreq);

            count = 1;
            for d = 0 : somatofugalParams.('step') : somatofugalParams.('finalDistance')-somatofugalParams.('step')
                indexes = getCompartmentIndexesBySection5(mn_struct, d, d+somatofugalParams.('step'), 0, metric);
                
                if onlyTree
                    indexes = and(indexes, indexesTree);
                end
                if onlyBranch
                    indexes = and(indexes, indexesBranch);
                end
                indexes = and(indexes, or(indexesOfBranchPoints, indexesOfTerminations));

                if ~isempty(indexes)
                    somatofugalProperties.(name){count} = prop(indexes);
                end
                count = count + 1;
            end
        end
        
        % calculating additional properties which do not depend on segment
        % sizes
        
        area = mn_struct.('data').('local').('area');
%         radius = mn_struct.('data').('local').('radius');
        
        count = 1;
        for j = 0:max_order
            indexes = getCompartmentIndexesBySection5(mn_struct, 0, 0, j, metric);
            indexesInShell = getCompartmentIndexesBySection5(mn_struct, 0, 0, j, metric);
            if onlyTree ~= 0
                indexes = and(indexes, indexesTree);
                indexesInShell = and(indexesInShell, indexesTree);
            end
            if ~isempty(logical(indexes))
                
                somatofugalProperties.('areaInPath'){count} = sum(area(logical(indexes)));
                somatofugalProperties.('cumArea'){count} = sum(cell2mat(somatofugalProperties.('areaInPath')));
                somatofugalProperties.('numOfBranchPoints'){count} = nnz(somatofugalProperties.('isBranchPoint'){count});
                somatofugalProperties.('cumNumOfBranchPoints'){count} = sum(cell2mat(somatofugalProperties.('numOfBranchPoints')));
                somatofugalProperties.('numOfTerminations'){count} = nnz(somatofugalProperties.('isTermination'){count});
                somatofugalProperties.('cumNumOfTerminations'){count} = sum(cell2mat(somatofugalProperties.('numOfTerminations')));
%                 somatofugalProperties.('diameter'){count} = 2*radius(logical(indexes));
                somatofugalProperties.('cumNumOfDendSegments'){count} = somatofugalProperties.('cumNumOfBranchPoints'){count} + ...
                                                                        somatofugalProperties.('cumNumOfTerminations'){count};
                somatofugalProperties.('numOfBranchesInShell'){count} = nnz(indexesInShell);
                
            end
            count = count + 1;
        end
        
    end
end
    
    
    
    
    
    
    
    
    
    
    