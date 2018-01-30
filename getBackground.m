function bg = getBackground(imgs)
    bg = zeros(size(imgs(:,:,1)), 'uint8');
    for i=1:length(imgs(:,1,1))
        for j=1:length(imgs(1,:,1))
            bg(i,j) = median(imgs(i,j,:));
        end
    end