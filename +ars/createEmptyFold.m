%%% create folder, deleting old folder if it exists
function createEmptyFold(dirPath)
    if isfolder(dirPath)
        ars.my_rmdir(dirPath);
    end
    mkdir(dirPath)
end