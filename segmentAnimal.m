function segmentAnimal(path, visualize, cutOut)

    folders = dir(path);
    dirFlags = [folders.isdir];
    folders = folders(dirFlags);
    folders = folders(3:length(folders));

    for i=1:length(folders)
        if length(folders(i).name) > 2
            next = [folders(i).folder '\' folders(i).name];
            progress = ['Sequence ',num2str(i),'/',num2str(length(folders))];
            disp(progress);
            segmentSequence(next, visualize, cutOut);
        end
    end

end