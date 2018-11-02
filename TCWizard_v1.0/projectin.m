function [v2,v3,v4,phaselist]=projectin(param,excess,phaselist,ignore,Tmin,Tmax,Pmin,Pmax,ex,buttonadd,axes,proj_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=paramin(...)
% Add available phases to the main figure
% Input:  - param = structure with initial parameters (see paramin)
%         - excess = cell array of excess phases specified in the project
%           file
%         - phaselist = cell array of available phases (without excess
%           phases)
%         - ignore = cell array of ignored phases specified in the
%           project file
%         - Tmin, Tmax = handles to the edit text boxes for the T° range
%         - Pmin, Pmax = handles to the edit text boxes for the P° range
%         - ex = handles to the static text displaying the excess phases
%         - buttonadd = handles to the listbox of available phases for
%           Wizzard
%         - axes = handles to figure axes
%         - proj_name = handles to the static text displaying the project
%           name
%
% Output: - v2 = vector of handles to build checkboxes for the assemblage
%         - v3 = vector of handles to build checkboxes for the modal
%           proportions
%         - v4 = vector of handles to build the edit text boxes for mode
%           values
%         - phaselist = cell array, updated phase list without excess
%           phases
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

% Delete ignored phases in phase list
for pi=1:length(ignore)
    phaselist(strcmp(phaselist(1:end),ignore(pi)))=[];
end
% Delete excess phases in phase list
for pe=1:length(excess)
    phaselist(strcmp(phaselist(1:end),excess(pe)))=[];
end
% Set default P-T range in edit text boxes
set(Tmin,'String',num2str(param(1).PTrange(1,1)));
set(Tmax,'String',num2str(param(1).PTrange(1,2)));
set(Pmin,'String',num2str(param(1).PTrange(2,1)));
set(Pmax,'String',num2str(param(1).PTrange(2,2)));
% Resize axes according to the P-T range
set (axes,'Xlim', [str2num(get(Tmin,'String')) str2num(get(Tmax,'String'))]);
set (axes,'Ylim', [str2num(get(Pmin,'String')) str2num(get(Pmax,'String'))]);
% Display excess phases in the static text box
txte=[];
for ne=1:length(excess)
    txte=[txte ' ' char(excess(ne))];
end
txte_fin=['Excess phases + ' txte];
set(ex,'String',txte_fin);
% Display project name in the static text box
[ok,no]=strtok(param.project,'.');
[tc,ok]=strtok(ok,'-');
[ok,no]=strtok(ok,'-');
set(proj_name, 'String',ok);
% Set phase list without excess phases into the listbox for Wizzard
list_box=phaselist;
list_box(end+1)={'ky-sill'};
list_box(end+1)={'sill-and'};
list_box(end+1)={'ky-and'};
set(buttonadd,'String',list_box);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create vector of handles for the checkboxes and edit text boxes
np=length(phaselist);
% Available space between upper and lower buttons (calculate step size)
Z=(495-15*np)/(np-1);
% Initial row
v1(1) = uicontrol('Style','text','String',phaselist(1),'Position', [0 595 42.5 15]);
v2(1) = uicontrol('Style','checkbox','Position', [55 595 15 15]);
v3(1) = uicontrol('Style','checkbox','Position', [90 595 15 15]);
v4(1) = uicontrol('Style','edit', 'String', '0', 'Position', [117.5 595 42.5 15]);
% Loop for successive rows
for pl=2:np
    v1(pl) = uicontrol('Style','text','String',phaselist(pl),'Position', [0 (620-25-(pl-1)*(Z+15)) 42.5 15]);
    v2(pl) = uicontrol('Style','checkbox','Position', [55 (620-25-(pl-1)*(Z+15)) 15 15]);
    v3(pl) = uicontrol('Style','checkbox','Position', [90 (620-25-(pl-1)*(Z+15)) 15 15]);
    v4(pl) = uicontrol('Style','edit', 'String', '0', 'Position', [117.5 (620-25-(pl-1)*(Z+15)) 42.5 15]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%