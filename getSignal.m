

function signal = getSignal(name, initialTime, finalTime, initialValue, finalValue, t, varargin)
    
    if strcmp(name, 'trapezoid')
        
        changeTime1 = varargin{1};
        changeTime2 = varargin{2};
        
        angularCoef1 = (finalValue-initialValue)/(changeTime1-initialTime);
        angularCoef2 = (finalValue-initialValue)/(finalTime-changeTime2);
        
        if t <= initialTime
            signal = initialValue;
        elseif t<= changeTime1
            signal = initialValue + angularCoef1*(t-initialTime);
        elseif t <= changeTime2
            signal = finalValue;
        elseif t <= finalTime
            signal = finalValue - angularCoef2*(t-changeTime2);
        else
            signal = initialValue;
        end
    end