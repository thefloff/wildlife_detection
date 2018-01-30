path = '..\data\1.57-Red_Deer\SEQ76275';
%path = '..\data\1.57-Red_Deer\SEQ76431';
imgPath = '..\data\1.57-Red_Deer\SEQ76431\SEQ76431_IMG_0003.JPG';
visualize = 1;
cutOut = 0;


file = fopen('annotations_generated.txt', 'w');
fclose(file);

%segmentSequence(path, visualize, cutOut);
segmentSingleImage(imgPath, visualize, cutOut);