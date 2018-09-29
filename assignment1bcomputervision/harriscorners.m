function [ output_args ] = harriscorners(img )

B = imread(img);

%creating the approximation of diffrentation functions to detect change
%horizontaly and vertically a Perwitt filter is used.
%Alternatively a sobel filter can be used [-1 0 -1; -2 0 2; -1 0 1] to give
%the effect of being multiplied by the gaussian

dx = [-1 0 1; -1 0 1; -1 0 1]; 
dy = dx'                       

%the function convulsion convultes the matrix provided in the first slot
%with the matrix provide in the second slot. Using conv2 automaticaly
%detects the difference across the x and y access detecting vertical and
%horizontal lines respectively
Ix = conv2(single(B), single(dx), 'same');
Iy = conv2(single(B), single(dy), 'same');

%the following function creates a gaussian a sigma = 1.5 and a window size
%equivalent to 9. A large window size is used as our image is 900 x 900 pixels
% A smalle sigma is used to better detect edges and corners. 
g = fspecial ('gaussian', max(1, fix(6*1.5)),1.5);


% We build the harris matrix which is 
%[Ix.^2   Ix.Iy
% Ix.Iy   Iy.^2]
%using the values below we also convolute the following values with g to
%get the sum of products in the window 9*9 in this case.
Ix2 = conv2(single(Ix.^2), single(g), 'same');
Iy2 = conv2(single(Iy.^2), single(g), 'same');
Ixy = conv2(single(Ix.*Iy), single(g), 'same');

%since we want to both detect rotated corners as well as upright corners we
%must find the landa values of the harris function which are derived as
%follows using AX = landaX. Where A is the Harris function Then use
%the Det(A-landa)X = 0 to calculate the landas as follows. 
landa2 = (Ix2+ Iy2) -  sqrt ( 4*(Ixy.^2) + (Ix2-Iy2));
landa = (Ix2+ Iy2) +  sqrt ( 4*(Ixy.^2) + (Ix2-Iy2));


%Once we have the landa we calculate the corner response function as
%follows. If both landas are positive which is the case when we're at a
%corner the R will be positive otherwise it'll be negative or a lower
%number. Using a considerably large threshold we can thus identify the
%corners that way.
R = landa2.* landa - 0.02 * ((landa + landa2).^2);


%As the values of R are really big there are two ways to calculate the
%threshold. Thefirst way was todivide every element in R by the maximum
%value and multiply with 255 to get a grayscale image that is visible to
%the eye.

%Rintense = (R/max(R(:))).*255
%imshow(R);
%imshow(Rintense);

%This way a small threshold can be chosen will still manage to eliminate most of the
%edges and unimportant features.

%[coords300,newRintense1]=threshold4(Rintense, 1);
%imshow(newRintense1);

%After that a non-maximal suppression is run that using a dilution mask.
%The dilusion mask works by chosing the maximum value within a certain
%radius which is specified by the second element. This dilusion mask works
%by matching a grayscale image with the corner strength function R, a
%threshold of 2 is chosen to further limit the points that will be drawn on
%the diagram. The function below draws the points on the diagram.

%[r,c,rsubp,csubp]=nonmaxsuppts(newRintense1,5,2,B);

%The second function works by applying a really high value of R so that
%most of the unimportant features are cutoff. Since R's value is not within 255
%it cannot be plotted like R intense however, when applying the resulted R matrix to the 
%non-maximal suppression it still yeilds similar and even better results.
%The non-maximal suppression is tried with two different thresholds.
%The nonmaxsuppts has a function that allows you to take the original
%image, and draw the points over it. It achieves this by first calculating
%the coordinates by which non-maximal supression is achieved, calling
%imshow(B), using the function hold on so that the image is not lost when
%plotting the points and finally plotting the x y points which are the
%result of the R after threshold is applied, the nonmaxsuppts function and
%B.

[coords400,newR400]=threshold4(R, 40000000);
[r,c,rsubp,csubp]=nonmaxsuppts(newR400,5,50000000,B);
[r,c,rsubp,csubp]=nonmaxsuppts(newR400,5,60000000,B);

%A threshold of 1 is chosen if the R is normalized to 255 and a threshold
%of 40000000 is chosen otherwise. 

end

