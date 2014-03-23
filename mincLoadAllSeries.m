function s = mincLoadAllSeries(mincDir, flipFlag, studyId, sortByFilenameFlag, ignoreAcquisition)
%
% s = mincLoadAllSeries(dicomDir, [studyId=''], [sortByFilenameFlag=false])
%
% Loads all the minc files found in the specified directory
% (recursively searches all sub-directories too). A structure
% array is returned, with one entry for each series found in the
% directory tree.
% 
% flipFlag serves to reverse the order of width/length
% that somehow gets mixed up
%
% If studyID (a string) is provided, then only series with a matching
% StudyID tag will be processed. Otherwise, all studies are processed.
%
% HISTORY:
% 2007.01.?? Bob Dougherty wrote it for DICOM files.
% 2009.12.08 Bob Dougherty: completely replaced code to compute the imToScanner
% xform. I now use code that is modeled on NYU's dinifti, so we should now
% produce results consistent with that program. Which, BTW, are more
% accurate than what we did before.
% 2010.07.?? Nikola Stikov modified it for MINC files
% 2012.01.10 Noticed that sometimes lines 123 and 127 need to have the
% order of the reshape dimensions reversed.  Could be a difference between
% 1.5T and 3T

if(~exist('flipFlag','var')||isempty(flipFlag))
    flipFlag = false;
end

if(~exist('sortByFilenameFlag','var')||isempty(sortByFilenameFlag))
    sortByFilenameFlag = false;
end
if(~exist('ignoreAcquisition','var')||isempty(ignoreAcquisition))
    ignoreAcquisition = false;
end

n = 0;
% Get a recursive dump of all sub-directories. We'll
% process every file in the mincDir tree.
d = genpath(mincDir);
if(isempty(d))
    error(['Minc dir "' d '" not found or empty.']);
end
if(isunix)
    d = explode(':',genpath(mincDir));
else
    d = explode(';',genpath(mincDir));
end
d = d(1:end-1);
for(ii=1:length(d))
    d2 = dir(fullfile(d{ii},'*'));
    for(jj=1:length(d2))
        if(~d2(jj).isdir)
            n = n+1;
            mincFiles{n} = fullfile(d{ii},d2(jj).name);
        end
    end
end

clear d;
numSeries = 0;
% We might need this if the mincs are gzipped.
tmp = tempdir;
tmpName = tempname;

if(~exist('studyId','var'))
    studyId = [];
