function radioupdate1(hObject,eventdata,u51,u52,u53)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% radioupdate1(...)
% Enable/disable text fields related to "Isopleth" mode or "Mode" mode
%
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
val1=sss.radiobutton1;
val2=sss.radiobutton2;
value=get(hObject,'SelectedObject'); % Get status of the 
% Enable / Disable
if value==val1 % Enabled -> disable
    set(u51,'Enable','off');
    set(u52,'Enable','off');
    set(u53,'Enable','off');
elseif value==val2 % Disabled -> enable
    set(u51,'Enable','on');
    set(u52,'Enable','on');
    set(u53,'Enable','on');
end