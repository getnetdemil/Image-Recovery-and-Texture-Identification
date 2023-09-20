function J=assumed_psf(B,k)

X=B(1,:); Y=B(2,:);
max_x=max(X); % storing max value of X
max_y=max(Y); % storing max value of Y
H=zeros(max_y+1,max_x+1);

[kxlim,kylim]=size(k);
H=padarray(H,[floor(kxlim/2),floor(kylim/2)],0,'both'); % padding the matrix H with 0 on the boundary.


C=X;X=Y;Y=C;
for i=1:size(B,2)
    row1 = X(i)+floor(kxlim/2)+1;
    column1 = Y(i)+floor(kylim/2)+1;
    row2 = row1+floor(kxlim/2);
    column2 = column1+floor(kylim/2);
    temp=H(row1-floor(kxlim/2):row2,column1-floor(kylim/2):column2);
    H(row1-floor(kxlim/2):row2,column1-floor(kylim/2):column2)= k+temp;
    
end



matsum=sum(H,"all");  % normalize the H matrix

for i=1:size(H,1)
    for j=1:size(H,2)
        H(i,j)= H(i,j)/matsum;
    end
end




J=flip(H);





end