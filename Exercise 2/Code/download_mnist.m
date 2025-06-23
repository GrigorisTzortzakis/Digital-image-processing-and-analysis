
cd('D:/ceid/Psifiakh epeksergasia eikonas/AskHsh 2');

% Define the  URLs for the four MNIST files
urls = { ...
    'https://ossci-datasets.s3.amazonaws.com/mnist/train-images-idx3-ubyte.gz',  ...
    'https://ossci-datasets.s3.amazonaws.com/mnist/train-labels-idx1-ubyte.gz',  ...
    'https://ossci-datasets.s3.amazonaws.com/mnist/t10k-images-idx3-ubyte.gz',   ...
    'https://ossci-datasets.s3.amazonaws.com/mnist/t10k-labels-idx1-ubyte.gz'   ...
};

filenames = { ...
    'train-images-idx3-ubyte.gz',  ...
    'train-labels-idx1-ubyte.gz',  ...
    't10k-images-idx3-ubyte.gz',   ...
    't10k-labels-idx1-ubyte.gz'   ...
};

% Download each file with websave:
for k = 1:numel(urls)
    fprintf('Downloading %s ...\n', filenames{k});
    try
        websave(filenames{k}, urls{k});
        fprintf('  ✓ Saved to %s\n', filenames{k});
    catch ME
        warning('  ✗ Failed to download %s:\n    %s\n', filenames{k}, ME.message);
    end
end

%  Unzip each .gz file 
for k = 1:numel(filenames)
    gzFile = filenames{k};
    if isfile(gzFile)
        fprintf('Unzipping %s ...\n', gzFile);
        try
            gunzip(gzFile);
            fprintf('  ✓ Unzipped to %s (raw IDX)\n', gzFile(1:end-3));
        catch ME
            warning('  ✗ Failed to unzip %s:\n    %s\n', gzFile, ME.message);
        end
    else
        warning('  ‼ File not found, skipping unzip: %s\n', gzFile);
    end
end

