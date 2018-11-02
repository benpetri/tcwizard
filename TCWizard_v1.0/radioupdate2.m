function radioupdate2(hObject,eventdata,u35,u36,u37,u34)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% radioupdate2(...)
% Enable/disable text fields related to "Mode Wizard" mode or "Isopleth Wizard" mode
%
% Input: - hObject: handles of graphical objects
%        - eventdata: reserved - to be defined in a future version of MATLAB
%        - handles of the graphical objects
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

% Get current status
sss=guihandles(hObject);
val1=sss.radiobutton3;
val2=sss.radiobutton4;
value=get(hObject,'SelectedObject');
% Enable / Disable
if value==val1 % Enabled -> disable
    set(u35,'Enable','off');
    set(u36,'Enable','off');
    set(u37,'Enable','off');
    set(u34,'Enable','on');
elseif value==val2 % Disabled -> enable
    set(u35,'Enable','on');
    set(u36,'Enable','on');
    set(u37,'Enable','on');
    set(u34,'Enable','off');
end