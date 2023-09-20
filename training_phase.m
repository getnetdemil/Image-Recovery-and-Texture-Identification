function MODEL = training_phase(T_cell)
dim=size(T_cell);
N=dim(2);
MODEL = zeros(N, 9);
    
    
     for n = 1:N
        for k = 1:9
            A = conv2(T_cell{n}, laws_kernel(k), 'same');
            h = size(T_cell{n},1);
            w = size(T_cell{n},2);
            sum = 0;
            for x = 1:h
                for y = 1:w  
                    sum = sum + A(x,y)^2;
                end
            end
            MODEL(n, k) = (1 / (h * w)) * sum;
        end
    end
    
end
