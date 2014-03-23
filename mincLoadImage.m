function data = mincLoadImage(filename)
% function data = mincLoadImage(filename)
% This function loads a minc image in a matlab format
% Sometimes the dimensions are flipped, not sure why
% If the image looks like junk, flip the dimensions

handle = openimage(filename);

acqMatrix = getimageinfo(handle, 'DimSizes');
dims = [acqMatrix(3) acqMatrix(4) acqMatrix(2) acqMatrix(1)];

if (acqMatrix(1) >= 1)
    for ii=1:acqMatrix(1)
        images(:,:,ii,:) = getimages(handle, 1:acqMatrix(2), ii);
    end
    data = reshape(images, acqMatrix(4), acqMatrix(3), acqMatrix(2), acqMatrix(1));
else
    images = getimages(handle, 1:acqMatrix(2));
    data = reshape(images, acqMatrix(4), acqMatrix(3), acqMatrix(2));
end

closeimage(handle);
