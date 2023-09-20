function outputImage = WallisFilter(inputImage, desiredMean, desiredStdDev, Amax, percentage, windowWidth, preSmooth)
outputImage = []; % Initialize
% Making sure the window width is odd.  If it's not, add 1 to make it odd.
if mod(windowWidth, 2) == 0
		windowWidth = windowWidth+1;
end
% Get a double copy of the image.
dblImage = double(inputImage); % Cast to double from whatever it is on input.

% Optionally, smooth the image with a gaussian blur beforehand, if specified.
if preSmooth
	gauss_blur = fspecial('gaussian', windowWidth, 1);
	dblImage = conv2(dblImage, gauss_blur, 'same');
end

% Make an image of all ones the same size as the input image.
uniformImage = ones(size(dblImage));
% Make a convolution kernel of all ones to integrate the gray level within the window.
kernel = ones(windowWidth);
% Make a new image where pixel value is the sum of gray levels within the sliding window.
sumImage = conv2(dblImage, kernel, 'same');
% Make a new image where pixel value is the COUNT of pixels within the sliding window.  Will be smaller near the edges of the image.
countImage = conv2(uniformImage, kernel, 'same');

% Get the sliding mean image.
localMeanImage = sumImage ./ countImage;
% Compute the variance image = <(x-xBar).^2> 
D = conv2((dblImage - localMeanImage).^2, kernel, 'same') / (windowWidth^2);
% Compute local standard deviation by taking the square root of the variance image.
D = sqrt(D);

% Apply the Wallis formula scaling.
G = (dblImage - localMeanImage) .* Amax .* desiredStdDev ./ (Amax .* D + desiredStdDev) + percentage * desiredMean + (1-percentage) * localMeanImage;

% Clip values.
%  image should not be less than 0.
G(G < 0) = 0;
% image should not be more than the max.
maxPossibleGrayLevel = intmax(class(inputImage));
G(G > maxPossibleGrayLevel) = maxPossibleGrayLevel;

% Cast back to the same class as the input image.
outputImage = cast(G, 'like', inputImage);
end
