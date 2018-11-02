function list_path=buttonadd(list1,list2,list_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=buttonadd(...)
% Add selected phase in the phase list for the Wizard mode
%
% Input: - list1 = Double with the phase selected in the left panel
%        - list2 = Double with the phase selected in the right panel
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

% Get phase list in listbox1
list_box=get(list1,'String');
%
% Get number of elements in listbox2
tmp=get(list2,'String');
if isempty(tmp)
    nbp=1;
else
    nbp=length(tmp)+1;
end
%
% Put selected phase from listbox1 into listbox2
select=list_box(get(list1,'Value'));
list_path(nbp)=select;
set(list2,'String',list_path);
set(list2,'Value',nbp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%