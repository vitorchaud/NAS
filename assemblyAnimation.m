

function assemblyAnimation (morphologicProp_struct, simVariables_struct, animationFileName)
    

    fig1 = figure(1);
    set(fig1, 'OuterPosition', [100, 50, 800, 800])
    whitebg(fig1, 'w')
    
    set(gcf,'paperunits','centimeters')
    set(gcf,'papersize',[16,16])
    set(gcf,'paperposition',[0,0,16,16])
    
    numOfSegments       = morphologicProp_struct.('numOfSegments');
    type                    = morphologicProp_struct.('data').('local').('type');
    parent                  = morphologicProp_struct.('data').('local').('parent');
    x                       = morphologicProp_struct.('data').('local').('x');
    y                       = morphologicProp_struct.('data').('local').('y');
    z                       = morphologicProp_struct.('data').('local').('z');
    radius                  = morphologicProp_struct.('data').('local').('radius');
    proximal_position_x     = morphologicProp_struct.('data').('local').('proximal_position_x');
    proximal_position_y     = morphologicProp_struct.('data').('local').('proximal_position_y');
    proximal_position_z     = morphologicProp_struct.('data').('local').('proximal_position_z');
    
    elevation       = simVariables_struct.('elevation');
    azimute         = simVariables_struct.('azimute');
    
    geometryType = 'frustum';
    
    frameCount = 0;
    visualizationBoxLength = radius(1);
    
    for i = 1:numOfSegments

        if(type(i) == 1 && parent(i) == 1) % skiping compartments 2 and 3, used only to tell that soma is spherical
            continue;
        end
        frameCount = frameCount + 1;
        azimute = azimute + 1;
        
        
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

        view(azimute, elevation);
        
        visualizationBoxLength = 1000;
        xlim([-visualizationBoxLength visualizationBoxLength]);
        ylim([-visualizationBoxLength visualizationBoxLength]);
        zlim([-visualizationBoxLength visualizationBoxLength]);
        
        set(gca, 'Position', [0, 0, 1, 1]);
        
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,1028);
        if i==1
            imwrite(imind, cm, animationFileName,'gif', 'Loopcount',inf,'DelayTime',0.03);
        else
            imwrite(imind, cm, animationFileName,'gif','WriteMode','append','DelayTime',0.03);
        end
        axis off
        drawnow;
        
        
    end
    
    

end