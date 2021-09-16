
function color =  getColor(cmap, V, Vmin, Vmax)

    if V <= Vmin
        index = 1;
    elseif V >= Vmax
        index = length(cmap);
    else
        slope = length(cmap)/(Vmax - Vmin);
        index = 1+floor((V-Vmin)*slope);
    end
    color = cmap(index, :);
end