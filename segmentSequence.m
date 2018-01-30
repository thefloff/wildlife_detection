function segmentSequence(path, visualize, cutOut)

    [imgs, names, bw, originals] = loadSequence(path);

    bg = getBackground(imgs);

    CellSize = [8 8];   %default [8 8]
    BlockSize = [2 2];  %default [2 2]
    BlockOverlap = ceil(BlockSize/2);
    BlocksPerImage = floor((size(bg)./CellSize-BlockSize)./(BlockSize-BlockOverlap)+1);

    bg_features = extractHOGFeatures(bg);
    bg_featureMat = reshape(bg_features, [36, BlocksPerImage]);

    if visualize
        figure;
        imshow(bg);
        title('Calculated background');
    end

    for k=1:length(names)
        file = fopen('annotations_generated.txt', 'a');
        folder = names(k).folder;
        pos = find(folder == '\', 1, 'last');
        if ~pos
            pos = find(folder == '/', 1, 'last');
        end
        folder = folder(pos:end);
        name = [folder '\' names(k).name];
        fprintf(file, '%s ', name);
        fclose(file);
        
        segmentImage(imgs(:,:,k), bg_featureMat, BlocksPerImage, visualize, cutOut, bw, originals(:,:,3*(k-1)+1:3*k));
    end

end