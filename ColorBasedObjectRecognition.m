% Clear console and variables
clc;
clear;
close all;

% Load the uploaded image
image = imread('map2.jfif'); % Ensure the path is correct

% Convert image to double precision for processing
image = im2double(image);

% Convert the image from RGB to HSV color space
hsvImage = rgb2hsv(image);

% Define a cell array of color thresholds and labels
colors = {
    'North America', 0.25, 0.4, 0.2, 1.0, 0.2, 1.0;   % Green 
    'South America', 0.12, 0.18, 0.4, 1.0, 0.4, 1.0;  % Yellow
    'Europe', 0.05, 0.10, 0.4, 1.0, 0.4, 1.0;         % Orange
    'Africa', 0.95, 1.0, 0.4, 1.0, 0.4, 1.0;          % Red 
    'Asia', 0.55, 0.65, 0.4, 1.0, 0.4, 1.0;           % Blue
    'Australia', 0.70, 0.85, 0.4, 1.0, 0.4, 1.0;      % Purple
};

% Create a figure to display results
figure;

% Display the original image in the first subplot
subplot(1, 2, 1);
imshow(image);
title('Original Image');

% Display the segmented image in the second subplot
subplot(1, 2, 2);
imshow(image);
title('Image with Color Segmentation');
hold on;

% Loop through each color and segment the image
for i = 1:size(colors, 1)
    % Get the color thresholds
    label = colors{i, 1};
    channel1Min = colors{i, 2};
    channel1Max = colors{i, 3};
    channel2Min = colors{i, 4};
    channel2Max = colors{i, 5};
    channel3Min = colors{i, 6};
    channel3Max = colors{i, 7};
    
    % Create mask based on chosen histogram thresholds
    binaryMask = (hsvImage(:,:,1) >= channel1Min) & (hsvImage(:,:,1) <= channel1Max) & ...
                 (hsvImage(:,:,2) >= channel2Min) & (hsvImage(:,:,2) <= channel2Max) & ...
                 (hsvImage(:,:,3) >= channel3Min) & (hsvImage(:,:,3) <= channel3Max);

    % Use morphological operations to refine the segmentation
    binaryMask = imfill(binaryMask, 'holes');
    binaryMask = bwareaopen(binaryMask, 100);

    % Label connected components
    labeledImage = bwlabel(binaryMask);
    stats = regionprops(labeledImage, 'BoundingBox', 'Centroid');

    % Display bounding boxes and centroids
    for k = 1:length(stats)
        bbox = stats(k).BoundingBox;
        centroid = stats(k).Centroid;
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
        plot(centroid(1), centroid(2), 'b*');
        text(centroid(1) - 10, centroid(2) - 10, sprintf('%s', label), 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
    end
end

hold off;
