function [loglines, logpoints]=reado(Pathin, excess)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=reado(...)
% Read Thermocalc results from the tc-log.txt file
%
% Input: - Pathin = character array with path to the log file
%          (i.e. project file)
%         - excess = cell array of excess phases specified in the project
%           file
%
% Output: - loglines = struture array with log data for lines
%         - logpoints = structure array with log data for points
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

% !!!!! Sometimes, the mode values are not dispayed in the log file ???
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Definition of variables
i1=0; % Line marker
j1=0; % Point marker
inc=1; % To read 2 modal values
% Marker for calculation type (0=Zero Modal isopleth 1=Modal isopleth 2=Compositional isopleth 3=Isolated object)
sttus=0; 
% Structures for lines and points log data
tloglines = struct ('phases', {}, 'ass', {}, 'nullphase', {},'marker', {});
logpoints = struct ('phases', {}, 'ass', {}, 'nullphase1', {}, 'nullphase2', {});
% Marker
% !!!!! Sometimes, the mode values are not dispayed in the log file ???
marker=0; % (1=line OK with log data - 0=line BAD without log data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Import log file
% Open log file
fid = fopen([Pathin 'tc-log.txt']);
while ~feof(fid)
    fline=fgetl(fid); % Read each line
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Phase(s) out question
    if ( length(fline)>7 && strcmp(fline(1:8),'which to') )
        % Extract phase(s) out
        [question,important]=strtok(fline,':');
        [dots,mins]=strtok(important);
        %%% Test if line-point or isolated object
        if strcmp(mins,' (nothing input)') % If isolated object
            S=1; % treated as points
            sttus=3;
        end
        [min1,min2]=strtok(mins);
        % For non-zero modal isopleths with excess H20
        bckupphase=min1;
        if isempty(min2)
            S=0; % Marker for line, i.e. only one phase out
        else
            S=1; % Marker for point, i.e. two phases out
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Determine if non-zero modal isopleths are calculated
    elseif ( length(fline)>24 && strcmp(fline(1:25),'specifying mode isopleths') ) 
        % Marker for modal isopleth calculation
        sttus=1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Determine if compositional isopleths are calculated
    elseif ( length(fline)>19 && strcmp(fline(1:20),'specifying isopleths') ) 
        % Marker for compositional isopleth calculation
        sttus=2;
        % Extract the calculated isopleth
        isol=strrep(fline,'specifying isopleths for','');
        isol=strrep(isol,'(','');
        calciso=strrep(isol,'):',''); 
        % Check status line/point calculation again
        if strcmp(important,': (nothing input)') % If no phase out entered
            % Line for compositional isopleth
            S=0;
        elseif sttus==2 && isempty(min2)
            % Point for composition isopleth
            S=1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % Read mode or isopleth value (MUST be single value, not a list)
    elseif( length(fline)>15 && strcmp(fline(1:16),'  list of values') )
        if S==0 % If line calculation, the 'list of values' line will be seen only once
            [text,need]=strtok(fline,':');
            [dot,value]=strtok(need);
            value=str2num(value);
        elseif S==1 && inc==1 % If point calculation, the 'list of values' line will be seen twice (1st)
            % Store first value
            [text,need]=strtok(fline,':');
            [dot,value]=strtok(need);
            value1=str2num(value);
            inc=inc+1;
        elseif S==1 && inc==2 % If point calculation, the 'list of values' line will be seen twice (2nd)
            % Store second value
            [text,need]=strtok(fline,':');
            [dot,value]=strtok(need);
            value2=str2num(value);
            inc=1;
            % Test if calculated mode values are 0 or not
            if value1==0 && value2==0
                sttus=0; % Reset sttus to 0 (contradicts initial detection of non-zero mode calculation)
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Read mode names line
    elseif ( length(fline)>7 && strcmp(fline(1:8),'    mode') )
        [mode,rest]=strtok(fline);
        if S==0 % If line calculation
            i1=i1+1;
            npl=0;
            % Store phases
            while ~isempty (rest)
                npl=npl+1;
                [min, rest]=strtok(rest);
                field=['p' num2str(npl)];
                % Substructure of phases field
                tloglines(i1).phases.(field)=min;
                % Phases displayed, line OK
                tloglines(i1).marker=1; 
                marker=1; % OK
            end
        else % If point calculation
            j1=j1+1;
            npp=0;
            % Store phases
            while ~isempty (rest)
                npp=npp+1;
                [min, rest]=strtok(rest);
                field=['p' num2str(npp)];
                % Substructure of phases field
                logpoints(j1).phases.(field)=min;
                % Phases displayed, point OK
                marker=1; % OK
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Read P-T coordinates
    elseif ( length(fline)>10 && strcmp(fline(1:2),'pt') )
        if marker==0 % Mode not displayed, BAD line, but update increment anyway for P-T coordinates
            if S==0 % If line calculation
                i1=i1+1;
                tloglines(i1).marker=0; % BAD line
            else % If point calculation
                j1=j1+1;
            end
        end
        % Extract P-T coordinates
        [ptguess,rest]=strtok(fline);
        [P,T]=strtok(rest);
        P=str2num(P);
        T=str2num(T);
        if S==0 % If line calculation
            tloglines(i1).crd=[P T];
        else % If point calculation
            logpoints(j1).crd=[P T];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Read compositional isopleth line
    elseif ( length(fline)>10 && strcmp(fline(1:3),'xyz') )
        % Extract compositional isopleth name and value
        [xyz,rest]=strtok(fline);
        [isoname,rest]=strtok(rest);
        isoname=strrep(isoname,'(','');
        isoname=strrep(isoname,')','');
        [isoval,rest]=strtok(rest);
        isoval=str2num(isoval);
        if S==0 % If line calculation
            tloglines(i1).(isoname)=isoval;
        else % If point calculation
            logpoints(j1).(isoname)=isoval;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Read mode values line
    elseif ( length(fline)>10 && strcmp(fline(1:7),'rbi yes') )
        [rbi,rest]=strtok(fline);
        [yes,rest]=strtok(rest);
        mode_tot=[];
        % Build the list of mode values
        while ~isempty (rest) 
            [mode, rest]=strtok(rest);
            mode_tot=[mode_tot str2num(mode)];
        end
        % It can be 0=zero mode, 1=any mode, 2=any isopleth 3=isolated object
        if sttus==0 && S==0 % LINE for zero mode
            index=find(mode_tot==0);
        elseif sttus==0 && S==1 % POINT for zero mode
            index=find(mode_tot==0);
        elseif sttus==1 % LINE or POINT for any non-zero mode
            if S==0 % If line calculation
                index=find(mode_tot==value);
            else % If point calculation
                index(1)=find(mode_tot==value1);
                index(2)=find(mode_tot==value2);
            end
        elseif sttus==2 % LINE or POINT for compositional isopleths
            if S==0 % If line calculation
                index=[];
            elseif S==1 % If point calculation (intersection between compositional isopleth and 0 modal line only)
                index=find(mode_tot==0);
            end
        elseif sttus==3 % If isolated object, not creating index
            index=[1 1 1];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if length(index)<=1 && sttus~=2 % LINE for modal isopleths
            % Store mode values vector
            tloglines(i1).mode=mode_tot;
            % Store phase out
            phase_list=struct2cell(tloglines(i1).phases);
            if length(index)==0
                nullphase=bckupphase;
            else
            nullphase=char(phase_list(index(1)));
            end
            tloglines(i1).nullphase=nullphase;
            %%%%%%%%%%%%%%%%%%%
            % Create assemblage
            asbl=[];
            for a1=1:length(phase_list)
                % Add to assemblage if not an excess phase
                put=[];
                for rep=1:length(excess)
                    if ~strcmp(char(phase_list(a1)),char(excess(rep))) % Not excess phase
                        put(rep)=0;
                    else
                        put(rep)=1;
                    end
                end
                if sum(put)==0 % Not excess phase
                    % Add to assemblage
                    asbl=[asbl char(phase_list(a1)) ' '];
                end
                % Store individual mode values
                fld=['mode_' char(phase_list(a1))];
                tloglines(i1).(fld)=mode_tot(a1);
            end
            % Loop to clean double spaces
            clean=strfind(asbl,'  ');
            while ~isempty (clean)
                asbl=strrep(asbl,'  ',' ');
                clean=strfind(asbl,'  ');
            end
            % Delete nullphase from assemblage
            asbl=strrep(asbl,nullphase,'');
            asbl=strrep(asbl,'  ',' ');
            % Delete initial space if present
            while strcmp(asbl(1),' ')
                asbl(1)=[];
            end
            % Create final assemblage (ex: st g pl bi - chl)
            asbl=[asbl ' - ' nullphase];
            % Store assemblage
            tloglines(i1).ass=asbl;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif length(index)==1 && sttus==2 % POINT for compositional isopleths
            % Store mode values vector
            logpoints(j1).mode=mode_tot;
            % Store phase out
            phase_list=struct2cell(logpoints(j1).phases);
            nullphase1=char(phase_list(index));
            logpoints(j1).nullphase1=nullphase1;
            %%%%%%%%%%%%%%%%%%%
            % Create assemblage
            asbp=[];
            for a1=1:length(phase_list)
                % Add to assemblage if not an excess phase
                for rep=1:length(excess)
                    if ~strcmp(char(phase_list(a1)),char(excess(rep))) % Not excess phase
                        put(rep)=0;
                    else
                        put(rep)=1;
                    end
                end
                if sum(put)==0 % Not excess phase
                    % Add to assemblage
                    asbp=[asbp char(phase_list(a1)) ' '];
                end
            end
            % Delete nullphase
            asbp=strrep(asbp,nullphase1,'');
            asbp=strrep(asbp,'  ',' ');
            while strcmp(asbp(1),' ')
                asbp(1)=[];
            end
            % Create final assemblage (ex: st g pl bi - chl)
            asbp=[asbp ' - ' nullphase1];
            % Store assemblage
            logpoints(j1).ass=asbp;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif length(index)==2 % POINT for modal isopleths
            % Store mode values vector
            logpoints(j1).mode=mode_tot;
            % Store phases out
            phase_list=struct2cell(logpoints(j1).phases);
            nullphase1=char(phase_list(index(1)));
            nullphase2=char(phase_list(index(2)));
            logpoints(j1).nullphase1=nullphase1;
            logpoints(j1).nullphase2=nullphase2;
            %%%%%%%%%%%%%%%%%%%
            % Create assemblage
            asbp=[];
            for a1=1:length(phase_list)
                % Add to assemblage if not an excess phase
                put=[];
                for rep=1:length(excess)
                    if ~strcmp(char(phase_list(a1)),char(excess(rep))) % Not excess phase
                        put(rep)=0;
                    else
                        put(rep)=1;
                    end
                end
                if sum(put)==0 % Not excess phase
                    % Add to assemblage
                    asbp=[asbp char(phase_list(a1)) ' '];
                end
            end
            % Delete nullphases from assemblage
            asbp=strrep(asbp,nullphase1,'');
            asbp=strrep(asbp,nullphase2,'');
            % Loop to clean double spaces
            clean=strfind(asbp,'  ');
            while ~isempty (clean)
                asbp=strrep(asbp,'  ',' ');
                clean=strfind(asbp,'  ');
            end
            % Delete initial space if present
            while strcmp(asbp(1),' ')
                asbp(1)=[];
            end
            % Create final assemblage (ex: st g pl bi - chl mu)
            asbp=[asbp ' - ' nullphase1 ' ' nullphase2];
            % Store assemblage
            logpoints(j1).ass=asbp;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif length(index)==3 % ISOLATED object
            % Store mode values vector
            logpoints(j1).mode=mode_tot;
            % Store phases out = 'none'
            logpoints(j1).nullphase1='none';
            logpoints(j1).nullphase2='none';
            %%%%%%%%%%%%%%%%%%%
            % Create assemblage
            phase_list=struct2cell(logpoints(j1).phases);
            asbp=[];
            for a1=1:length(phase_list)
                % Add to assemblage if not an excess phase
                put=[];
                for rep=1:length(excess)
                    if ~strcmp(char(phase_list(a1)),char(excess(rep))) % Not excess phase
                        put(rep)=0;
                    else
                        put(rep)=1;
                    end
                end
                if sum(put)==0 % Not excess phase
                    % Add to assemblage
                    asbp=[asbp char(phase_list(a1)) ' '];
                end
            end
            % Loop to clean double spaces
            clean=strfind(asbp,'  ');
            while ~isempty (clean)
                asbp=strrep(asbp,'  ',' ');
                clean=strfind(asbp,'  ');
            end
            % Delete initial space if present
            while strcmp(asbp(1),' ')
                asbp(1)=[];
            end
            % Store assemblage
            logpoints(j1).ass=asbp;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else % LINE for compositional isopleths
            if tloglines(i1).marker==1 % If line OK
                phase_list=struct2cell(tloglines(i1).phases);
                %%%%%%%%%%%%%%%%%%%
                % Create assemblage
                asbl=[];
                put=[];
                for a1=1:length(phase_list)
                    % Add to assemblage if not an excess phase
                    for rep=1:length(excess)
                        if ~strcmp(char(phase_list(a1)),char(excess(rep))) % Not excess phase
                            put(rep)=0;
                        else
                            put(rep)=1;
                        end
                    end
                    if sum(put)==0 % Not excess phase
                        % Add to assemblage
                        asbl=[asbl char(phase_list(a1)) ' '];
                    end
                    % Store individual mode values
                    fld=['mode_' char(phase_list(a1))];
                    tloglines(i1).(fld)=mode_tot(a1);
                end
                % Loop to clean double spaces
                clean=strfind(asbl,'  ');
                while ~isempty (clean)
                    asbl=strrep(asbl,'  ',' ');
                    clean=strfind(asbl,'  ');
                end
                % Delete initial space if present
                while strcmp(asbl(1),' ')
                    asbl(1)=[];
                end
                % Create final assemblage (ex: st g pl bi - )
                asbl=[asbl ' - '];
                % Store assemblage
                tloglines(i1).ass=asbl;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Deal with BAD lines
% If mode was not displayed (BAD line), put empty structure
[sl1,sl2]=size(tloglines);
ttt=1;
while ttt<=sl2
    if tloglines(ttt).marker==0; % If BAD line
        % Empty
        tloglines(ttt)=[];
        [sl1,sl2]=size(tloglines);
    else
        ttt=ttt+1;
    end
end
% Delete structure field 'marker' to detect OK or BAD line
tloglines=rmfield(tloglines, 'marker');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MERGE according to assemblage
% Build the list of available assemblages
export=struct2cell(tloglines);
ass_list=export(2 ,: ,:);
list=unique(ass_list(:));
[sl1,sl2]=size(tloglines);
% Build the empty loglines structure
n=fieldnames(tloglines);
for brr=1:length(n)
    loglines.(char(n(brr)))=[];
end
%
ia=1;
for ia=1:length(list) % For all different assemblages
    li=1;
    for k=1:sl2 % For all temporary loglines
        if strcmp(list(ia),tloglines(k).ass) % If assemblage is similar
            if li==1 % If structure for this assemblage is empty
                loglines(ia)=tloglines(k);
            else % If structure for this assemblage is already filled
                for f=4:(length(n)) % Starting at 4 because 3 first fields similar (1:phases 2:ass 3:nullphase)
                    field=char(n(f));
                    if ~isempty(tloglines(k).(field))
                        loglines(ia).(field)(li,:)=tloglines(k).(field);
                    end
                end
            end
            li=li+1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%