%%% recursively remove folder
function createEmptyFold(dirPath)
    if isfolder(dirPath)
        files = dir(dirPath);
        for i = 1:length(files)
            if strcmp(files(i).name, '.') || strcmp(files(i).name, '..')
                continue;
            end
            filePath = fullfile(dirPath, files(i).name);
            if isfolder(filePath)
                my_rmdir(filePath);
            else
                delete(filePath);
            end
        end
        rmdir(dirPath);
    end
    mkdir(dirPath)
end