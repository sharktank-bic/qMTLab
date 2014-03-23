function s = splitDicomData(seriesDiscrption, workdir)
display('Please select folder in which Dicom files are stored');
dicomDir = uigetdir(workdir);

n = 0;
% Get a recursive dump of all sub-directories. We'll
% process every file in the dicomDir tree.
d = genpath(dicomDir);
if(isempty(d))
  error(['Dicom dir "' d '" not found or empty.']);
end
if(isunix)
    d = explode(':',genpath(dicomDir));
else
    d = explode(';',genpath(dicomDir));
end
d = d(1:end-1);
for(ii=1:length(d))
  d2 = dir(fullfile(d{ii},'*'));
  for(jj=1:length(d2))
	if(~d2(jj).isdir)
	  n = n+1;
	  dicomFiles{n} = fullfile(d{ii},d2(jj).name);
	end
  end
end

clear d;
numSeries = 0;
% We might need this if the dicoms are gzipped.
tmp = tempdir;
tmpName = tempname;
ignoreAcquisition = false;

if(~exist('studyId','var'))
    studyId = [];
end
fprintf('Processing %d files in %s:\n', n, dicomDir);
for(imNum=1:length(dicomFiles))
    curFile = dicomFiles{imNum};
    if(length(curFile)>3 && strcmpi(curFile(end-2:end),'.gz'))
        if(exist(tmpName,'file')) delete(tmpName); end
        curFile = gunzip(curFile,tmp);
        movefile(curFile{1}, tmpName);
        curFile = tmpName;
    end
% 	try
	  info = dicominfo(curFile);
	  if((isempty(studyId) || strcmp(studyId,info.StudyID)) &&  isfield(info,'PatientPosition'))
        if(numSeries==0)
            curSeries = [];
        else
            if(ignoreAcquisition)
                curSeries = find(str2double(info.SeriesTime)==[s(:).acqTime]);
            else
                curSeries = find(info.AcquisitionNumber==[s(:).acqNum] & str2double(info.SeriesTime)==[s(:).acqTime]);
            end
        end
        if(isempty(curSeries))
		  numSeries = numSeries+1;
          curSeries = numSeries;
		  numSlice = 1;
% 		  s(curSeries).studyID = info.StudyID;
% 		  s(curSeries).studyDescription = getFieldVal(info, 'StudyDescription', '');
% 		  s(curSeries).studyDateTime = [info.SeriesDate ' ' info.StudyTime];
% 		  s(curSeries).patientName = info.PatientName.FamilyName;
% 		  s(curSeries).patientPosition = getFieldVal(info, 'PatientPosition', 'NONE');
% 		  s(curSeries).fieldStrength = getFieldVal(info, 'MagneticFieldStrength', []);
		  s(curSeries).seriesDescription = getFieldVal(info, 'SeriesDescription', []);
		  s(curSeries).acqTime = str2double(getFieldVal(info, 'SeriesTime', []));
