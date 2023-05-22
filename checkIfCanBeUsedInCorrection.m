function [oneIsYes] = checkIfCanBeUsedInCorrection(realVal,synVal)
%Sprawdza czy dana próbka mo¿e zostaæ u¿yta w syntezie

if(synVal(1)==0 && synVal(2)==0 && synVal(3)==0)
    oneIsYes = 0;
else
    if(abs(realVal(1) - synVal(1)) < 10 && abs(realVal(2) - synVal(2)) < 10 && abs(realVal(3) - synVal(3)) < 10)
        oneIsYes = 1;
    else
        oneIsYes = 0;
    end
end

% Ró¿nica g³êbi 2560
end

