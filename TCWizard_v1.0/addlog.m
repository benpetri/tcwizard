function [lines1, points1,isolated1]=addlog(lines, loglines, points, logpoints,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=addlog(...)
% Adds log data to line/point structures
%
% Input: - lines = struture array with calculated lines
%        - loglines = struture array with log data for lines
%        - points = struture array with calculated points
%        - logpoints = structure array with log data for points
%        - isolated = structure array with isolated objects
%
% Output: - lines1 = struture array with calculated lines, updated after
%           adding data
%         - points1 = struture array with calculated points, updated after
%           adding data
%         - isolated = structure array with isolated objects
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Definition of variables for lines
lines1=lines;
[sl1,sl2]=size(lines);
[so1,so2]=size(loglines);
n=fieldnames(loglines);
%%% Add log data to lines
for i1=1:sl2 % For all lines
    for j1=1:so2 % For all loglines
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Case 1, line with modal isopleths
        if lines(i1).liso==0
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(lines(i1).lass,loglines(j1).ass) % Same line with same assemblage
                [slcrd1,slcrd2]=size(lines(i1).lcrd);
                [socrd1,socrd2]=size(loglines(j1).crd);
                if slcrd1==socrd1 % If same number of points
                    if slcrd1>2 % 'Normal' line with more than 2 points
                        for i2=1:slcrd1 % For all coordinates
                            % Make sure coordinates are similar
                            if (abs(lines(i1).lcrd(i2,1))-(loglines(j1).crd(i2,1))<=0.05) && (abs(lines(i1).lcrd(i2,2))-(loglines(j1).crd(i2,2))<=1)
                                for f=5:length(n) % Starting at 5 because 4 first fields similar (1:phases 2:ass 3:nullphase 4:coordinates)
                                    field=char(n(f));
                                    if ~isempty (loglines(j1).(field))
                                        % Fill in log data in lines
                                        lines1(i1).(field)(i2,:)=loglines(j1).(field)(i2,:);
                                    end
                                end
                            end
                        end
                    elseif slcrd1==2 % Line with 2 points, identical or not
                        if lines(i1).lcrd(1,:)==lines(i1).lcrd(2,:) % Line with one point, doubled
                            for i2=1:slcrd1 % For all coordinates
                                for f=5:length(n) % Starting at 5 because 4 first fields similar (1:phases 2:ass 3:nullphase 4:coordinates)
                                    field=char(n(f));
                                    if ~isempty (loglines(j1).(field))
                                        % Fill in log data in lines
                                        lines1(i1).(field)(i2,:)=loglines(j1).(field)(1,:);
                                    end
                                end
                            end
                        else % Line with 2 different points
                            for i2=1:slcrd1 % For all coordinates
                                % Make sure coordinates are similar
                                if (abs(lines(i1).lcrd(i2,1))-(loglines(j1).crd(i2,1))<=0.05) && (abs(lines(i1).lcrd(i2,2))-(loglines(j1).crd(i2,2))<=1)
                                    for f=5:length(n) % Starting at 5 because 4 first fields similar (1:phases 2:ass 3:nullphase 4:coordinates)
                                        field=char(n(f));
                                        if ~isempty (loglines(j1).(field))
                                            % Fill in log data in lines
                                            lines1(i1).(field)(i2,:)=loglines(j1).(field)(i2,:);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Case 2, line with compositional isopleths
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(lines(i1).lass,loglines(j1).ass) % Same line with same assemblage
                [slcrd1,slcrd2]=size(lines(i1).lcrd);
                [socrd1,socrd2]=size(loglines(j1).crd);
                if slcrd1==socrd1 % If same number of points
                    if slcrd1>2 % 'Normal' line with more than 2 points
                        for i2=1:slcrd1 % For all coordinates
                            % Make sure coordinates are similar
                            if (abs(lines(i1).lcrd(i2,1))-(loglines(j1).crd(i2,1))<=0.05) && (abs(lines(i1).lcrd(i2,2))-(loglines(j1).crd(i2,2))<=1)
                                for f=5:length(n) % Starting at 5 because 4 first fields similar (1:phases 2:ass 3:nullphase 4:coordinates)
                                    field=char(n(f));
                                    if ~isempty (loglines(j1).(field))
                                        % Fill in log data in lines
                                        lines1(i1).(field)(i2,:)=loglines(j1).(field)(i2,:);
                                    end
                                end
                            end
                        end
                    elseif slcrd1==2 % Line with 2 points, identical or not
                        if lines(i1).lcrd(1,:)==lines(i1).lcrd(2,:) % Line with one point, doubled
                            for i2=1:slcrd1 % For all coordinates
                                for f=5:length(n) % Starting at 5 because 4 first fields similar (1:phases 2:ass 3:nullphase 4:coordinates)
                                    field=char(n(f));
                                    if ~isempty (loglines(j1).(field))
                                        % Fill in log data in lines
                                        lines1(i1).(field)(i2,:)=loglines(j1).(field)(1,:);
                                    end
                                end
                            end
                        else % Line with 2 different points
                            for i2=1:slcrd1 % For all coordinates
                                % Make sure coordinates are similar
                                if (abs(lines(i1).lcrd(i2,1))-(loglines(j1).crd(i2,1))<=0.05) && (abs(lines(i1).lcrd(i2,2))-(loglines(j1).crd(i2,2))<=1)
                                    for f=5:length(n) % Starting at 5 because 4 first fields similar (1:phases 2:ass 3:nullphase 4:coordinates)
                                        field=char(n(f));
                                        if ~isempty (loglines(j1).(field))
                                            % Fill in log data in lines
                                            lines1(i1).(field)(i2,:)=loglines(j1).(field)(i2,:);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Definition of variables for points
points1=points;
[sp1,sp2]=size(points);
[sop1,sop2]=size(logpoints);
m=fieldnames(logpoints);
%%% Add log data to points
for x1=1:sp2 % For all points
    for y1=1:sop2 % For all logpoints
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Case 1, point with modal isopleths
        if points(x1).iso==0
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(points(x1).pass,logpoints(y1).ass) % Same point with same assemblage
                % Make sure coordinates are similar
                if ( abs(points(x1).pcrd(1))-(logpoints(y1).crd(1))<=0.05) && (abs(points(x1).pcrd(1))-(logpoints(y1).crd(1))<=1)
                    for g=6:length(m) % Starting at 6 because 5 first fields similar (1:phases 2:ass 3:nullphase1 4:nullphase2 5:coordinates)
                        field2=char(m(g));
                        if ~isempty (logpoints(y1).(field2))
                            % Fill in log data in points
                            points1(x1).(field2)(1,:)=logpoints(y1).(field2)(1,:);
                        end
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Case 2, point with modal isopleths
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            compare=[num2str(points(x1).iso) logpoints(y1).ass];
            if strcmp(points(x1).pass,compare) % Same point with same assemblage
                % Make sure coordinates are similar
                if ( abs(points(x1).pcrd(1))-(logpoints(y1).crd(1))<=0.05) && (abs(points(x1).pcrd(1))-(logpoints(y1).crd(1))<=1)
                    for g=6:length(m) % Starting at 6 because 5 first fields similar (1:phases 2:ass 3:nullphase1 4:nullphase2 5:coordinates)
                        field2=char(m(g));
                        if ~isempty (logpoints(y1).(field2))
                             % Fill in log data in points
                            points1(x1).(field2)(1,:)=logpoints(y1).(field2)(1,:);
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Definition of variables for isolated objects
isolated1=isolated;
[si1,si2]=size(isolated);
[sop1,sop2]=size(logpoints);
l=fieldnames(logpoints);
%%% Add log data to isolated
for x1=1:si2 % For all points
    for y1=1:sop2 % For all logpoints
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        isolated(x1).pass=strrep(isolated(x1).pass,'  ',' '); % Clear possible double space at the end of assemblage
        if strcmp(isolated(x1).pass,logpoints(y1).ass) % Same assemblage
            % Make sure coordinates are similar
            if ( abs(isolated(x1).pcrd(1))-(logpoints(y1).crd(1))<=0.05) && (abs(isolated(x1).pcrd(2))-(logpoints(y1).crd(2))<=1)
                for g=6:length(l) % Starting at 6 because 5 first fields similar (1:phases 2:ass 3:nullphase1 4:nullphase2 5:coordinates)
                    field2=char(l(g));
                    if ~isempty (logpoints(y1).(field2))
                        % Fill in log data in points
                        isolated1(x1).(field2)(1,:)=logpoints(y1).(field2)(1,:);
                    end
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%