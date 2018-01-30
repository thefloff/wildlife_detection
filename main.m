path = '..\data\1.57-Red_Deer\SEQ76275';
%path = '..\data\1.57-Red_Deer\SEQ76431';
imgPath = '..\data\1.57-Red_Deer\SEQ76431\SEQ76431_IMG_0003.JPG';
%folder = '..\cameratrap\Set1\1.57-Red_Deer';
folder = '..\cameratrap\Set1\1.59-Wild_Boar';
visualize = 1;
cutOut = 0;


file = fopen('annotations_generated.txt', 'w');
fclose(file);


segmentAnimal(folder, visualize, cutOut);
%segmentSequence(path, visualize, cutOut);
%segmentSingleImage(imgPath, visualize, cutOut);