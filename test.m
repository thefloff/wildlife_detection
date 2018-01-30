
img = imread('cropped_images/00002570.jpg');

% should also work with image arrays
class = classifyDCNN(img,'googlenet resized.mat');

% classes:
classIDToName = ["Dachs","Vogel","Wildschwein","Reh","Fuchs","Hase","Eichhörnchen","Hirsch","Rehbock"];
disp(['Class ', classIDToName(double(class(1)))]);