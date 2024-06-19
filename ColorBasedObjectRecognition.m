% Clear console and variables
clc;
clear;
close all;

% Load the uploaded image
image = imread('map.jpg'); % Replace with your image file

% Step 1: Convert the image from RGB to HSV color space
hsvImage = rgb2hsv(image);

% Define a cell array of color thresholds and labels
colors = {
    'North America', 0.25, 0.4, 0.2, 1.0, 0.2, 1.0;
    'South America', 0.25, 0.4, 0.2, 1.0, 0.2, 1.0;
    'Europe', 0.12, 0.18, 0.5, 1.0, 0.5, 1.0;
    'Africa', 0.55, 0.75, 0.2, 1.0, 0.2, 1.0;
    'Asia', 0.75, 0.85, 0.2, 1.0, 0.2, 1.0;
    'Australia', 0.25, 0.4, 0.2, 1.0, 0.2, 1.0;
    'China', 0.0, 0.1, 0.5, 1.0, 0.5, 1.0;
    'India', 0.08, 0.12, 0.5, 1.0, 0.5, 1.0;
};

% Create a figure to display results
figure;
imshow(image);
title('Original Image');
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

    % Step 3: Use morphological operations to refine the segmentation
    % Fill holes in the binary mask
    binaryMask = imfill(binaryMask, 'holes');

    % Remove small objects from the binary mask
    binaryMask = bwareaopen(binaryMask, 100);

    % Step 4: Display and label the segmented objects
    % Label connected components
    labeledImage = bwlabel(binaryMask);
    stats = regionprops(labeledImage, 'BoundingBox', 'Centroid');

    % Display bounding boxes and centroids
    for k = 1:length(stats)
        % Get the bounding box
        bbox = stats(k).BoundingBox;
        % Draw the bounding box
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);

        % Get the centroid
        centroid = stats(k).Centroid;
        % Display the centroid
        plot(centroid(1), centroid(2), 'b*');

        % Label the object
        text(centroid(1) - 10, centroid(2) - 10, sprintf('%s', label), 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
    end
end

hold off;