end
fprintf('Processing %d files in %s:\n', n, mincDir);
for(imNum=1:length(mincFiles))

    curFile = mincFiles{imNum};
    if(length(curFile)>3 && strcmpi(curFile(end-2:end),'.gz'))
        if(exist(tmpName,'file')) delete(tmpName); end
        %curFile = unix(['gunzip(' curFile ',' tmp ')']);
        curFile = gunzip(curFile, tmp);
        movefile(curFile{1}, tmpName);
        curFile = tmpName;
    end

    %if(~strcmpi(curFile(end-1:end), '.m'))

        try
            handle = openimage(curFile);
            info.SeriesTime = miinquire(curFile, 'attvalue', 'acquisition', 'imagetime');
            info.AcquisitionNumber = miinquire(curFile, 'attvalue', 'acquisition', 'acquisition_id');
            curSeries = str2num(miinquire(curFile, 'attvalue', 'acquisition', 'acquisition_id'));
            s(curSeries).acqNum = str2num(miinquire(curFile, 'attvalue', 'acquisition', 'acquisition_id'));

            s(curSeries).studyID = miinquire(curFile, 'attvalue', 'study', 'study_id');
            s(curSeries).studyDescription = miinquire(curFile, 'attvalue', 'study', 'procedure');
            s(curSeries).studyDateTime = miinquire(curFile, 'attvalue', 'acquisition', 'start_time');
            s(curSeries).patientName = miinquire(curFile, 'attvalue', 'patient', 'full_name');

            s(curSeries).patientPosition = miinquire(curFile, 'attvalue', 'patient', 'position');

            s(curSeries).fieldStrength = miinquire(curFile, 'attvalue', 'study', 'field_value');
            s(curSeries).seriesDescription = miinquire(curFile, 'attvalue', 'acquisition', 'series_description');

            s(curSeries).acqTime = str2num(miinquire(curFile, 'attvalue', 'acquisition', 'series_time'));
            s(curSeries).acqMatrix = getimageinfo(handle, 'DimSizes');
            s(curSeries).sliceThickness = (miinquire(curFile, 'attvalue', 'acquisition', 'slice_thickness'));
            s(curSeries).TR = (miinquire(curFile, 'attvalue', 'acquisition', 'repetition_time'));
            s(curSeries).TE = (miinquire(curFile, 'attvalue', 'acquisition', 'echo_time'));
            s(curSeries).flipAngle = (miinquire(curFile, 'attvalue', 'acquisition', 'flip_angle'));
            s(curSeries).phaseEncodeDir = miinquire(curFile, 'attvalue', 'acquisition', 'phase_enc_dir');
            s(curSeries).dims = [s(curSeries).acqMatrix(3) s(curSeries).acqMatrix(4) s(curSeries).acqMatrix(2) s(curSeries).acqMatrix(1)];
            %s(curSeries).dims = [s(curSeries).acqMatrix(3) s(curSeries).acqMatrix(4) s(curSeries).acqMatrix(2) s(curSeries).acqMatrix(1)];

            s(curSeries).imToScanXform = eye(4);
            s(curSeries).numSlices = s(curSeries).acqMatrix(2);
            s(curSeries).inversionTime = 1000*miinquire(curFile, 'attvalue', 'acquisition', 'inversion_time');

            fprintf('Loading series %d...\n', s(curSeries).acqNum);



            %             s(curSeries).sliceNum(numSlice) = info.InstanceNumber;
            %             s(curSeries).imagePosition(:,numSlice) = info.ImagePositionPatient;
            %             s(curSeries).sliceLoc(numSlice) = info.SliceLocation;
            %             s(curSeries).fileName{numSlice} = dicomFiles{imNum};
            % Matlab seems to flip permute x and y when reading the data, so we do
            % a transpose here. Seems to make everything work better down the line.
            % *** RFD: need to flip dim 2 also?
            %s(curSeries).imData(:,:,numSlice) = dicomread(info)';
            %numSlice = numSlice+1;
            %end
            if (s(curSeries).acqMatrix(1) >= 1)
                data = getimages(handle, 1:s(curSeries).acqMatrix(2), 1:s(curSeries).acqMatrix(1));
                if (flipFlag)
                    s(curSeries).imData = reshape(data, s(curSeries).dims(1), s(curSeries).dims(2), s(curSeries).dims(3),...
                    s(curSeries).acqMatrix(1));
                else
                    s(curSeries).imData = reshape(data, s(curSeries).dims(2), s(curSeries).dims(1), s(curSeries).dims(3),...
                    s(curSeries).acqMatrix(1));
                end
                
            else
                if (flipFlag)
                    data = getimages(handle, 1:s(curSeries).acqMatrix(2));
                    s(curSeries).imData = reshape(data, s(curSeries).dims(2), s(curSeries).dims(1), s(curSeries).dims(3));
                else
                    data = getimages(handle, 1:s(curSeries).acqMatrix(2));
                    s(curSeries).imData = reshape(data, s(curSeries).dims(1), s(curSeries).dims(2), s(curSeries).dims(3));
                end
            end
            
                        catch
            disp(['failed to load ' curFile]);
        end
%     else
%         disp(['failed to load ' curFile]);
% 
%     end

end

return;
% sort the series properly
[junk,ind] = sort([s(:).acqNum]);
s = s(ind);

% Sort the slices based on sliceNum and break timeseries up into separate
% volumes (good for fMRI and DTI acquisitions).

