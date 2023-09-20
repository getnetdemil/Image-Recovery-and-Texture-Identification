function H = laws_kernel(k)

    if not (1 <= k && k <= 9)
        error("Invalid argument: k");
    end
    
    L = 1/6 * [1; 2; 1];
    E = 1/2 * [1; 0; -1];
    S = 1/2 * [1; -2; 1];
    
    if k == 1
        H = L * L';
    elseif k == 2
        H = L * E';
    elseif k == 3
        H = L * S';
    elseif k == 4
        H = E * L';
    elseif k == 5
        H = E * E';
    elseif k == 6
        H = E * S';
    elseif k == 7
        H = S * L';
    elseif k == 8
        H = S * E';
    elseif k == 9
        H = S * S';
    end
    
               
end
