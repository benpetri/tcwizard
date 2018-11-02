function drawout(lines, points, param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% drawout(...)
% Create dr-out.txt file with Thermocalc results for drawpd (in the project
% directory)
%
% Input: - lines = struture array with calculated lines
%        - points = structure array with calculated points
%        - param = structure with initial parameters (see paramin)
%
% For the field of lines and points structures, see readps
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

% Creating and opening the text file
Namedraw='dr-out.txt';
filedraw=[param.pathin Namedraw];
fid = fopen(filedraw,'w+');
% Write 2=Number of variables for each line of data; 7=Components - excess phases
% Write 2 1 (column 2 = abscissa; column 1 = ordinate
fprintf(fid,'2\r\n\r\n7\r\n\r\n2 1');
% Size of structures
[spoints1,spoints2]=size(points);
[slines1,slines2]=size(lines);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Loops for writing
% Points
for n1=1:spoints2
    % Header
    header='% ------------------------------';
    fprintf(fid,'\r\n%s\r\n',header);
    if isempty(points(n1).pcrd) % If not found during calculation
        comment='%';
        fprintf(fid,'%s %s %s not calculated\r\n\r\n',comment, points(n1).pnum, points(n1).pass );
    else % If calculated
        % Write assemblage
        fprintf(fid,'%s %s\r\n\r\n',points(n1).pnum, points(n1).pass );
        % Write coordinates
        [spcrd1,spcrd2]=size(points(n1).pcrd);
        for n2=1:spcrd1
            % Write isopleth values
            phasesout=['% ' points(n1).pphase1, ' = ' num2str(points(n1).piso1) ', ' points(n1).pphase2 ' = ' num2str(points(n1).piso2)];
            fprintf(fid,'%3.2f %3.2f  %s\r\n', points(n1).pcrd(n2,1), points(n1).pcrd(n2,2), phasesout);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lines
for m1=1:slines2
    % Header
    header='% ------------------------------';
    fprintf(fid,'\r\n%s\r\n',header);
    if isempty (lines(m1).lcrd) && isempty (lines(m1).ltbegin)  % If not found during calculation and not cut yet
        comment='%';
        fprintf(fid,'%s %s %s   not calculated\r\n\r\n',comment, lines(m1).lnum, lines(m1).lass );
    else % If calculated
        % Write assemblage
        fprintf(fid,'%s %s\r\n\r\n',lines(m1).lnum, lines(m1).lass );
        if isempty(lines(m1).ltbegin) % If no begin and end point chosen
            fprintf(fid,'begin end\r\n\r\n');
        end
        if isempty(lines(m1).lcrd) % If empty line connecting two defined points
            fprintf(fid,'%s %s connect\r\n\r\n',lines(m1).ltbegin, lines(m1).ltend);
        else % Line with begin and end point chosen
            fprintf(fid,'%s %s\r\n\r\n',lines(m1).ltbegin, lines(m1).ltend);
        end
        % Write coordinates
        [slcrd1,slcrd2]=size(lines(m1).lcrd);
        for m2=1:slcrd1
            % Write isopleth values
            phaseout=['% ' lines(m1).lphase ' = ' num2str(lines(m1).liso)];
            fprintf(fid,'%3.2f %3.2f  %s\r\n', lines(m1).lcrd(m2,1), lines(m1).lcrd(m2,2), phaseout);
        end
    end
end
% End of file
fprintf(fid,'\r\n*\r\n\r\n*');
Tmin=param.PTrange(1,1);
Tmax=param.PTrange(1,2);
Pmin=param.PTrange(2,1);
Pmax=param.PTrange(2,2);
% P-T range and ticks
fprintf(fid,'\r\nwindow %d %d %d %d\r\n\r\nbigticks 50 %d 1 %d\r\n\r\nsmallticks 5 0.1\r\n\r\ndarkcolour 0 0 0\r\n\r\nnumbering yes\r\n\r\n*',Tmin, Tmax, Pmin, Pmax, Tmin, Pmin);
% Close file
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%