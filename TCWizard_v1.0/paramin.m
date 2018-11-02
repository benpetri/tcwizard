function [param,excess,phaselist,ignore]=paramin(param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=paramin
% Gather initial parameters for Thermocalc calculations
%
% Input:  - param = empty structure
%
% Output: - param = structure with intitial parameters. Fields are
%               * pathin = path to the Thermocalc package
%               * project = project name (tc-xxx.txt)
%               * resultfile = result file tc-xxx-dr.txt
%               * axfile = a-x model file (ex: tc-NCKFMASH)
%               * ofile = tc-xxx-o.txt
%               * PTrange = user's selected P&T min, max
%               * matpath = path to the Matlab package
%               * protext = character array containing the entire project
%                           file
%         - excess = cell array of excess phases specified in the project
%           file
%         - phaselist = cell array of available phases (still with excess
%           phases)
%         - ignore = cell array of ignored phases specified in the
%           project file
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

% Excess array
excess={};
% Ask for project file
[Namein,Pathin]=uigetfile('*.txt','Project file ?');
filein=[Pathin Namein];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Building param structure
% Store the path to the Thermocalc package
param(1).pathin=Pathin;
param(1).project=Namein;
% Store the path to the Matlab package
param.matpath=cd;
% Create -dr and -o file names
prj_ss_txt=strrep(param.project,'.txt','');
param(1).resultfile=[prj_ss_txt '-dr.txt'];
param(1).ofile=[prj_ss_txt '-o.txt'];
% Open the project file
fid = fopen(filein);
% Looking for parameters in the project file
Tfile=fread(fid);
if ~isempty(Tfile) % if file is not empty
    fseek(fid, 0, 'bof');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read the file, line after line and store data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while ~feof(fid)
        fline=fgetl(fid); % read line
        %
        if ( length(fline)>5 && strcmp(fline(1:6),'axfile') ) % Reading a-x file name
            [ax,space]=strtok(fline);
            [system,void]=strtok(space);
            param(1).axfile=system;
        elseif ( length(fline)>6 && strcmp(fline(1:6),'ignore') ) % Reading ignored phases
            [set,rest]=strtok(fline);
            nex=0;
            % Store ignored phases 1 by 1
            while ~isempty (rest)
                nex=nex+1;
                [ign_phase, rest]=strtok(rest);
                ignore(nex)={ign_phase};
            end
            % Delete possible empty cells
            ignore(strcmp(ignore(1:end),''))=[]; % if additional spaces
        elseif ( length(fline)>8 && strcmp(fline(1:9),'setexcess') ) % Reading excess phases
            [set,rest]=strtok(fline);
            nex=0;
            % Store excess phases 1 by 1
            while ~isempty (rest)
                nex=nex+1;
                [phase, rest]=strtok(rest);
                excess(nex)={phase};
            end
            % Delete possible empty cells
            if ~isempty(excess)
                excess(strcmp(excess(1:end),''))=[]; % if additional spaces
            end
        elseif ( length(fline)>12 && strcmp(fline(1:13),'setdefTwindow') ) % Reading def T window
            [set,rest]=strtok(fline);
            [yes,range]=strtok(rest);
            [Tmin,Tmax]=strtok(range);
            param(1).PTrange(1,1)=str2num(Tmin);
            param(1).PTrange(1,2)=str2num(Tmax);
        elseif ( length(fline)>12 && strcmp(fline(1:13),'setdefPwindow') ) % Reading def P window
            [set,rest]=strtok(fline);
            [yes,range]=strtok(rest);
            [Pmin,Pmax]=strtok(range);
            param(1).PTrange(2,1)=str2num(Pmin);
            param(1).PTrange(2,2)=str2num(Pmax);
        end
    end
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create 1run.txt file to build phase list
firstrun=[param.pathin '1run.txt'];
fid2=fopen(firstrun,'w+');
fprintf(fid2,'\r\n\r\n');
fclose(fid2);
% Run TC to generate the phase list
cd(param.pathin);
[s,t]=dos('tc333.exe < 1run.txt');
cd(param.matpath);
% Isolate phase list
t2=strrep(t,'...','$');
t3=strrep(t2,'choose from','$'); % if no ignored phases
t4=strrep(t3,'phases ignored','$'); % in case ignored phases
[av,ap]=strtok(t4,'$');
[list,poub]=strtok(ap,'$');
[phase1,rest]=strtok(list);
np=1;
phaselist(np)={phase1};
while ~isempty (rest)
    np=np+1;
    [phase, rest]=strtok(rest);
    phaselist(np)={phase};
end
phaselist(length(phaselist))=[];
% Open and read the project file
fid1 = fopen([param.pathin param.project]);
% Store the original project file
param.protext = fscanf(fid1, '%c', inf);
fclose(fid1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%