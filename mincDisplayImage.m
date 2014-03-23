function mincDisplayImage (mincFile, maskFile)

% function mincDisplayImage (file, mask)
% example: mincDisplayImage('file.mnc', 'mask.mnc')
% loads a minc image in matlab and orients it properly
% works only for 2D and 3D matrices, where the third dimension is always
% numSlices

dataUnrot = mincLoadImage(mincFile);
dims = size(dataUnrot);

if numel(dims) == 2
    data = rot90(dataUnrot);
else
    for ii=1:dims(3)
        data(:,:,ii) = rot90(dataUnrot(:,:,ii));
    end
end


if nargin < 2
    mask = ones(size(data));
else
    mask = mincLoadImage(maskFile);
    dims = size(mask);

    if numel(dims) == 2
        mask = rot90(mask);
    else
        for ii=1:dims(3)
            maska(:,:,ii) = rot90(mask(:,:,ii));           
        end
        mask = maska;
    end

end



if (size(data) ~= size(mask))
    warning('The file and mask sizes do not match');
    return;
end

showMontage(data.*mask);

colormap('jet'); 

%colorbar('SouthOutside');