function [lines1,D]=recut(lines)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=recut(...)
% Clear existing limits of selected line to allow subsequent cutting
%
% Input: - lines = struture array with calculated lines
%
% Output: - lines1 = struture array with calculated lines
%         - D = double number, number of the selected line
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

%%% Output
% Lines structure updated
lines1=lines;
% Size of lines structure
[slines1,slines2]=size(lines1);
% List of available line numbers
for i=1:slines2
    listl(i).l=lines1(i).lnum;
end
% Question for line number
D = menu('Cut single line ?',listl.l);
% Delete selected line limits
lines1(D).ltbegin=[];
lines1(D).lbegin=[];
lines1(D).ltend=[];
lines1(D).lend=[];
% Delete final coordinates used for plotting (linef)
if ~isempty (lines1(D).linef)
    lines1(D).linef=[];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%