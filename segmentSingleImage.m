function segmentSingleImage(path, visualize, cutOut)

    superdir = path;
    pos = find(superdir == '\', 1, 'last');
    if ~pos
        pos = find(superdir == '/', 1, 'last');
    end
    superdir = superdir(1:pos-1);

    [imgs, names] = loadSequence(superdir);
        
    for k=1:length(names)
        curName = [superdir '\' names(k).name];
        if strcmp(curName, path)
            imgIdx = k;
        end
    end    
    
    bg = getBackground(imgs);

    CellSize = [8 8];   %default [8 8]
    BlockSize = [2 2];  %default [2 2]
    BlockOverlap = ceil(BlockSize/2);
    BlocksPerImage = floor((size(bg)./CellSize-BlockSize)./(BlockSize-BlockOverlap)+1);

    bg_features = extractHOGFeatures(bg);
    bg_featureMat = reshape(bg_features, [36, BlocksPerImage]);

    figure;
    imshow(bg);
    
    bbs = segmentImage(imgs(:,:,imgIdx), bg_featureMat, BlocksPerImage, visualize, cutOut);
    disp(bbs);

end