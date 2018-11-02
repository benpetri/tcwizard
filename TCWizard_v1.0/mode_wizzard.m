function [list_asbl,out_list]=mode_wizzard(param,start_ass,first_ph,list,sab,radio,isn,isv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=mode_wizzard(...)
% Calculate a succession of lines and points according to the user's
% defined initial assemblage and path
%
% Input : - param = structure of initial parameters (see paramin)
%         - start_ass = handles to the edit text box with the starting
%                       assemblage
%         - first_ph = handles to the edit text box with the phase out
%                      along the path
%         - list = handles to the listbox with the successive phases out or
%                  in along the path
%         - sab = handles to the Wizzard GO pushbutton to display hourglass
%         - radio = handles to the radiobutton for modal or compositional
%                   isopleth calculation
%         - isn = handles to the edit text box with the name of the
%                 compositional isopleth
%         - isv = handles to the edit text box with the value of the
%                 compositional isopleth
%
% Output :  - list_asbl = cell array with the list of the successive
%                         assemblages calculated by wizzard
%           - out_list = cell array with the list of the successive
%                        phase(s) out
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This file is part of TCWizard.
%
% TCWizard is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% TCWizard is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with TCWizard.  If not, see <http://www.gnu.org/licenses/>.
%
% TCWizard is Copyright (C) 2013 by Benoît Petri and Etienne Skrzypek
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Get values from the interface
% Get starting assemblage
init_ass=get(start_ass,'String');
% Get phase out to follow
init_phase=get(first_ph,'String');
% Get successive phases in/out
path=get(list,'String');
% Get Mode/Isopleth radiobutton (0=Mode 1=Compositional)
state=get(radio,'Value');
% Get isopleth name
isoname=get(isn,'String');
% Get isopleth value
isovalue=get(isv,'String');
%%%
% If no starting assemblage or no path selected
if strcmp(init_ass,'Starting Assemblage') | isempty(path)
    % Do nothing
    txt(1)={'No starting assemblage'};
    txt(2)={'or no path selected'};
    txtm=char(txt);
    menu(txtm,'Ok');
    list_asbl=[];
    out_list=[];
else
    % Calculate Pstep
    Pmin=param.PTrange(2,1);
    Pmax=param.PTrange(2,2);
    Pstep=(Pmax-Pmin)/100;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Trick to evaluate assemblage change (Al2SiO5 mins all have 3 letters...)
    init_ass=strrep(init_ass,'ky','kya');
    init_phase=strrep(init_phase,'ky','kya');
    path=strrep(path,'ky','kya');
    init_ass=strrep(init_ass,'sill','sil');
    init_phase=strrep(init_phase,'sill','sil');
    path=strrep(path,'sill','sil');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MODE WIZZARD
    if state==0
        if strcmp(init_phase,'Ph.') % If no phase out selected
            % Do nothing
            menu('No phase out selected','Ok');
            list_asbl=[];
            out_list=[];
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Build the successive assemblages
            list_asbl(1)={init_ass}; % First assemblage=starting assemblage
            for bb=1:length(path)
                %%%%%
                if isempty( cell2mat (strfind(path(bb),'-')) ) % If ky-and-sill transition not present (not containing -)
                    check=cell2mat(strfind(list_asbl(bb),char(path(bb))));
                    if ~isempty (check) && length(check)==1 % Test: if phase is already present => it is an "out line"
                        % Delete phase from future assemblage
                        list_asbl(bb+1)=strrep(list_asbl(bb),path(bb),'');
                    else % Test: if phase is not present => it is an "in line"
                        % Add phase to future assemblage
                        list_asbl(bb+1)={[char(list_asbl(bb)) ' ' char(path(bb))]};
                    end
                    %%%%%
                else % If ky-sill-and transition found
                    if  strcmp(path(bb),'sil-and') % sill-and transition
                        % Determine if sill or and was present before
                        check=cell2mat(strfind(list_asbl(bb),'sil')); % Find sill within previous assemblage
                        if ~isempty (check) % If sill present before (found sill)
                            % Replace sill by and
                            list_asbl(bb+1)=strrep(list_asbl(bb),'sil','and');
                        else % If and present before (not found sill)
                            % Replace and by sill
                            list_asbl(bb+1)=strrep(list_asbl(bb),'and','sil');
                        end
                        %%%%%
                    elseif  strcmp(path(bb),'kya-sil') % ky-sill transition
                        % Determine if sill or ky was present before
                        check=cell2mat(strfind(list_asbl(bb),'sil')); % Find sill within previous assemblage
                        if ~isempty (check) % If sill present before (found sill)
                            % Replace sill by ky
                            list_asbl(bb+1)=strrep(list_asbl(bb),'sil','kya');
                        else % If ky present before (not found sill)
                            % Replace ky by sill
                            list_asbl(bb+1)=strrep(list_asbl(bb),'kya','sil');
                        end
                        %%%%%
                    else % ky-and transition
                        % Determine if ky or and was present before
                        check=cell2mat(strfind(list_asbl(bb),'kya')); % Find ky within previous assemblage
                        if ~isempty (check) % If ky present before (found ky)
                            % Replace ky by and
                            list_asbl(bb+1)=strrep(list_asbl(bb),'kya','and');
                        else % If sill present before (not found ky)
                            % Replace and by ky
                            list_asbl(bb+1)=strrep(list_asbl(bb),'and','kya');
                        end
                    end
                end
            end
            %%%
            % Loop to clean double spaces
            for clean=1:length(list_asbl);
                while ~isempty (cell2mat(strfind(list_asbl(clean),'  ')))
                    list_asbl(clean)=strrep(list_asbl(clean),'  ',' ');
                end
            end
            % Build assemblages for point calculation (append at the end)
            curs=length(list_asbl);
            for bb4=1:(length(list_asbl)-1) % Nb of points = Nb of lines - 1
                if length(char(list_asbl(bb4)))<length(char(list_asbl(bb4+1))) % If more characters, "in" line
                    list_asbl(bb4+curs)=list_asbl(bb4+1);
                elseif length(char(list_asbl(bb4)))>length(char(list_asbl(bb4+1))) % If less characters, "out" line
                    list_asbl(bb4+curs)=list_asbl(bb4);
                else % If ky-and-sill transition
                    check1=cell2mat(strfind(list_asbl(bb4),'sil'));
                    check2=cell2mat(strfind(list_asbl(bb4),'kya'));
                    check3=cell2mat(strfind(list_asbl(bb4),'and'));
                    check4=cell2mat(strfind(list_asbl(bb4+1),'sil'));
                    check5=cell2mat(strfind(list_asbl(bb4+1),'kya'));
                    check6=cell2mat(strfind(list_asbl(bb4+1),'and'));
                    if ~isempty(check1) && ~isempty(check5) % sill->ky
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'kya']};
                    elseif ~isempty(check1) && ~isempty(check6) % sill->and
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'and']};
                    elseif ~isempty(check2) && ~isempty(check6) % ky->and
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'and']};
                    elseif ~isempty(check2) && ~isempty(check4) % ky->sill
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'sil']};
                    elseif ~isempty(check3) && ~isempty(check4) % and->sill
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'sil']};
                    else                                        % and->ky
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'kya']};
                    end

                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Build the phases out list, for lines
            for bb2=1:(length(path)+1)
                out_list(bb2)={init_phase}; % Phase out for all lines
            end
            % Build the phases out list, for points (append at the end)
            cursor=length(out_list);
            for bb3=(cursor+1):(cursor+length(path))
                chk=char(path(bb3-cursor));
                if strcmp(chk,'kya-sil')
                    out_list(bb3)={[char(init_phase) ' ' 'kya']};
                elseif strcmp(chk,'sil-and')
                    out_list(bb3)={[char(init_phase) ' ' 'sil']};
                elseif strcmp(chk,'kya-and')
                    out_list(bb3)={[char(init_phase) ' ' 'and']};
                else
                    out_list(bb3)={[char(init_phase) ' ' char(path(bb3-cursor))]};
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Get back to ky and sill
            list_asbl=strrep(list_asbl,'kya','ky');
            out_list=strrep(out_list,'kya','ky');
            list_asbl=strrep(list_asbl,'sil','sill');
            out_list=strrep(out_list,'sil','sill');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Open, create and write in the temp file (wizztemp.txt)
            filetc=[param(1).pathin 'wizztemp.txt'];
            fid = fopen(filetc,'w+');
            %%% Loop for successive calculations
            for nb=1:length(out_list)
                % Assemblage
                fprintf(fid,'%s\r\n',char(list_asbl(nb)));
                % Variance (not answering)
                fprintf(fid,'\r\n');
                % Phase(s) out question
                fprintf(fid,'%s\r\n',char(out_list(nb)));
                stt=cell2mat(strfind(out_list(nb),' '));
                % Mode value (question = 0)
                if isempty(stt) % If one phase out, line (no space detected)
                    % Zero modal isopleth, line
                    fprintf(fid,'0\r\n');
                    % Isopleth question
                    fprintf(fid,'\r\n'); % Not answering
                    % P-T range
                    fprintf(fid,'\r\n'); % Default P range
                    fprintf(fid,'\r\n'); % Default T range
                    % P step (calculated from initial parameters)
                    fprintf(fid,'\r\n%.2f\r\n',Pstep);
                else % If two phases out, point (space detected)
                    % Zero modal isopleths (2), point
                    fprintf(fid,'0\r\n');
                    fprintf(fid,'0\r\n');
                    % No isopleth question
                    % Default P-T range (only one question if point)
                    fprintf(fid,'\r\n');
                end
                % Final question
                if nb~=length(out_list) % If not end of path
                    fprintf(fid,'\r\n'); % Launch new calculation
                else % If end of path
                    fprintf(fid,'n\r\n'); % Stop thermocalc
                end
            end
            % Close temporary file
            fclose(fid);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ISOPLETH WIZZARD
    elseif state==1
        if strcmp(isoname,'Name') | strcmp(isovalue,'Value') % If no isopleth name or value selected
            % Do nothing
            txt(1)={'No isopleth name'};
            txt(2)={'or value selected'};
            txtm=char(txt);
            menu(txtm,'Ok');
            list_asbl=[];
            out_list=[];
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Build the successive assemblages
            list_asbl(1)={init_ass}; % First assemblage=starting assemblage
            for bb=1:length(path)
                %%%%%
                if isempty( cell2mat (strfind(path(bb),'-')) ) % If ky-and-sill transition not present (not containing -)
                    check=cell2mat(strfind(list_asbl(bb),char(path(bb))));
                    if ~isempty (check) && length(check)==1 % Test: if phase is already present => it is an "out line"
                        % Delete phase from future assemblage
                        list_asbl(bb+1)=strrep(list_asbl(bb),path(bb),'');
                    else % Test: if phase is not present => it is an "in line"
                        % Add phase to future assemblage
                        list_asbl(bb+1)={[char(list_asbl(bb)) ' ' char(path(bb))]};
                    end
                    %%%%%
                else % If ky-sill-and transition
                    if  strcmp(path(bb),'sil-and') % sill-and transition
                        % Determine if sill or and was present before
                        check=cell2mat(strfind(list_asbl(bb),'sil')); % Find sill within previous assemblage
                        if ~isempty (check) % If sill present before (found sill)
                            % Replace sill by and
                            list_asbl(bb+1)=strrep(list_asbl(bb),'sil','and');
                        else % If and present before (not found sill)
                            % Replace and by sill
                            list_asbl(bb+1)=strrep(list_asbl(bb),'and','sil');
                        end
                        %%%%%
                    elseif  strcmp(path(bb),'kya-sil') % ky-sill transition
                        % Determine if ky or sill was present before
                        check=cell2mat(strfind(list_asbl(bb),'sil')); % Find sill within previous assemblage
                        if ~isempty (check) % If sill present before (found sill)
                            % Replace sill by ky
                            list_asbl(bb+1)=strrep(list_asbl(bb),'sil','kya');
                        else % If ky present before (not found sill)
                            % Replace ky by sill
                            list_asbl(bb+1)=strrep(list_asbl(bb),'kya','sil');
                        end
                        %%%%%
                    else % ky-and transition
                        % Determine if ky or and was present before
                        check=cell2mat(strfind(list_asbl(bb),'kya')); % Find ky within previous assemblage
                        if ~isempty (check) % If ky present before (found ky)
                            % Replace ky by and
                            list_asbl(bb+1)=strrep(list_asbl(bb),'kya','and');
                        else % If and present before (not found ky)
                            % Replace and by ky
                            list_asbl(bb+1)=strrep(list_asbl(bb),'and','kya');
                        end
                    end
                end
            end
            %%%
            % Loop to clean double spaces
            for clean=1:length(list_asbl);
                while ~isempty (cell2mat(strfind(list_asbl(clean),'  ')))
                    list_asbl(clean)=strrep(list_asbl(clean),'  ',' ');
                end
            end
            % Build assemblages for point calculation (append at the end)
            curs=length(list_asbl);
            for bb4=1:(length(list_asbl)-1) % Nb of points = Nb of lines - 1
                if length(char(list_asbl(bb4)))<length(char(list_asbl(bb4+1))) % If more characters, "in" line
                    list_asbl(bb4+curs)=list_asbl(bb4+1);
                elseif length(char(list_asbl(bb4)))>length(char(list_asbl(bb4+1))) % If less characters, "out" line
                    list_asbl(bb4+curs)=list_asbl(bb4);
                else % If ky-and-sill transition
                    check1=cell2mat(strfind(list_asbl(bb4),'sil'));
                    check2=cell2mat(strfind(list_asbl(bb4),'kya'));
                    check3=cell2mat(strfind(list_asbl(bb4),'and'));
                    check4=cell2mat(strfind(list_asbl(bb4+1),'sil'));
                    check5=cell2mat(strfind(list_asbl(bb4+1),'kya'));
                    check6=cell2mat(strfind(list_asbl(bb4+1),'and'));
                    if ~isempty(check1) && ~isempty(check5)     % sill->ky
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'kya']};
                    elseif ~isempty(check1) && ~isempty(check6) % sill->and
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'and']};
                    elseif ~isempty(check2) && ~isempty(check6) % ky->and
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'and']};
                    elseif ~isempty(check2) && ~isempty(check4) % ky->sill
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'sil']};
                    elseif ~isempty(check3) && ~isempty(check4) % and->sill
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'sil']};
                    else                                        % and->ky
                        list_asbl(bb4+curs)={[char(list_asbl(bb4)) ' ' 'kya']};
                    end

                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Build the phases out list, for lines
            for bb2=1:(length(path)+1)
                out_list(bb2)={''}; % All lines, no out phase because isopleth calculation
            end
            % Build the phases out list, for points (append at the end)
            cursor=length(out_list);
            for bb3=(cursor+1):(cursor+length(path))
                chk=char(path(bb3-cursor));
                if strcmp(chk,'kya-sil')
                    out_list(bb3)={'kya'};
                elseif strcmp(chk,'sil-and')
                    out_list(bb3)={'sil'};
                elseif strcmp(chk,'kya-and')
                    out_list(bb3)={'and'};
                else
                    out_list(bb3)={char(path(bb3-cursor))};
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Get back to ky and sill
            list_asbl=strrep(list_asbl,'kya','ky');
            out_list=strrep(out_list,'kya','ky');
            list_asbl=strrep(list_asbl,'sil','sill');
            out_list=strrep(out_list,'sil','sill');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Open, create and write in the temp file (wizztemp.txt)
            filetc=[param(1).pathin 'wizztemp.txt'];
            fid = fopen(filetc,'w+');
            %%% Loop for successive calculations
            for nb=1:length(out_list)
                % Assemblage
                fprintf(fid,'%s\r\n',char(list_asbl(nb)));
                % Variance (not answering)
                fprintf(fid,'\r\n');
                % Phase(s) out question
                if isempty(cell2mat(out_list(nb))) % Isopleth line
                    fprintf(fid,'%s\r\n',char(out_list(nb)));
                    stt=0;
                else % Isopleth point
                    fprintf(fid,'%s\r\n',char(out_list(nb)));
                    stt=1;
                end
                % Isopleth and P-T range questions
                if stt==0 % If line
                    % Isopleth question
                    fprintf(fid,'%s\r\n',isoname); % Isopleth name
                    fprintf(fid,'%s\r\n',isovalue); % Isopleth value
                    % P-T range
                    fprintf(fid,'\r\n'); % Default P range
                    fprintf(fid,'\r\n'); % Default T range
                    fprintf(fid,'%.2f\r\n',Pstep); % P step
                elseif stt==1 % If point
                    fprintf(fid,'0\r\n');
                    % Isopleth question
                    fprintf(fid,'%s\r\n',isoname); % Isopleth name
                    fprintf(fid,'%s\r\n',isovalue); % Isopleth value
                    fprintf(fid,'\r\n'); % Default P-T range (only one question if point)
                end
                % Final question
                if nb~=length(out_list) % If not end of path
                    fprintf(fid,'\r\n'); % Launch new calculation
                else % If end of path
                    fprintf(fid,'n\r\n'); % Stop thermocalc
                end
            end
            % Close temporary file
            fclose(fid);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Display hourglass on wizzard "GO" button
    im=imread('button_sablier.png');
    but_gowiz=imread('button_gowiz.png');
    set(sab,'cdata',im);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Start error timer
    Tw=timer('TimerFcn','cd(param.matpath);tckiller(param)','StartDelay',150);
    start(Tw);
    %%% Execute tc333.exe
    cd(param.pathin);
    [a,b]=dos('tc333.exe < wizztemp.txt');
    cd(param.matpath);
    % Stop and delete existing timers (tctxt and tckiller)
    stop(Tw);
    delete(timerfind);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Remove hourglass from "GO" button (calculation successfully done)
    set(sab,'cdata',but_gowiz);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%