function [class] = classifyDCNN(im,filename)
%CLASSIFY Summary of this function goes here
%   Detailed explanation goes here

load(filename);

% todo rename variable in *.mat
net = netTransferGoogle;

% resize image to first layer
img = imresize(im,[net.Layers(1).InputSize(1) net.Layers(1).InputSize(2)]);
img = img(:,:,[1 1 1]);
    
class = classify(netTransferGoogle,img);
end

