function qmt_off= qmt_off_data(workdir)

numStudy = str2double(cell2mat(inputdlg('Please enter number of studies to combine','Number of qMT studies')));
qmt_off{numStudy}.files = '';
for ii = 1:numStudy
    button = questdlg('What would you like to do','Gather qMT_off data','Get From DICOM','Choose From Folder','Choose From Folder');
	switch button
    		case 'Get From DICOM'
			tmpSeriesDescription = cell2mat(inputdlg(['Prepare data for study #' num2str(ii) ...
			', please enter the sequence description'],'Sequence Description'));
        	 	if exist([workdir '/qMT_off'])~=7
        	     		system(['mkdir ' workdir '/qMT_off']);
        	 	end
        	 	s=splitDicomData(tmpSeriesDescription, workdir);
        	 	folderName = [workdir '/qMT_off/'];
        	     
    		case 'Choose From Folder'
        		folderName = [uigetdir(workdir) '/'];
	end
d = dir([folderName '*.mnc*']);
str = {d.name}';
uiwait(helpdlg('Please choose the file for baseline'));
[selection,ok] = listdlg('ListString',str, 'ListSize', [600 300]);
qmt_off{ii}.baseline  = [folderName str{selection}];
uiwait(helpdlg('Please choose the qMT files of this study'));
[selection,ok] = listdlg('ListString',str, 'ListSize', [600 300]);
sel = str(selection);
ordered = reorderTable(sel);
for jj = 1:length(ordered)
    ordered{jj} = [folderName ordered{jj}]
end
qmt_off{ii}.files = ordered'

end
