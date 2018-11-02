function tckiller(param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% tckiller (...)
% Kill Thermocalc running in the background if error
%
% Input: - param = structure of initial parameters (see paramin)
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

%%% Project directory
cd(param.pathin);
%%% Error message - Question
h = questdlg('Possible wrong calculation. Abort ?','Error','Yes','No','Yes');
if strcmp(h,'Yes') % If YES, kill tc process
    % Create tckill text file for dos commands
    filekill=[param.pathin 'tckill.txt'];
    fid = fopen(filekill,'w+');
    fprintf(fid,'%s\r\n','tasklist');
    fclose(fid);
    % Run tasklist
    [a,b]=dos('cmd.exe < tckill.txt');
    %%% Test if TC still running
    ttt=strfind(b,'tc333.exe');
    if ~isempty(ttt);
        %%% Retrieve process ID
        % Delete all spaces
        b=strrep(b,' ','');
        % Isolate tc333.exe process
        b=strrep(b,'tc333.exe','$');
        [b1,b2]=strtok(b,'$');
        index=strfind(b2,'Console');
        % Process ID
        extract=b2(2:index(1)-1);
        % Update tckill text file
        txtkill=['taskkill /F /PID ' extract];
        fid = fopen(filekill,'w+');
        fprintf(fid,'%s\r\n',txtkill);
        fclose(fid);
        % Run taskkill
        [a,b]=dos('cmd.exe < tckill.txt');
    end
    %%% Matlab directory
        cd(param.matpath);
else % If NO, ask question again after 12 seconds
    % Start repeat question timer
    Q=timer('TimerFcn','cd(param.matpath);tckiller(param)','StartDelay',15);
    start(Q);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%