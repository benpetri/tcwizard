function wizz_log(lines,points,param,start_ass,first_ph,list,radio,isn,isv,list_asbl,out_list,diml1,dimp1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% wizz_log(...)
% Generate log file of Wizard mode calculation
%
% Input : - lines = struture array with calculated lines
%         - points = structure array with calculated points
%         - param = structure of initial parameters (see paramin)
%         - start_ass = handles to the edit text box with the starting
%                       assemblage
%         - first_ph = handles to the edit text box with the phase out
%                      along the path
%         - list = handles to the listbox with the successive phases out or
%                  in along the path
%         - radio = handles to the radiobutton for modal or compositional
%                   isopleth calculation
%         - isn = handles to the edit text box with the name of the
%                 compositional isopleth
%         - isv = handles to the edit text box with the value of the
%                 compositional isopleth
%          - list_asbl = cell array with the list of the successive
%                        assemblages calculated by wizzard
%          - out_list = cell array with the list of the successive
%                       phase(s) out
%          - diml1 = size of lines structure before wizard calculation
%          - dimp1 = size of points structure before wizard calculation
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

% Get parameters from wizard calculation
init_ass=get(start_ass,'String'); % get starting assemblage
init_phase=get(first_ph,'String'); % get phase out to follow
path=get(list,'String'); % get successive phases in/out
state=get(radio,'Value'); %get Mode/Isopleth radiobutton 0=Mode 1=Isopleths
isoname=get(isn,'String'); % get isopleth name
isovalue=get(isv,'String'); % get isopleth value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% If wizard calculation performed
if ~isempty(list_asbl) && ~isempty(out_list)
    % Sizes of structures
    [spoints1,spoints2]=size(points);
    [slines1,slines2]=size(lines);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MODE WIZARD
    if state==0
        % Create and open log file
        filelog=[param(1).pathin 'wizzard_log.txt'];
        fid2 = fopen(filelog,'w+');
        % Title
        fprintf(fid2,'Mode wizzard log file\r\n\r\n');
        % Summary of initial parameters
        path_ch=[];
        for k=1:length(path)
            path_ch=[path_ch ' -> ' char(path(k))];
        end
        fprintf(fid2,'Wizzard calculation parameters\r\n\t- starting assemblage : %s\r\n\t- phase out : %s\r\n\t- path : %s\r\n__________________________________________________________________\r\n\r\n',init_ass,init_phase,path_ch);
        % Results
        fprintf(fid2,'RESULTS :\r\n\r\n***** Lines *****\r\n\r\n');
        for llog=1:(length(path)+1) % for all calculated lines
            asbw=strrep(char(list_asbl(llog)),char(out_list(llog)),''); % Delete phase out from assemblage
            asbw=[asbw '  - ' char(out_list(llog))];
            fprintf(fid2,'-----------------------------------------\r\nCalculated : %s\r\n',asbw);
            t1=sort(asbw);
            t1=strrep(t1,' ',''); % delete spaces
            mk=0;
            % Prepare line status (calculated/existing before/not found)
            for zz=1:slines2
                t2=sort(lines(zz).lass);
                t2=strrep(t2,' ',''); %delete spaces
                if strcmp(t1,t2)
                    if zz>diml1 % if calculated using wizzard
                        [d1,d2]=size(lines(zz).lcrd);
                        fprintf(fid2,'Found %d data points, stored in line %s\r\n-----------------------------------------\r\n\r\n',d1,lines(zz).lnum);
                        mk=1;
                    elseif zz<=diml1 % if calculated before
                        fprintf(fid2,'Line already exists, line %s\r\n-----------------------------------------\r\n\r\n',lines(zz).lnum);
                        mk=1;
                    else % if not found
                        if lines(zz).keep==1
                            fprintf(fid2,'Nothing found, line %s kept empty\r\n-----------------------------------------\r\n\r\n',lines(zz).lnum);
                            mk=1;
                        end
                    end
                end
            end
            % After trying all lines, see if the line was not deleted
            if mk==0 % if line not found and deleted
                fprintf(fid2,'Nothing found, line deleted\r\n-----------------------------------------\r\n\r\n');
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(fid2,'\r\n***** Points *****\r\n\r\n');
        for plog=(length(path)+2):(length(list_asbl)) % for all calculated points
            [p1,rest]=strtok(out_list(plog));
            [p2,rest]=strtok(rest);
            p1=char(p1);
            p2=char(p2);
            asbw2=strrep(char(list_asbl(plog)),p1,''); % Delete phase1 out from assemblage
            asbw2=strrep(asbw2,p2,''); % Delete phase2 out from assemblage
            asbw2=[asbw2 '  - ' p1 ' ' p2];
            fprintf(fid2,'-----------------------------------------\r\nCalculated : %s\r\n',asbw2);
            t3=sort(asbw2);
            t3=strrep(t3,' ',''); % Delete spaces
            % Prepare point status (calculated/existing before/not found)
            for yy=1:spoints2
                t4=sort(points(yy).pass);
                t4=strrep(t4,' ',''); % Delete spaces
                if strcmp(t3,t4)
                    if yy>dimp1 % if calculated using wizzard
                        if (strcmp(p1,points(yy).pphase1) | strcmp(p1,points(yy).pphase2)) && (strcmp(p2,points(yy).pphase1) | strcmp(p2,points(yy).pphase2)) % if phases out in common
                            fprintf(fid2,'Found point, stored in point %s\r\n-----------------------------------------\r\n\r\n',points(yy).pnum);
                        end
                    elseif yy<=dimp1% if calculated before
                        if (strcmp(p1,points(yy).pphase1) | strcmp(p1,points(yy).pphase2)) && (strcmp(p2,points(yy).pphase1) | strcmp(p2,points(yy).pphase2)) % if phases out in common
                            fprintf(fid2,'Point already exists, point %s\r\n-----------------------------------------\r\n\r\n',points(yy).pnum);
                        end
                    else % not found
                        fprintf(fid2,'Nothing found\r\n-----------------------------------------\r\n\r\n');
                    end
                end
            end
        end
        fclose(fid2);
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ISOPLETH WIZARD
        % Create log file
        filelog=[param(1).pathin 'wizzard_log.txt'];
        fid2 = fopen(filelog,'w+');
        % Title
        fprintf(fid2,'Isopleth wizzard log file\r\n\r\n');
        % Summary of initial parameters
        path_ch=[];
        for k=1:length(path)
            path_ch=[path_ch ' -> ' char(path(k))];
        end
        fprintf(fid2,'Wizzard calculation parameters\r\n\t- starting assemblage : %s\r\n\t- isopleth : %s\r\n\t- path : %s\r\n__________________________________________________________________\r\n\r\n',init_ass,isoname,path_ch);
        % Results
        fprintf(fid2,'RESULTS :\r\n\r\n***** Lines *****\r\n\r\n');
        for llog=1:(length(path)+1) % for all calculated lines
            asbw=[char(list_asbl(llog)) '  - '];
            fprintf(fid2,'-----------------------------------------\r\nCalculated : %s\r\n',asbw);
            % Build compare assemblage
            t1=[num2str(str2num(isovalue)) asbw];
            t1=sort(t1);
            t1=strrep(t1,' ',''); % Delete spaces
            mk=0;
            % Prepare line status (calculated/existing before/not found)
            for zz=1:slines2
                t2=sort(lines(zz).lass);
                t2=strrep(t2,' ',''); % Delete spaces
                if strcmp(t1,t2)
                    if zz>diml1 % if calculated using wizzard
                        [d1,d2]=size(lines(zz).lcrd);
                        fprintf(fid2,'Found %d data points, stored in line %s\r\n-----------------------------------------\r\n\r\n',d1,lines(zz).lnum);
                        mk=1;
                    elseif zz<=diml1% if calculated before
                        fprintf(fid2,'Line already exists, line %s\r\n-----------------------------------------\r\n\r\n',lines(zz).lnum);
                        mk=1;
                    else % not found
                        if lines(zz).keep==1
                            fprintf(fid2,'Nothing found, line %s kept empty\r\n-----------------------------------------\r\n\r\n',lines(zz).lnum);
                            mk=1;
                        end
                    end
                end
            end
            % After trying all lines, see if the line was not deleted
            if mk==0 % if line not found and deleted
                fprintf(fid2,'Nothing found, line deleted\r\n-----------------------------------------\r\n\r\n');
            end
        end
        fprintf(fid2,'\r\n***** Points *****\r\n\r\n');
        for plog=(length(path)+2):(length(list_asbl)) % for all calculated points
            p1=char(out_list(plog)); % phase out
            asbw2=strrep(char(list_asbl(plog)),p1,''); % Delete phase1 out from assemblage
            asbw2=[asbw2 '  - ' p1];
            fprintf(fid2,'-----------------------------------------\r\nCalculated : %s\r\n',asbw2);
            % Build compare assemblage
            t3=[num2str(str2num(isovalue)) asbw2];
            t3=sort(t3);
            t3=strrep(t3,' ',''); % Delete spaces
            % Prepare point status (calculated/existing before/not found)
            for yy=1:spoints2
                t4=sort(points(yy).pass);
                t4=strrep(t4,' ',''); % Delete spaces
                if strcmp(t3,t4)
                    if yy>dimp1 % if calculated using wizzard
                        if ( strcmp(p1,points(yy).pphase1) | strcmp(p1,points(yy).pphase2) ) % if phase out in common
                            fprintf(fid2,'Found point, stored in point %s\r\n-----------------------------------------\r\n\r\n',points(yy).pnum);
                        end
                    elseif yy<=dimp1% if calculated before
                        if ( strcmp(p1,points(yy).pphase1) | strcmp(p1,points(yy).pphase2) ) % if phase out in common
                            fprintf(fid2,'Point already exists, point %s\r\n-----------------------------------------\r\n\r\n',points(yy).pnum);
                        end
                    else % not found
                        fprintf(fid2,'Nothing found\r\n-----------------------------------------\r\n\r\n');
                    end
                end
            end
        end
        % Close log file
        fclose(fid2);
    end
end