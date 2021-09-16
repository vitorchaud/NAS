

function [upperAxes, surface_handle, visualizationBoxLength] = plotStaticMNMorphology3 ( morphologicProp_struct, d_min, d_max, azimute, elevation, baseColor, sectionColor,...
                                                                    figureFileName, geometryType, distanceMetric, isShowSectionOnly, isColoredTrees, showOnlyTree)

    
    numOfSegments = morphologicProp_struct.('numOfSegments');
    type = morphologicProp_struct.('data').('local').('type');
    parent = morphologicProp_struct.('data').('local').('parent');
    radius = morphologicProp_struct.('data').('local').('radius');
    x = morphologicProp_struct.('data').('local').('x');
    y = morphologicProp_struct.('data').('local').('y');
    z = morphologicProp_struct.('data').('local').('z');
    
    proximal_position_x = morphologicProp_struct.('data').('local').('proximal_position_x');
    proximal_position_y = morphologicProp_struct.('data').('local').('proximal_position_y');
    proximal_position_z = morphologicProp_struct.('data').('local').('proximal_position_z');
    
    sectionIndexes =  getCompartmentIndexesBySection5(morphologicProp_struct, d_min, d_max, 0, distanceMetric);
    
    if isColoredTrees
        zeroOrderSegments = morphologicProp_struct.('data').('zeroOrderSegments');
        stemParent = morphologicProp_struct.('data').('local').('stemParent');
        cmap = hsv(length(zeroOrderSegments));
    end
    
    visualizationBoxLength = 0;
    
    
    for i = 1:numOfSegments
        
        if type(i)==1 && parent(i)==1 %% Skip false compartments
            continue;
        end
        
        if isShowSectionOnly && ~sectionIndexes(i)
            continue;
        end
        
        
        compartment_pos_x = x(i);
        compartment_pos_y = y(i);
        compartment_pos_z = z(i);

        if(type(i) == 1)
            [Xs,Ys,Zs] = sphere(20); % Compartment is soma
            surface_handle(i) = surf(radius(i)*Xs + compartment_pos_x, radius(i)*Ys + compartment_pos_y, radius(i)*Zs + compartment_pos_z);
            set(surface_handle(i),'FaceColor',[1 0 0],'FaceAlpha',0.5);
            hold on;
        else

            if(abs(compartment_pos_x) > visualizationBoxLength)
                visualizationBoxLength = abs(compartment_pos_x);
            end
            if(abs(compartment_pos_y) > visualizationBoxLength)
                visualizationBoxLength = abs(compartment_pos_y);
            end
            if(abs(compartment_pos_z) > visualizationBoxLength)
                visualizationBoxLength = abs(compartment_pos_z);
            end
            
            if strcmp(geometryType, 'lines')
                hl = plot3([proximal_position_x(i) compartment_pos_x],...
                    [proximal_position_y(i) compartment_pos_y],...
                    [proximal_position_z(i) compartment_pos_z]);
                set(hl, 'Color', [0.039, 0.039, 0.498]);
            else
                dx = compartment_pos_x - proximal_position_x(i);
                dy = compartment_pos_y - proximal_position_y(i);
                dz = compartment_pos_z - proximal_position_z(i);

                d = sqrt(dx^2 + dy^2 + dz^2);

                % orthogonal vector
                vx = d*dy;
                vy = -d*dx;

                angle = -(180/pi) * acos(dz/d) + 180;

                if strcmp(geometryType, 'cylinder')
                    [X,Y,Z] = cylinder(radius(i), 10);
                end
                if strcmp(geometryType, 'frustum')
                    [X,Y,Z] = cylinder([radius(i) radius(parent(i))], 10);
                end

                surface_handle(i) = surf((X + compartment_pos_x),(Y + compartment_pos_y),(d*Z + compartment_pos_z));
                rotate(surface_handle(i), [vx vy 0], angle, [compartment_pos_x, compartment_pos_y, compartment_pos_z]);
            end
        end
        
        if ~strcmp(geometryType, 'lines')
            set(surface_handle(i),'FaceColor',baseColor,'EdgeColor', baseColor,'FaceAlpha',0.7);
        end
        
        if isColoredTrees
            if type(i)==1
                color=[0,0,0];
            else
                if nnz(zeroOrderSegments == stemParent(i))
                    color = cmap(zeroOrderSegments == stemParent(i),:);
                else
                    color = [1 0 0]; % in case the tree was excluded
                end
            end
            set(surface_handle(i),'FaceColor',color,'EdgeColor', color,'FaceAlpha',0.8,'EdgeAlpha',0.8);
        end
        if showOnlyTree
            if zeroOrderSegments(showOnlyTree) == stemParent(i)
                set(surface_handle(i),'FaceColor',color,'EdgeColor', color,'FaceAlpha',0.8,'EdgeAlpha',0.8);
            else
                set(surface_handle(i),'FaceColor',color,'EdgeColor', color,'FaceAlpha',0.005,'EdgeAlpha',0.005);
            end
        end
        
        if isShowSectionOnly
            if(sectionIndexes(i))
                set(surface_handle(i),'FaceColor',sectionColor,'EdgeColor', sectionColor,'FaceAlpha',0.2);
            end
        end
        
        
        hold on
    end
    
    
    upperAxes = gca;
    axis square
%     visualizationBoxLength = d_max;
    xlim([-visualizationBoxLength visualizationBoxLength]);
    ylim([-visualizationBoxLength visualizationBoxLength]);
    zlim([-visualizationBoxLength visualizationBoxLength]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    view(azimute, elevation);

%     frame = getframe(gcf);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
%     imwrite(imind,cm,figureFileName,'png');
    
    

    
end



