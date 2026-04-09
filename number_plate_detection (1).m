clc;
clear all;
close all;
im=imread("car.jpg");
imshow(im);
[imgHeight, imgWidth, ~] = size(im);
title('Original Image')
b = imsharpen(im);
imshow(b);
title('Sharpened Image');
grayIm = rgb2gray(b);
imshow(grayIm);
title('Grayscale Image');
e=adapthisteq(grayIm);
imshow(e);
title('sharpened image')
t=adaptthresh(e,0.75);
f = imbinarize(e,t);
h=bwareaopen(f,500);
cc = bwconncomp (h);
stats = regionprops(cc, 'Area', 'BoundingBox');
minasratio=2.2;
maxasratio=8.0;
verticalCutoff = imgHeight/2;
minPlateWidth = 100;
minPlateHeight = 40;
for i = 1:numel(stats)
    bbox = stats(i). BoundingBox;
    width = bbox(3);
    height = bbox(4);
    aspectratio = width/height;
    area = stats(i). Area;
    objectCenterY = bbox(2) + height/ 2;
    conditions=[aspectratio >= minasratio
        aspectratio <= maxasratio
        area > 1500
        width >= minPlateWidth
        height >= minPlateHeight
        objectCenterY >= verticalCutoff
        ];
    if all(conditions)
        rect = round (bbox);
        plate = imcrop(im,rect);
        imshow(plate);
        k=rgb2gray(plate);
        edges = edge(k, 'canny');
        imshow(edges);
        title('Edge Detected Image');
    end
end

results=ocr(k);
number=strtrim(results.Text); 
disp("Number plate:"+number);