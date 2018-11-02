function list_path=buttondel(list2,list_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=buttonadd(...)
% Delete selected phase in the phase list for the Wizard mode
%
% Input: - list2 = Double with the phase selected in the right panel
%        - list_path = Cell array with the old phase list for the
%        Wizzard mode
%
% Output: - list_path = Cell array with the new phase list for the
%        Wizzard mode
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

% Get selected item from listbox2
delete=get(list2,'Value');
if delete==length(list_path)
    set(list2,'Value',length(list_path)-1);
    list_path(delete)=[];
else    
    list_path(delete)=[];
end
%
if length(list_path)~=0
    set(list2,'String',list_path);
else
    set(list2,'Value',0);
    set(list2,'String',list_path);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%