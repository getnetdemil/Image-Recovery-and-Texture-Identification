function ClassMap = recognition_phase(I, MODEL)
  
 dim=size(I);
 ClassMap=zeros(dim);
 N = (1/(15*15)) * ones(15);
 
 h = dim(1);
 w = dim(2);    
 BB = [];
    
    for k = 1:9
        B = conv2(I, laws_kernel(k), 'same');
        B_new = conv2(B.^2, N, 'same');
        BB = cat(3,BB,B_new);
    end
    
    for x = 1:h
        for y = 1:w
            sum_abs_diff = zeros(1,size(MODEL, 1));
            %difference=zeros(1,size(MODEL, 2));
            for n = 1:size(MODEL,1)
                difference=zeros(1,size(MODEL, 2));
                for a=1:size(BB,3)
                    difference(a) = abs(BB(x,y,a) -  MODEL(n,a));
                end
                sum_abs_diff(n) = sum(difference);
            end
            [~, index] = min(sum_abs_diff);
            ClassMap(x,y) = index;
        end
    end 

end
