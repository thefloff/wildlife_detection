function segmentSequence(path, visualize, cutOut)

    [imgs, names] = loadSequence(path);

    bg = getBackground(imgs);

    CellSize = [8 8];   %default [8 8]
    BlockSize = [2 2];  %default [2 2]
    BlockOverlap = ceil(BlockSize/2);
    BlocksPerImage = floor((size(bg)./CellSize-BlockSize)./(BlockSize-BlockOverlap)+1);

    bg_features = extractHOGFeatures(bg);
    bg_featureMat = reshape(bg_features, [36, BlocksPerImage]);

    figure;
    imshow(bg);

    for k=1:length(names)
        bbs = segmentImage(imgs(:,:,k), bg_featureMat, BlocksPerImage, visualize, cutOut);
        disp(bbs);
    end

end