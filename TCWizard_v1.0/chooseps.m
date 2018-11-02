function lines1=chooseps(lines, points, choice)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=chooseps(...)
% Ask for line limits (begin and end) and update line structure
%
% Input: - lines = struture array with calculated lines
%        - points = structure array with calculated points
%        - choice = double number, number of the line to be cut
%
% Output: - lines1 = struture array with calculated lines, updated with
%                    line limits
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
% Sizes of structures
[spoints1,spoints2]=size(points);
[slines1,slines2]=size(lines);
% List of available points
for i=1:spoints2
    list(i).p=points(i).pnum;
end
% Additional choices
list(spoints2+1).p='begin';
list(spoints2+2).p='end';
list(spoints2+3).p='skip';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Question(s)
% Serial-cut mode
if nargin<3
    for m1=1:slines2 % For all lines
        if isempty(lines(m1).ltbegin) % If no begin chosen
            % Display menu text
            txtb=['Begin for u' num2str(m1)];
            txte=['End for u' num2str(m1)];
            % Question for begin
            index_ubegin=menu(txtb, list.p);
            text_ubegin=list(index_ubegin).p;
            if index_ubegin <= spoints2 % If point chosen
                % Store begin point text and coordinates
                lines1(m1).ltbegin=text_ubegin;
                lines1(m1).lbegin=points(index_ubegin).pcrd;
            elseif index_ubegin == spoints2+3 % If skip chosen
                % Nothing
            else % If 'begin' or 'end' chosen
                % Store begin point text only
                lines1(m1).ltbegin=text_ubegin;
            end
            %%%%%%%%%%%%%%%%%%
            % Question for end
            index_uend=menu(txte, list.p);
            text_uend=list(index_uend).p;
            if index_uend <= spoints2 % If point chosen
                % Store end point text and coordinates
                lines1(m1).ltend=text_uend;
                lines1(m1).lend=points(index_uend).pcrd;
            elseif index_ubegin == spoints2+3 % If skip chosen
                % nothing
            else % If 'begin' or 'end' chosen
                % Store end point text only
                lines1(m1).ltend=text_uend;
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Single line cut
elseif nargin==3 % 3rd argument = line number (choice)
    if isempty(lines(choice).ltbegin) % If no begin chosen
        % Display menu text
        txtb=['Begin for u' num2str(choice)];
        txte=['End for u' num2str(choice)];
        % Question for begin
        index_ubegin=menu(txtb, list.p);
        text_ubegin=list(index_ubegin).p;
        if index_ubegin <= spoints2 % If point chosen
            % Store begin point text and coordinates
            lines1(choice).ltbegin=text_ubegin;
            lines1(choice).lbegin=points(index_ubegin).pcrd;
        elseif index_ubegin == spoints2+3 % If skip chosen
            % Nothing
        else % If 'begin' or 'end' chosen
            % Store begin point text only
            lines1(choice).ltbegin=text_ubegin;
        end
        %%%%%%%%%%%%%%%%%%
        % Question for end
        index_uend=menu(txte, list.p);
        text_uend=list(index_uend).p;
        if index_uend <= spoints2 % If point chosen
            % Store end point text and coordinates
            lines1(choice).ltend=text_uend;
            lines1(choice).lend=points(index_uend).pcrd;
        elseif index_ubegin == spoints2+3 % If skip chosen
            % Nothing
        else % If 'begin' or 'end' chosen
            % Store end point text only
            lines1(choice).ltend=text_uend;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%