for(ii=1:numSeries)
    if(sortByFilenameFlag)
        [s(ii).sliceNum,sortInd] = sort(s(ii).fileName);
    else
        % Sort based on sliceNum (DICOM InstanceNumber).
        [s(ii).sliceNum,sortInd] = sort(s(ii).sliceNum);
    end
    s(ii).sliceLoc = s(ii).sliceLoc(sortInd);
    s(ii).imagePosition = s(ii).imagePosition(:,sortInd);
    s(ii).imData = s(ii).imData(:,:,sortInd);
    % Now compute the actual number of slices per timepoint
    uniqueSliceLoc = unique(s(ii).sliceLoc);
    s(ii).dims(3) = length(uniqueSliceLoc);
    s(ii).dims(4) = floor(length(sortInd)./s(ii).dims(3));
    if(prod(double(s(ii).dims))==numel(s(ii).imData))
        s(ii).imData = reshape(s(ii).imData, s(ii).dims);
    else
        warning(['Series ' num2str(ii) ' appears to contain >1 volume, but I can not guess the dimensions- keeping it a single vol.']);
    end
end

for(ii=1:length(s))
    if(isempty(s(ii).imData)) s(ii) = []; end
end
numSeries = length(s);

% Compute the scanner-to-image xform and resort the slices based on the
% slice normal.
for(ii=1:numSeries)
    % 2009.12.07 RFD: Pulled orientation code from NYU's dinifti
    dim = size(s(ii).imData);

    % Orientation information
    %-------------------------------------------------------------------
    % Axial Analyze voxel co-ordinate system:
    % x increases     right to left
    % y increases posterior to anterior
    % z increases  inferior to superior

    % DICOM patient co-ordinate system:
    % x increases     right to left
    % y increases  anterior to posterior
    % z increases  inferior to superior

    % T&T co-ordinate system:
    % x increases      left to right
    % y increases posterior to anterior
    % z increases  inferior to superior

    % Code lifted from dinifti source:
    % patient orientation cosines, in [Sag, Cor, Ax] order
    rowCosines = s(ii).imageOrientation(1:3);
    colCosines = s(ii).imageOrientation(4:6);
    sliceNorm = cross(rowCosines, colCosines);

    qto_xyz = zeros(4,4);
    qto_xyz(1,1) = -rowCosines(1); % -image->RowSagCos();
    qto_xyz(1,2) = -colCosines(1); % -image->ColSagCos();
    qto_xyz(1,3) = -sliceNorm(1); % -(rowCosines(2) * colCosines(3) - rowCosines(3) * colCosines(2)); % -image->SagNorm();

    qto_xyz(2,1) = -rowCosines(2); % -image->RowCorCos();
    qto_xyz(2,2) = -colCosines(2); % -image->ColCorCos();
    qto_xyz(2,3) = -sliceNorm(2); % -(rowCosines(3) * colCosines(1) - rowCosines(1) * colCosines(3)); % -image->CorNorm();

    qto_xyz(3,1) = rowCosines(3); % image->RowTraCos();
    qto_xyz(3,2) = colCosines(3); % image->ColTraCos();
    qto_xyz(3,3) = sliceNorm(3); % rowCosines(1) * colCosines(2) - rowCosines(2) * colCosines(1); % image->TraNorm();

    % *** TO DO: The most robust wayt to define slice order and slice
    % spacing is to project slice position onto slice normal.
    % From: http://nifti.nimh.nih.gov/board/read.php?f=1&i=579&t=508
    % Slice normal vector is the cross product of ImageOrientationPatient vectors.
    % Project each slice's ImagePositionPatient projection onto the slice normal
    % to find it's position in the slice order list.
    % pfirst = dot(sliceNorm,s(ii).imagePosition(:,1)) * sliceNorm;
    % plast = dot(sliceNorm,s(ii).imagePosition(:,end)) * sliceNorm;

    % Simple hack to decide if we need to flip the slice order:
    if(dot(sliceNorm,s(ii).imagePosition(:,1)) > dot(sliceNorm,s(ii).imagePosition(:,end)))
        s(ii).sliceNum = flipdim(s(ii).sliceNum,2);
        s(ii).sliceLoc = flipdim(s(ii).sliceLoc,2);
        s(ii).imagePosition = flipdim(s(ii).imagePosition,2);
        s(ii).imData = flipdim(s(ii).imData,3);
    end

    % offset = slicePosition(center) - M*(i,j,k of center) since we are working with the first slice k = 0.

    % For matlab's 1-indexing, we have to subtract mmPerVox from the origin
    % (imagePosition) to reflect the fact that the first voxel is [1,1,1]
    % rather than [0,0,0].
    pos = s(ii).imagePosition(:,1);
    qto_xyz(:,4) = [-pos(1) -pos(2) pos(3) 1]';
    qto_xyz(1:3,1:3) = qto_xyz(1:3,1:3)*diag(s(ii).mmPerVox);

    % Apply a 1-voxel offset to the origin to account for Matlab's
    % 1-indexing.
    qto_xyz = inv(inv(qto_xyz)+[0 0 0 1;0 0 0 1;0 0 0 1; 0 0 0 0]);


    s(ii).imToScanXform  = qto_xyz;

    % OLD CODE:
    %     s(ii).imToScanXform = eye(4);
    %     % DICOM +Xd is Left, +Yd is Posterior, +Zd is Superior,
    %     % while NIFTI is +x is Right, +y is Anterior, +z is Superior.
    %     % So, x and y offsets get flipped.
    %     %s(ii).imToScanXform(1:3,4) = s(ii).imagePosition(:,1).*[-1 -1 1]';
    %     s(ii).imToScanXform(1:3,4) = -s(ii).imagePosition(:,1);
    %
    %     % From the NIFTI-1 standard (Bob Cox):
    %     % The DICOM attribute (0020,0037) "Image Orientation (Patient)"
    %     % gives the orientation of the x- and y-axes of the image data
    %     % in terms of 2 3-vectors. The first vector is a unit vector
    %     % along the x-axis, and the second is along the y-axis. If the
    %     % (0020,0037) attribute is extracted into the value
    %     % (xa,xb,xc,ya,yb,yc), then the first two columns of the R
    %     % matrix would be
    %     %            [ -xa  -ya ]
    %     %            [ -xb  -yb ]
    %     %            [  xc   yc ]
    %     % The negations are because DICOM's x- and y-axes are reversed
    %     % relative to NIFTI's. The third column of the R matrix gives
    %     % the direction of displacement (relative to the subject) along
    %     % the slice-wise direction. This orientation is not encoded in
    %     % the DICOM standard in a simple way; DICOM is mostly concerned
    %     % with 2D images.  The third column of R will be either the
    %     % cross-product of the first 2 columns or its negative.  It is
    %     % possible to infer the sign of the 3rd column by examining the
    %     % coordinates in DICOM attribute (0020,0032) "Image Position
    %     % (Patient)" for successive slices.  However, this method
    %     % occasionally fails for reasons that I (RW Cox) do not understand.
    %     s(ii).imToScanXform(1:3,1) = s(ii).imageOrientation(1:3).*[-1 -1 1]';
    %     s(ii).imToScanXform(1:3,2) = s(ii).imageOrientation(4:6).*[-1 -1 1]';
    %     s(ii).imToScanXform(1:3,3) = cross(s(ii).imToScanXform(1:3,1),s(ii).imToScanXform(1:3,2));
    %     if(s(ii).sliceLoc(1)>s(ii).sliceLoc(end))
    %         % Slices run S-I, so signal a flip in this dim.
    %         s(ii).imToScanXform(1:3,3) = -s(ii).imToScanXform(1:3,3);
    %         s(ii).imToScanXform(3,4) = -s(ii).imToScanXform(3,4);
    %     end
    %
    %     % CHECK THIS: How to infer the orientation?
    %     % Check to see if the image plane normal goes away from the
    %     % center of the volume?
    %     %if(s(ii).slicePos(1)<s(ii).slicePos(end))
    %     %  s(ii).imToScanXform(1:3,3) = -s(ii).imToScanXform(1:3,3);
    %     %end
    %     s(ii).imToScanXform = s(ii).imToScanXform*diag([s(ii).mmPerVox 1]);
end


return;


function val = getFieldVal(s, fieldName, defaultValue)
if(isfield(s,fieldName))
    val = s.(fieldName);
else
    val = defaultValue;
end
return;


