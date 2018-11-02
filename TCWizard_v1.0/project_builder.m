%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% project_builder
% Builds project file for Thermocalc
%
%%%%%%%%%%%%%%%%%%           PRESS F5 TO START           %%%%%%%%%%%%%%%%%% 
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

%%% Variables
% Choose the name of the project file
project=inputdlg('Choose a project name','Name ?');
% Matlab package directory
matpath=cd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ask for the a-x model file
[namein,pathin]=uigetfile('*.txt','Choose a-x model file');
ax=strrep(namein,'tc-','');
ax=strrep(ax,'.txt','');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create test project to be read for composition and phases
test=[pathin 'tc-test.txt'];
fid1=fopen(test,'w+');
% Write basic information
fprintf(fid1,'axfile %s\r\ncalctatp yes\r\npseudosection yes\r\nsetmodeiso yes\r\nzeromodeiso yes\r\n*',ax);
fclose(fid1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modify tc-prefs file to allow reading test project
prefs=[pathin 'tc-prefs.txt'];
fid2=fopen(prefs,'r+');
% Put test as scriptfile
i=1;
while ~feof(fid2)
        fline(i)={fgetl(fid2)};
        if strfind( char(fline(i)),'scriptfile' ) % If scriptfile line
            fline(i)={'scriptfile test'}; % Replace by test
        end
        i=i+1;
end
fclose(fid2);
% Rewrite tc-prefs file
fid2=fopen(prefs,'w+');
for j=1:length(fline)
    fprintf(fid2,'%s\r\n',char(fline(j)));
end
fclose(fid2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare file for TC run
inirun=[pathin 'ini.txt'];
fid3=fopen(inirun,'w+');
fprintf(fid3,'\r\n\r\n\r\n\r\n0\r\nkill');
fclose(fid3);
% Run TC to generate the phase list and oxyde list
cd(pathin);
[s,t]=dos('tc333.exe < ini.txt');
cd(matpath);
%%% Isolate phase list
t2=strrep(t,'...','$'); % Begin
t3=strrep(t2,'choose from:','$'); % End
[av,ap]=strtok(t3,'$');
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
% Build available phase list (character array for questions)
defpl=[];
for d1=1:length(phaselist)
    defpl=[defpl ' ' char(phaselist(d1))];
end
%%% Isolate oxydes for composition
c2=strrep(t,'components to be specified : ','$'); % Begin
c3=strrep(c2,'the composition','$'); % End 
[av1,ap1]=strtok(c3,'$');
[oxydes,poub]=strtok(ap1,'$');
[oxy1,rest]=strtok(oxydes);
nr=1;
oxylist(nr)={oxy1};
while ~isempty (rest)
    nr=nr+1;
    [oxy, rest]=strtok(rest);
    oxylist(nr)={oxy};
end
oxylist(length(oxylist))=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create Project File
projectfile=[pathin 'tc-' char(project) '.txt'];
fid4=fopen(projectfile,'w+');
%%% Header
txt=['% Project file generated using projectbuilder - ' datestr(now)] ;
fprintf(fid4,'%s\r\n\r\n', txt);
%%% A-x model file
fprintf(fid4,'axfile %s\r\n\r\n', ax);
%%% Ignored phases
ask(1)={'List of ignored phases (separated by space)'};
ask(2)={['Available phases are : ' defpl]};
ignore_ask=char(ask);
ignore=inputdlg(ignore_ask,'Ignored phases ?');
if isempty(char(ignore))
    fprintf(fid4,'ignore\r\n\r\n');
    ignore_list=[];
else
    fprintf(fid4,'ignore %s\r\n\r\n', char(ignore));
    % Ignored phase cell array
    [ign1,rest]=strtok(char(ignore));
    ni=1;
    ignore_list(ni)={ign1};
    while ~isempty (rest)
        ni=ni+1;
        [ign, rest]=strtok(rest);
        ignore_list(ni)={ign};
    end
end
% Remove ignored phases from the list of available phases
defpl2=defpl;
if ~isempty(ignore_list)
    for k=1:length(ignore_list)
        if strfind(defpl, [' ' char(ignore_list(k)) ' '])
            defpl2=strrep(defpl2,[' ' char(ignore_list(k)) ' '],' ');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Prints
fprintf(fid4,'printxyz yes\r\nprintguessform yes\r\nprintbulkinfo yes\r\n\r\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Excess phases
bask(1)={'List of excess phases (separated by space)'};
bask(2)={['Available phases are : ' defpl2]};
excess_ask=char(ask);
excess=inputdlg(excess_ask,'Excess phases ?');
if isempty(char(excess))
    fprintf(fid4,'excess\r\n\r\n');
else
    fprintf(fid4,'excess %s\r\n\r\n', char(excess));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate T at P
fprintf(fid4,'calctatp ask\r\n\r\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Default P-T window
PTask=inputdlg({'Pmin Pmax(separated by space)','Tmin Tmax (separated by space)'},'P-T calculation range');
[Pmin,Pmax]=strtok(char(PTask(1)));
[Tmin,Tmax]=strtok(char(PTask(2)));
if ~isempty(Pmin) && ~isempty(Tmin) % P and T set
    fprintf(fid4,'setdefPwindow yes %s %s\r\n', Pmin, Pmax);
    fprintf(fid4,'setdefTwindow yes %s %s\r\n', Tmin, Tmax);
    1
elseif ~isempty(Pmin) && isempty(Tmin) % Only P set
    fprintf(fid4,'setdefPwindow yes %s %s\r\n', Pmin, Pmax);
    fprintf(fid4,'setdefTwindow yes 400 800\r\n'); % Default T
    2
elseif isempty(Pmin) && ~isempty(Tmin) % Only T set
    fprintf(fid4,'setdefPwindow yes 1 15\r\n'); % Default P
    fprintf(fid4,'setdefTwindow yes %s %s\r\n', Tmin, Tmax);
    3
else
    fprintf(fid4,'setdefPwindow yes 1 15\r\n'); % Default P
    fprintf(fid4,'setdefTwindow yes 400 800\r\n'); % Default T
    4
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set isopleths
fprintf(fid4,'setiso yes\r\n\r\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Composition
fprintf(fid4,'pseudosection yes\r\n\r\n');
hd='%------------------------------------------------------------------------------------';
fprintf(fid4,'%s\r\n',hd);
% If water excess, remove H2O from list
if strfind(char(excess),'H2O') % If water in excess
    oxylist(strmatch('H2O',oxylist))=[]; % Remove H2O component
end
% Build available oxyde list (character array for text file)
oxyl=[];
for d1=1:length(oxylist)
    oxyl=[oxyl '   ' char(oxylist(d1))];
end
fprintf(fid4,'            %s\r\n',oxyl); % Spaces, for setbulk
%%% Question for composition
compo=inputdlg(oxylist,'Composition (mol.%)');
comment=inputdlg('Add comment to the composition (e.g. initial)','Comment ?');
if ~isempty(char(comment))
    fprintf(fid4,'%s\r\n',['% ' char(comment)]);
end
fprintf(fid4,'setbulk yes     ');
for m=1:length(oxylist)
    fprintf(fid4,'%s   ',char(compo(m)));
end
fprintf(fid4,'\r\n%s\r\n\r\n',hd);
%%% Modal isopleths, dogmin, drawpd
fprintf(fid4,'setmodeiso yes\r\nzeromodeiso no\r\n\r\ndogmin no\r\n\r\ndrawpd yes\r\n*');
fclose(fid4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modify tc-prefs file to allow reading new project
prefs=[pathin 'tc-prefs.txt'];
fid2=fopen(prefs,'r+');
% Put test as scriptfile
i=1;
while ~feof(fid2)
        fline(i)={fgetl(fid2)};
        if strfind( char(fline(i)),'scriptfile' ) % If scriptfile line
            fline(i)={['scriptfile ' char(project)]}; % Replace by project name
        end
        i=i+1;
end
fclose(fid2);
% Rewrite tc-prefs file
fid2=fopen(prefs,'w+');
for j=1:length(fline)
    fprintf(fid2,'%s\r\n',char(fline(j)));
end
fclose(fid2);
%%%%%%%%%%%%%%%
% Delete test files
cd(pathin);
delete('tc-test.txt');
delete('tc-test-dr.txt');
delete('tc-test-o.txt');
delete('tc-log.txt');
delete('ini.txt');
cd(matpath);
%%%%%%%%%%%%%%%
% Success message
msgbox('Project file successfully created','Project file created','help');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%