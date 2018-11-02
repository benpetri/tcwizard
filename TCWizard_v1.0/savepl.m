function savepl(lines, points, param, excess, phaselist,ignore,data,cb,iminfo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% savepl (...)
% Save the initial parameters for wizzard and the data calculated with
% Thermocalc into a matlab .mat file.
% 
% Input :  - lines = structure with calculated lines
%           - points = structure with calculated points
%           - excess = cell array of excess phases specified in the project
%           file
%           - phaselist = cell array of available phases (without excess
%           phases)
%           - param = structure of initial parameters (see paramin)
%           - ignore = cell array of ignored phases specified in the
%           project file
%           - data = structure with dogmin data
%           - cb = double number,state of background image (0=not displayed 1=displayed)
%           - iminfo = structure with information on the background image (see bcgim_in)
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

cd(param.pathin);
[svname,svpath]=uiputfile('*.mat','Save to ...');
cd(svpath);
save (svname,'lines','points','param', 'excess', 'phaselist','ignore','data','cb','iminfo');
cd(param.matpath);