% 		  s(curSeries).acqMatrix = getFieldVal(info, 'AcquisitionMatrix',[]);
% 		  s(curSeries).percentFOV = [getFieldVal(info, 'PercentSampling', []) getFieldVal(info, 'PercentPhaseFieldOfView', [])];
% 		  s(curSeries).reconDiam = getFieldVal(info, 'ReconstructionDiameter', []);
% 		  s(curSeries).sliceThickness = info.SliceThickness;
%           if(isfield(info,'SpacingBetweenSlices'))
%               s(curSeries).mmPerVox = [info.PixelSpacing(:)' info.SpacingBetweenSlices];
%           else
%               s(curSeries).mmPerVox = [info.PixelSpacing(:)' s(curSeries).sliceThickness];
%           end
% 		  s(curSeries).TR = getFieldVal(info, 'RepetitionTime', []);
% 		  s(curSeries).TE = getFieldVal(info, 'EchoTime', []);
% 		  s(curSeries).inversionTime = getFieldVal(info, 'InversionTime', []);
% 		  s(curSeries).SAR = getFieldVal(info, 'SAR', []);
% 		  s(curSeries).pixBandwidth = getFieldVal(info, 'PixelBandwidth', []);
%           if(~isempty(s(curSeries).pixBandwidth) && numel(s(curSeries).acqMatrix>=2))
%               s(curSeries).Bandwidth = s(curSeries).pixBandwidth*s(curSeries).acqMatrix(2);
%           else
%               s(curSeries).Bandwidth = [];
%           end
% 		  s(curSeries).NEX = getFieldVal(info, 'NumberOfAverages', []);
% 		  s(curSeries).imageFreq = getFieldVal(info, 'ImagingFrequency',[]);
% 		  s(curSeries).flipAngle = getFieldVal(info, 'FlipAngle', []);
% 		  s(curSeries).phaseEncodeDir = getFieldVal(info, 'InPlanePhaseEncodingDirection', []);
% 		  % We'll fill in the 3rd and 4th dims below
% 		  %s(curSeries).dims = [info.Rows info.Columns info.ImagesInAcquisition];
% 		  s(curSeries).dims = [info.Rows info.Columns 0 0];
		  s(curSeries).seriesNum = getFieldVal(info, 'SeriesNumber', []);
    	  s(curSeries).acqNum = getFieldVal(info, 'AcquisitionNumber', []);
% 		  s(curSeries).imageOrientation = getFieldVal(info, 'ImageOrientationPatient', []);
%           if(strcmp(info.Manufacturer,'GE MEDICAL SYSTEMS'))
%               % *** TO DO: these should be pulse-sequence dependent
%               s(curSeries).sequenceName = getFieldVal(info, 'Private_0019_109e',[]);
%               s(curSeries).mtOffset = getFieldVal(info, 'Private_0043_1034',[]);
%               s(curSeries).dtiBValue = str2double(char(getFieldVal(info, 'Private_0019_10b0',[])));
%               s(curSeries).dtiGradsCode = str2double(char(getFieldVal(info, 'Private_0019_10b2',[])));
%           elseif(strcmp(info.Manufacturer,'SIEMENS'))
%               bmtx = getFieldVal(info, 'Private_0019_1027', []);
%               if(isempty(bmtx))
%                   s(curSeries).dtiBMatrix = [];
%                   s(curSeries).dtiBValue = 0;
%                   s(curSeries).dtiGradDir = [1 0 0]';
%               else
%                   s(curSeries).dtiBMatrix = typecast(bmtx,'double');
%                   s(curSeries).dtiBValue = norm(sqrt(s(curSeries).dtiBMatrix([1 4 6])))^2;
%                   s(curSeries).dtiGradDir = sign(sign(s(curSeries).dtiBMatrix([1:3])) + 0.01).*sqrt(s(curSeries).dtiBMatrix([1 4 6])/s(curSeries).dtiBValue);
%               end
%           end
		  %ReferencedImageSequence
		  
		  %s(curSeries).imData = zeros(s(curSeries).dims);
		  %s(curSeries).imagePosition = zeros(3,s(curSeries).dims(3));
		  %s(curSeries).sliceNum = zeros(1,s(curSeries).dims(3));
		  % We'll set this to more meaningful values below
% 		  s(curSeries).imToScanXform = eye(4);
% 		  
fprintf('Loading series %d, acquisition %d...\n', s(curSeries).seriesNum, s(curSeries).acqNum);
        end
%         s(curSeries).sliceNum(numSlice) = info.InstanceNumber;
%         s(curSeries).imagePosition(:,numSlice) = info.ImagePositionPatient;
%         s(curSeries).sliceLoc(numSlice) = info.SliceLocation;
        s(curSeries).fileName{numSlice} = dicomFiles{imNum};
        % Matlab seems to flip permute x and y when reading the data, so we do
        % a transpose here. Seems to make everything work better down the line.
        % *** RFD: need to flip dim 2 also?
%         s(curSeries).imData(:,:,numSlice) = dicomread(info)';
        numSlice = numSlice+1;
	  end
% 	catch
% 	  disp(['failed to load ' curFile]);
% 	end
end

% sort the series properly
[junk,ind] = sort([s(:).seriesNum]);
s = s(ind);

for ii = 1:length(s)
if isequal(s(ii).seriesDescription,seriesDiscrption)
Nacq = s(ii).acqNum;
tmpfilename = [];
for jj = 1:length(s(ii).fileName)
thisfilename = cell2mat(s(ii).fileName(jj));
tmpfilename = [tmpfilename ' ' thisfilename];
end
cmd = ['dcm2mnc -clobber -dname ""' tmpfilename ' ' [workdir '/qMT_off']];
system(cmd);
end
end

function val = getFieldVal(s, fieldName, defaultValue)
    if(isfield(s,fieldName))
        val = s.(fieldName);
    else
        val = defaultValue;
    end
return;

