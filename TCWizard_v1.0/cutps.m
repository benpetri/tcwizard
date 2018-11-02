function lines=cutps(lines, points)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=cutps(...)
% Cut lines according to user's selected limits
%
% Input: - lines = struture array with calculated lines
%        - points = structure array with calculated points
%
% Output: - lines = struture array with calculated lines, updated with
%                   final coordinates
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

% Sizes of structures
[spoints1,spoints2]=size(points);
[slines1,slines2]=size(lines);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store final coordinates between begin and end
for cc=1:slines2 % For all lines
    % Fill in markers
    sp1=1;
    sp2=1;
    sp3=1;
    sp4=1;
    % Number of coordinates
    [sizelcrd1,sizelcrd2]=size(lines(cc).lcrd);
    % Sort coordinates
    %lines(cc).lcrd=sortrows(lines(cc).lcrd);
    if ~isempty(lines(cc).ltbegin) % If begin and end were chosen (with chooseps)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% NON-EMPTY LINES
        if ~isempty(lines(cc).lcrd) % If non-empty line
            if lines(cc).ltbegin(1)=='i' && lines(cc).ltend(1)=='i'  % Coordinates for begin and end are known
                %%%%% POSITIVE coefficient (increasing P for increasing T) %%%%%
                if lines(cc).lcrd(1,2) < lines(cc).lcrd(end,2) % Curve with increasing temperature
                    if lines(cc).lbegin(1,2) < lines(cc).lend(1,2) % If Tbegin < Tend
                        % Begin point, first row
                        lines(cc).linef(1,:)=lines(cc).lbegin(1,:);
                        % Fill in the rows with the appropriate coordinates
                        for dd=1:sizelcrd1 
                            if lines(cc).lcrd(dd,2)>lines(cc).lbegin(1,2) && lines(cc).lcrd(dd,2)<lines(cc).lend(1,2) % If Tbegin < Tcoordinate < Tend
                                % Store coordinate
                                lines(cc).linef(sp1+1,:)=lines(cc).lcrd(dd,:);
                                sp1=sp1+1;
                            else
                                continue
                            end
                        end
                        % End point, last row (sp1+1)
                        lines(cc).linef(sp1+1,:)=lines(cc).lend(1,:);
                        %%%%
                    elseif lines(cc).lbegin(1,2) > lines(cc).lend(1,2) % If Tbegin > Tend (user's mistake !)
                        % Begin point, first row
                        lines(cc).linef(1,:)=lines(cc).lbegin(1,:);
                        % End point, last row
                        lines(cc).linef(2,:)=lines(cc).lend(1,:);
                        % Warning
                        txt=['Probably wrong choice for ' lines(cc).lnum];
                        menu(txt,'Ok');
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEGATIVE coefficient (decreasing P for increasing T) %%%%%
                else  
                    if lines(cc).lbegin(1,2) < lines(cc).lend(1,2) % If Tbegin < Tend
                        % Begin point, first row
                        lines(cc).linef(1,:)=lines(cc).lbegin(1,:);
                        % Fill in the rows with the coordinates (inverse scan of coordinates)
                        for dd=sizelcrd1:-1:1
                            if lines(cc).lcrd(dd,1)>lines(cc).lend(1,1) && lines(cc).lcrd(dd,1)<lines(cc).lbegin(1,1) % If Pbegin < Pcoordinate < Pend
                                % Store coordinate
                                lines(cc).linef(sp1+1,:)=lines(cc).lcrd(dd,:);
                                sp1=sp1+1;
                            else
                                continue
                            end
                        end
                        % End point, last row (sp1+1)
                        lines(cc).linef(sp1+1,:)=lines(cc).lend(1,:);
                        % Sort final coordinates
                        lines(cc).linef=sortrows(lines(cc).linef);
                        %%%
                    elseif lines(cc).lbegin(1,2) > lines(cc).lend(1,2) % If Tbegin > Tend (user's mistake !)
                         % Begin point, first row
                        lines(cc).linef(1,:)=lines(cc).lbegin(1,:);
                        % End point, last row
                        lines(cc).linef(2,:)=lines(cc).lend(1,:);
                        % Warning
                        txt=['Probably wrong choice for ' lines(cc).lnum];
                        menu(txt,'Ok');
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif lines(cc).ltbegin(1)=='b' && lines(cc).ltend(1)=='i'  % Coordinates for begin are not known, but are known for end
                %%%%% POSITIVE coefficient (increasing P for increasing T) %%%%%
                if lines(cc).lcrd(1,2) < lines(cc).lcrd(sizelcrd1,2)
                    % Fill in the rows with the appropriate coordinates
                    for dd=1:sizelcrd1
                        if lines(cc).lcrd(dd,2)<lines(cc).lend(1,2) % If Tcoordinate < Tend
                            % Store coordinate
                            lines(cc).linef(dd,:)=lines(cc).lcrd(dd,:);
                        else
                            break
                        end
                    end
                    % End point, last row
                    lines(cc).linef(end,:)=lines(cc).lend(1,:);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEGATIVE coefficient (decreasing P for increasing T) %%%%%
                else
                    % Fill in the rows with the coordinates (inverse scan of coordinates)
                    for dd=sizelcrd1:-1:1
                        if lines(cc).lcrd(dd,1)>lines(cc).lend(1,1) % If Pcoordinate > Pend
                            % Store coordinate
                            lines(cc).linef(sp3,:)=lines(cc).lcrd(dd,:);
                            sp3=sp3+1;
                        else
                            continue
                        end
                    end
                    % End point, last row
                    lines(cc).linef(sp3,:)=lines(cc).lend(1,:);
                    % Sort final coordinates
                    lines(cc).linef=sortrows(lines(cc).linef);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif lines(cc).ltbegin(1)=='i' && lines(cc).ltend(1)=='e'  % Coordinates for begin are known but are not known for end
                %%%%% POSITIVE coefficient (increasing P for increasing T) %%%%%
                if lines(cc).lcrd(1,2) < lines(cc).lcrd(sizelcrd1,2)
                    % Begin point, first row
                    lines(cc).linef(1,:)=lines(cc).lbegin(1,:); 
                    % Fill in the rows with the appropriate coordinates
                    for dd=1:sizelcrd1
                        if lines(cc).lcrd(dd,1)>lines(cc).lbegin(1,1) % If Pbegin < Pcoordinate
                            % Store coordinates
                            lines(cc).linef(sp4+1,:)=lines(cc).lcrd(dd,:);
                            sp4=sp4+1;
                        else
                            continue
                        end
                    end
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEGATIVE coefficient (decreasing P for increasing T) %%%%%
                else
                    % Begin point, first row
                    lines(cc).linef(1,:)=lines(cc).lbegin(1,:);
                    % Fill in the rows with the coordinates (inverse scan of coordinates)
                    for dd=sizelcrd1:-1:1
                        if lines(cc).lcrd(dd,1)<lines(cc).lbegin(1,1) % If Pbegin > Pcoordinate
                            lines(cc).linef(sp4+1,:)=lines(cc).lcrd(dd,:);
                            sp4=sp4+1;
                        else
                            continue
                        end
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            else    % If coordinates for begin and end are not known
                % Fill in with all coordinates
                lines(cc).linef=lines(cc).lcrd; 
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% EMPTY LINES
        else % If empty line
            if lines(cc).ltbegin(1)=='i' && lines(cc).ltend(1)=='i'  % Coordinates for begin and end are known
                % Assign begin and end points to coordinates
                lines(cc).lcrd(1,:)=lines(cc).lbegin(1,:);
                lines(cc).lcrd(2,:)=lines(cc).lend(1,:);
                lines(cc).linef(:,:)=lines(cc).lcrd(:,:);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%