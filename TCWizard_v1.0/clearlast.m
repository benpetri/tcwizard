function [lines, points]=clearlast(lines, points)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=clearlast(...)
% Delete selected line or point (for historical reason called clearlast)
%
% Input: - lines = struture array with calculated lines
%        - points = structure array with calculated points
%
% Output: - lines = struture array with calculated lines, updated after
%                   deleting selected line
%         - points = structure array with calculated points, updated after
%                    deleting selected point
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

% Size of structures
[sl1,sl2]=size(lines);
[sp1,sp2]=size(points);
% List of available points
for i=1:sl2
    listl(i).l=lines(i).lnum;
end
% List of available lines
for j=1:sp2
    listp(j).p=points(j).pnum;
end
% First question, choosing to delete line or point
C = menu('Clear...','Line','Point');
if C==1 % If delete line
    % Question
    D = menu('Clear ?',listl.l);
    lines(D)=([]);
    % Reassign all line numbers
    for k=1:sl2-1 
        lines(k).lnum=['u' num2str(k)];
    end
elseif C==2 % If delete point
    % Question
    E = menu('Clear ?',listp.p);
    points(E)=([]);
    % Reassign all point numbers
    for l=1:sp2-1
        points(l).pnum=['i' num2str(l)];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%