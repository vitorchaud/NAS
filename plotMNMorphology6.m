

function [output_struct] = plotMNMorphology6 (ctrlParams_struct, morphologicProp_struct, simVariables_struct, isAnimation)
    
    numOfSegments       = morphologicProp_struct.('numOfSegments');
    type                    = morphologicProp_struct.('data').('local').('type');
    parent                  = morphologicProp_struct.('data').('local').('parent');
    childs_cellarray        = morphologicProp_struct.('data').('local').('childs_cellarray');
    x                       = morphologicProp_struct.('data').('local').('x');
    y                       = morphologicProp_struct.('data').('local').('y');
    z                       = morphologicProp_struct.('data').('local').('z');
    radius                  = morphologicProp_struct.('data').('local').('radius');
    proximal_position_x     = morphologicProp_struct.('data').('local').('proximal_position_x');
    proximal_position_y     = morphologicProp_struct.('data').('local').('proximal_position_y');
    proximal_position_z     = morphologicProp_struct.('data').('local').('proximal_position_z');
    
    
    geometryType   = ctrlParams_struct.('geometryType');
    
    if isAnimation
    
        isFirstShot             = ctrlParams_struct.('isFirstShot');
        figureFileName          = ctrlParams_struct.('figureFileName');
        animationFileName       = ctrlParams_struct.('animationFileName');
        isAnimation             = ctrlParams_struct.('isAnimation');
        isInsideSimulation      = ctrlParams_struct.('isInsideSimulation');
        isInsideCompIteration   = ctrlParams_struct.('isInsideCompIteration');
        

        elevation       = simVariables_struct.('elevation');
        azimute         = simVariables_struct.('azimute');
        frameCount      = simVariables_struct.('frameCount');  
        sectionIndexes  = simVariables_struct.('sectionIndexes');
        upperAxes       = simVariables_struct.('upperAxes');
        surface_handle  = simVariables_struct.('surface_handle');   
        annotation_handle  = simVariables_struct.('annotation_handle');  
        V               = simVariables_struct.('V');
        indexOfTimeArray  = simVariables_struct.('indexOfTimeArray');
        timeArray       = simVariables_struct.('timeArray');
        VsArray         = simVariables_struct.('VsArray');  
        IArray          = simVariables_struct.('IArray');  
               
    else
        isFirstShot             = ctrlParams_struct.('isFirstShot');
        sectionIndexes  = simVariables_struct.('sectionIndexes');
        figureFileName          = ctrlParams_struct.('figureFileName');
    end
    
    
    
    % Defining RGB colors
    darkOrange = [0.87, 0.49, 0.0];
    darkGreen = [0.17, 0.51, 0.34];
    darkBlue = [0.08, 0.17, 0.55];
    darkRed = [0.85, 0.16, 0.0];
    darkPurple = [0.48, 0.06, 0.89];
    gray = [0.5, 0.5, 0.5];

    cmap = colormap('hot');
    Vmin = -70;
    Vmax = 70;

   

    visualizationBoxLength = 0;
    
    
    
    for i = 1:numOfSegments
        
        if type(i)==1 && parent(i)==1 %% Skip false compartments
            continue;
        end
        
        if(isFirstShot)
        
            compartment_pos_x = x(i);
            compartment_pos_y = y(i);
            compartment_pos_z = z(i);

            if(type(i) == 1)
                [Xs,Ys,Zs] = sphere(20); % Compartment is soma
                surface_handle(i) = surf(radius(i)*(Xs),radius(i)*(Ys),radius(i)*(Zs));
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
                
                dx = compartment_pos_x - proximal_position_x(i);
                dy = compartment_pos_y - proximal_position_y(i);
                dz = compartment_pos_z - proximal_position_z(i);

                d = sqrt(dx^2 + dy^2 + dz^2);

                % ortogonal vector
                vx = d*dy;
                vy = -d*dx;

                angle = -(180/pi) * acos(dz/d) + 180;

                if strcmp(geometryType, 'cylinder')
                    [X,Y,Z] = cylinder(radius(i), 30);
                elseif strcmp(geometryType, 'frustum')
                    [X,Y,Z] = cylinder([radius(i) radius(parent(i))], 30);
                end
                surface_handle(i) = surf((X + compartment_pos_x),(Y + compartment_pos_y),(d*Z + compartment_pos_z));
                rotate(surface_handle(i), [vx vy 0], angle, [compartment_pos_x, compartment_pos_y, compartment_pos_z]);
                
            end
            
            
        else
            if(isAnimation && isInsideCompIteration && sectionIndexes(i))
                color = getColor(cmap, V(i), Vmin, Vmax);
                set(surface_handle(i),'FaceColor', color,'EdgeColor', color,'FaceAlpha',0.7);
                
            end
            
        end
        
        if(~isAnimation)
            if(sectionIndexes(i))
                set(surface_handle(i),'FaceColor',darkOrange,'FaceAlpha',0.7);
            else
                set(surface_handle(i),'FaceColor',darkPurple,'FaceAlpha',0.7);
            end
        end
        
        hold on
    end
    
    
    if(isFirstShot)            
        upperAxes = gca;
        axis square
        visualizationBoxLength = 200;
        xlim([-visualizationBoxLength visualizationBoxLength]);
        ylim([-visualizationBoxLength visualizationBoxLength]);
        zlim([-visualizationBoxLength visualizationBoxLength]);
        xlabel('x');
        ylabel('y');
        zlabel('z');
        
        if isAnimation
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind,cm,animationFileName,'gif', 'Loopcount',inf,'DelayTime',0.1);
        else
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind,cm,figureFileName,'png');
        end
        
    end
    
    
    if(isAnimation  && ~isInsideCompIteration  && isInsideSimulation)
        
        set(gcf, 'currentaxes', upperAxes);
        
        str = sprintf('frame = %d', frameCount);
        set(annotation_handle, 'String', str);
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        
        colorbar()
        caxis([Vmin,Vmax])
        
        
        view(upperAxes, azimute, elevation);

        subplot(5,1,4);
        p1 = plot(timeArray(1:indexOfTimeArray), VsArray(1:indexOfTimeArray));
        set(p1, 'LineWidth', 3, 'Color', darkPurple);
        h = ylabel('V_{S}');
        set(h, 'FontSize', 11);
        
        subplot(5,1,5);
        p2 = plot(timeArray(1:indexOfTimeArray), IArray(1:indexOfTimeArray));
        set(p2, 'LineWidth', 3, 'Color', darkPurple);
        h = xlabel('Time (ms)');
        set(h, 'FontSize', 11);
        h = ylabel('i_{inj}');
        set(h, 'FontSize', 11);

        imwrite(imind,cm,animationFileName,'gif','WriteMode','append','DelayTime',0.1);
        drawnow;
    end

    
    
    output_struct.('upperAxes') = upperAxes;
    output_struct.('surface_handle') = surface_handle;

    
    
    
end



