current=cd;  % this corresponds to the current folder
myfolder=(fullfile(cd,'input')); %this is the folder where the images to be proccessed are.
cd(myfolder); %  Change current working directory.

name_of_the_image='img5.png'; % Please enter the name of the image you would like to process here

I = imread(name_of_the_image);

if (name_of_the_image== 'img1.png')
    fileID= 'loc1.txt';
elseif (name_of_the_image== 'img2.png')
    fileID= 'loc2.txt';
elseif (name_of_the_image== 'img3.png')
    fileID= 'loc3.txt';
elseif (name_of_the_image== 'img4.png')
    fileID= 'loc4.txt';
elseif (name_of_the_image== 'img5.png')
    fileID= 'loc5.txt';
end
formatSpec = '%f';
f = fopen(fileID,'r');
A = fscanf(f,formatSpec);
B=[transpose(A(1:20,1)); transpose(A(21:40,1))];
fclose('all');
cd(current); % back to the previous directory, where the other functions to be used for this task are
k = fspecial('gaussian', 9, 1);

assumedPSF=assumed_psf(B,k);

figure;
subplot(1,2,1);
plot(B(1,:),B(2,:))
title('GPS / IMU data')
subplot(1,2,2);
imagesc(assumedPSF);
colormap(gray); colorbar;
title('Assumed PSF');

% implementation of the RL deconv
img=zeros(size(I));
for n=1:3
    fft_image1=fft2(I(:,:,n));
    OTF = psf2otf(assumedPSF,size(fft_image1));
    u=fft_image1;
    for i=1:20
        temp=(fft_image1./(u .* OTF)) .* flip(OTF); % R-L deconvolution
        temp=ifft2(abs(temp));
        
        u=abs(ifft2(u));
        
        u= u .* temp;
        u=fft2(u);
    end
    img(:,:,n)=u;
end
%imshow(mat2gray(abs(ifftn(img))),[])

J=deconvlucy(I,assumedPSF);


figure;
subplot(1,2,1)
imshow(I)
title('Orginal (degraded) image')
subplot(1,2,2)
imshow(J)
title('Restored (R-L deconv.) Image')

% Wallis filter

for i=1:3
    outputImage = WallisFilter(J(:,:,i), 0.9*mean2(J(:,:,i)), 0.9*std2(J(:,:,i)),5, 0.1, 9, false);
    I(:,:,i)=outputImage;
end


figure;
subplot(1,2,1)
imshow(J)
title('Restored (R-L deconv.) Image')
subplot(1,2,2)
imshow(I)
title('Wallis filtered deconvolved image')

% texture Identification
% training phase and recognition phase
num=1;
if (name_of_the_image== 'img1.png')
    y_start=540;x_start=140; y_extend=50;x_extend=50;
    texture1=[x_start,y_start,x_extend,y_extend];
    y_start=350;x_start=360; y_extend=100;x_extend=95;
    texture2=[x_start,y_start,x_extend,y_extend];
    y_start=300;x_start=20; y_extend=100;x_extend=100;
    texture3=[x_start,y_start,x_extend,y_extend];
    img1_training={texture1,texture2,texture3};
elseif(name_of_the_image== 'img2.png')
    x_start=150;y_start=300; x_extend=100;y_extend=100;
    texture1=[x_start,y_start,x_extend,y_extend];
    x_start=620;y_start=440; x_extend=100;y_extend=100;  
    texture2=[x_start,y_start,x_extend,y_extend];
    x_start=350;y_start=230; x_extend=20;y_extend=70;   
    texture3=[x_start,y_start,x_extend,y_extend];
    img2_training={texture1,texture2,texture3};
elseif(name_of_the_image== 'img3.png')
    x_start=150;y_start=1; x_extend=100;y_extend=100; 
    texture1=[x_start,y_start,x_extend,y_extend];
    x_start=600;y_start=500; x_extend=100;y_extend=100; 
    texture2=[x_start,y_start,x_extend,y_extend];
    x_start=450;y_start=350; x_extend=100;y_extend=100;   
    texture3=[x_start,y_start,x_extend,y_extend];
    img3_training={texture1,texture2,texture3};
elseif(name_of_the_image== 'img4.png')
    x_start=200;y_start=30; x_extend=100;y_extend=100;  
    texture1=[x_start,y_start,x_extend,y_extend];
    x_start=460;y_start=80; x_extend=100;y_extend=100;  
    texture2=[x_start,y_start,x_extend,y_extend];
    x_start=120;y_start=460; x_extend=100;y_extend=100;  
    texture3=[x_start,y_start,x_extend,y_extend];
    img4_training={texture1,texture2,texture3};
elseif(name_of_the_image== 'img5.png')
    num=5;
    x_start=250;y_start=150; x_extend=100;y_extend=100;  
    texture1=[x_start,y_start,x_extend,y_extend];
    x_start=600;y_start=300; x_extend=100;y_extend=100; 
    texture2=[x_start,y_start,x_extend,y_extend];
    img5_training={texture1,texture2};
end

G=zeros(size(I,1),size(I,2));
V=G;



for i=1:3
    I_new=(I(:,:,i));
if(num==1)
    T1=imcrop(I_new,texture1);
    T2=imcrop(I_new,texture2);
    T3=imcrop(I_new,texture3);
    T_cell = {T1, T2, T3};
else
    T1=imcrop(I_new,texture1);
    T2=imcrop(I_new,texture2);
    T_cell = {T1, T2};
end
MODEL = training_phase(T_cell);


GUESS = recognition_phase(I_new, MODEL);
VOTED = majority_voting(GUESS, 5);
G=G+GUESS;
V=V+VOTED;
end

% GUESS=floor(G/3);
% VOTED=floor(V/3);



figure;
imagesc(VOTED)
title('Segmented terrain image')
