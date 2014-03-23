function mincSaveImage(data, filename, parent);
% function mincSaveImage(data, filename, parent);
% -----------------------------------------------
% inputs:
% data: a matlab matrix with dimensions length, width, numslices, numframes
% filename: the MINC file to be created
% parent: a minc file that is parent to filename

dims = size(data);

if numel(dims)>2
    numSlices = dims(3);
else numSlices = 1;

end

if numel(dims)>3
    numFrames = dims(4);
else
    numFrames = 0;
end

if numFrames > 1
    images = reshape(data, dims(1)*dims(2), numSlices, numFrames);
else
    if numSlices > 1
        images = reshape(data, dims(1)*dims(2), numSlices);
    end
end

if numSlices == 1 && numFrames == 0
    images = reshape(data, dims(1)*dims(2), 1);
end


handle = newimage(filename, [numFrames numSlices dims(2) dims(1)], parent);

putimages(handle, images, 1:numSlices);
closeimage(handle);
