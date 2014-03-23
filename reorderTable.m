function ordered = reorderTable(filenames)

    scrsz = get(0,'ScreenSize');
    h(1) = figure('position', [1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
        
    h(2) = uitable(h(1),...
        'data'    , filenames, ...
        'ColumnName','Filenames', ...
        'ColumnWidth', {floor(scrsz(3)/100)*25} , ...
        'units'   , 'normalized',...
        'position', [0.1 0.1 0.6 0.85],...
        'CellSelectionCallback', @selectCells);

    h(3) = uicontrol(...
        'style'   , 'pushbutton', ...
        'units'   , 'normalized',...
        'position', [0.75 0.6 0.2 0.15],...
        'string'  , 'Up',...
        'callback', @reOrder);
    h(4) = uicontrol(...
        'style'   , 'pushbutton', ...
        'units'   , 'normalized',...
        'position', [0.75 0.4 0.2 0.15],...
        'string'  , 'Down',...
        'callback', @reOrder);
    
    h(5) = uicontrol(...
        'style'   , 'pushbutton', ...
        'units'   , 'normalized',...
        'position', [0.75 0.2 0.2 0.15],...
        'string'  , 'Done',...
        'callback', @orderDone);
    set(h(3:4), 'enable', 'off');
    
    uiwait;
    ordered = get(h(2),'Data');
    close(h(1));



    function selectCells(src, evt)
        if ~isempty(evt.Indices) 
            set(src, 'UserData', evt.Indices);
            set(h(3:4), 'enable', 'on');
        else
%              set(h(3:4), 'enable', 'off');
        end
    end

    function reOrder(src,~)

        button = get(src, 'string');

        table = h(2);
        data = get(table, 'Data');
        selected = get(table, 'UserData');        
        selected = selected(:,1);

        switch button
            case 'Up'

            sel  = selected-1;
            not_selected = setdiff(sel, selected);            
            nsel = setdiff(selected, sel);

            if sel(1)>=1 && nsel(end)<=size(data,1)
                new_data = data;
                new_data(sel ,:) = data(selected,:);
                new_data(nsel,:) = data(not_selected,:);            
            else
                return
            end   

            case 'Down'
            sel  = selected+1;
            not_selected = setdiff(sel, selected);            
            nsel = setdiff(selected, sel);          

            if sel(1)<=size(data,1) && nsel(end)>=1
                new_data = data;
                new_data(sel ,:) = data(selected,:);
                new_data(nsel,:) = data(not_selected,:);                
            else
                return
            end

        end

        set(table, 'Data', new_data);
%         set(h(3:4), 'enable', 'on');
        set(table, 'UserData',sel)
    end
    function orderDone(src,evt)
            uiresume;
    end
end