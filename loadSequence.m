function [imgs, names, bw, originals] = loadSequence(path)

    pattern = [path '\*.jpg'];
    names = dir(pattern);
    
    bw = 1;
    for i=1:length(names)
       curName = [path '\' names(i).name];
       curImg = imread(curName);
       if size(curImg(1,1,:)) < 3
           original = curImg;
           curImg = imgaussfilt(curImg, 10.0);
           curImg = imgaussfilt(curImg, 10.0);
           curImg = imgaussfilt(curImg, 10.0);
           bw = 1;
       elseif curImg(100:105,100:105,1) == curImg(100:105,100:105,2)
           original = curImg;
           curImg = rgb2gray(curImg);
           curImg = imgaussfilt(curImg, 10.0);
           curImg = imgaussfilt(curImg, 10.0);
           curImg = imgaussfilt(curImg, 10.0);
           bw = 1;
       else
           original = curImg;
           curImg = rgb2gray(curImg);
           bw = 0;
       end
       curImg = imadjust(curImg);
       imgs_cell{i} = curImg;
       originals_cell{i} = original;
    end

    imgs = cat(3,imgs_cell{:});
    originals = cat(3,originals_cell{:});