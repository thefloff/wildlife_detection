function bbs = segmentImage(img, bg_featureMat, BlocksPerImage, visualize, cutOut, bw, original)
    features = extractHOGFeatures(img);
    featureMat = reshape(features, [36, BlocksPerImage]);

    detect = zeros(BlocksPerImage, 'uint8');
    for i=1:BlocksPerImage(1)
        for j=1:BlocksPerImage(2)
            if hogDiff(getHogAtBlock(bg_featureMat, i, j), getHogAtBlock(featureMat, i, j)) > (1.7 + bw * 2.0)
                detect(i,j) = 255;
            end
        end
    end
    
    detect(1:4,:) = 0;
    detect = imgaussfilt(detect, 0.5);
    detect = imclose(detect, strel('disk',3));
    detect(detect < 230) = 0;
    
    figure;
    imshow(detect);

    CC = bwconncomp(detect);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    minPixels = 120;
    delete = find(numPixels < minPixels);
    for i=1:length(delete)
        detect(CC.PixelIdxList{delete(i)}) = 0;
    end
    rp = regionprops(CC, 'BoundingBox');
    rp = rp(numPixels >= minPixels);

    if visualize
        figure, hold on;
        imshow(original);
    end
    
    bbs = zeros([length(rp) 4]);
    classNr = -1;
    for i=1:length(rp)
        bb = rp(i).BoundingBox;
        bb = bb.*8;
        bb(1:2) = bb(1:2) - 4;
        
        bb(1) = max(1, bb(1));
        bb(2) = max(1, bb(2));
        bb(3) = min(length(img(1,:)) - bb(1), bb(3));
        bb(3) = max(1, bb(3));
        bb(4) = min(length(img(:,1)) - bb(2), bb(4));
        bb(4) = max(1, bb(4));
        
        crop = rgb2gray(original);
        crop = crop(bb(2):bb(2)+bb(4), bb(1):bb(1)+bb(3));

        class = classifyDCNN(crop,'googlenet resized.mat');

        % classes:
        classIDToName = ["Dachs","Vogel","Wildschwein","Reh","Fuchs","Hase","Eichhörnchen","Hirsch","Rehbock"];
        className = classIDToName(double(class(1)));
        classNr = int16(class(1));
        
        if visualize
            rectangle('Position',bb,'EdgeColor','r','LineWidth',1);
            text(bb(1), bb(2) - 40 , className, 'Color','red','FontSize',18);
        end
        bbs(i,:) = bb;
    end
    
    nrBB = length(bbs(:,1));
    
    file = fopen('annotations_generated.txt', 'a');
    fprintf(file, '%i %i', classNr, nrBB);
    for i=1:nrBB
        fprintf(file,' %i %i %i %i',bbs(i,1),bbs(i,2),bbs(i,3),bbs(i,4));
    end
    fprintf(file, '\n');
    fclose(file);    
    
    if cutOut
        
        foreground = detect;
        background = ones(BlocksPerImage, 'uint8');
        background = background - foreground;

        superPixels = superpixels(img,16000);

        foreground_mask = zeros(size(img), 'uint8');
        background_mask = zeros(size(img), 'uint8');
        for i=1:BlocksPerImage(1)
            for j=1:BlocksPerImage(2)
                if foreground(i,j)
                    foreground_mask(i*8 - 4, j*8 - 4) = 1;
                end
                if background(i,j)
                    background_mask(i*8 - 4, j*8 - 4) = 1;
                end
            end
        end

        BW = lazysnapping(original, superPixels, foreground_mask, background_mask);
        BW = repmat(BW, [1 1 3]);
        result = original;
        result(~BW) = 0;

        figure, hold on;
        imshow(result);
    end

end

function hog = getHogAtBlock(featureMat, i, j)
    if i <= length(featureMat(1,:,1)) && j <= length(featureMat(1,1,:))
        hog = featureMat(:,i,j);
    else
        hog = zeros(36,1);
    end
end

function diff = hogDiff(hog1, hog2)
    diff = hog1 - hog2;
    diff = abs(diff);
    diff = sum(diff);
end