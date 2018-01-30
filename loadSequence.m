function [imgs, names] = loadSequence(path)

    pattern = [path '\*.jpg'];
    names = dir(pattern);

    for i=1:length(names)
       curName = [path '\' names(i).name];
       curImg = imread(curName);
       if size(curImg, 3) == 3
           curImg = rgb2gray(curImg);
       end
       curImg = imadjust(curImg);
       imgs_cell{i} = curImg;
    end

    imgs = cat(3,imgs_cell{:});