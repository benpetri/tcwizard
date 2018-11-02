function resetaxes(param,axes,Tmin,Tmax,Pmin,Pmax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% resetaxes(...)
% Reset axes to P-T limits from the project file
%
% Input : - param = structure of initial parameters (see paramin)
%         - axes = handles to the figure axes
%         - Tmin, Tmax = handles to the edit text boxes for the T° range
%         - Pmin, Pmax = handles to the edit text boxes for the P° range
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

% Reset axes limits
set (axes,'Xlim', [param.PTrange(1,1) param.PTrange(1,2)]);
set (axes,'Ylim', [param.PTrange(2,1) param.PTrange(2,2)]);
% Reset P-T range
set (Tmin,'String', num2str(param.PTrange(1,1)));
set (Tmax,'String', num2str(param.PTrange(1,2)));
set (Pmin,'String', num2str(param.PTrange(2,1)));
set (Pmax,'String', num2str(param.PTrange(2,2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%