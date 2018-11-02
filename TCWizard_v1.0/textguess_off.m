function textguess_off(param,static)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% textguess_off(...)
% Restore the original project file
% Important : The code is also used as a Close Request Function for the
%             main figure
%
% Input:  - param = structure with initial parameters (see paramin)
%         - static = handles to the static text box displaying the starting
%                    guesses used for calculation
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

%%% Normal use for new starting guess
if nargin>1 % If two arguments
    % Open and write the original project file
    fid1 = fopen([param.pathin param.project],'w+');
    fprintf(fid1,'%c',param.protext);
    fclose(fid1);
    %%%%%%%%%%%%%%%%%%%%
    % Update static text
    set(static,'String','Using initial project file');
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Used as a Close Request Function when wizzard is closed
    % Restore the original project file (param.protext)
    %%%%%
    %%% Quit question
    quit_status = questdlg('Do you really want to quit TCWizard ?','Quit ?','Yes','No','No');
    switch quit_status,
        case 'Yes',
            % Import parameters from the main workspace
            param=evalin('base','param');
            if ~isempty(param) % If project chosen
                % Open and write the original project file
                fid1 = fopen([param.pathin param.project],'w+');
                fprintf(fid1,'%c',param.protext);
                fclose(fid1);
                % Close main figure
                delete(get(0,'CurrentFigure'));
            else % If no project selected
                % Close main figure
                delete(get(0,'CurrentFigure'));
            end
        case 'No'
            return
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%