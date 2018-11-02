function [lines,points,isolated]=readps(param,lines,points,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=readps(...)
% Read Thermocalc results from the tc-xxx-dr.txt file
%
% Input: - param = structure with initial parameters (see paramin)
%        - lines = struture array with calculated lines
%        - points = structure array with calculated points
%        - isolated = structure array with isolated lines/points
%
% Output: - lines = struture array with calculated lines, updated after
%           reading
%         - points = struture array with calculated points, updated after
%           reading
%        - isolated = structure array with isolated lines/points
%
% For the field of lines, points and isolated structures, see below
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

% Define the lines and points structures to be used
if isempty (lines) % If line structure is empty
    % structure lines 'lnum' : character array, line number (ex: u1)
    %                 'lass' : character array, line assemblage (ex: g st pl - chl)
    %                 'lal'  : substructure, line assemblage list (ex: p1 = 'g', p2 = 'st' ...)
    %                 'lcrd' : double numbers, line P-T coordinates (ex: 1.5 550.0)
    %                 'lphase' : character array, phase out
    %                 'lbegin' : double numbers, coordinates of begin point
    %                 'ltbegin' : character array, coordinates of begin point
    %                 'lend' : double numbers, coordinates of end point
    %                 'ltend' : character array, coordinates of end point
    %                 'linef' : double numbers, line P-T coordinates after cutting
    %                 'liso' : double number, line modal or compositional isopleth, if present (ex: %x(g)=0.95)
    %                 'keep' : double numer, marker to keep line (0=asking if delete 1=not asking if delete)
    %                 'sim' : double numer, marker if similar object (0=unique 1=similar)
    lines = struct ('lnum', {}, 'lass', {}, 'lal', {}, 'lcrd', {}, 'lphase', {},'lbegin',{},'ltbegin',{},'lend',{},'ltend',{},'linef',{}, 'liso', {}, 'keep',{},'sim',{});
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Count for lines
    i1=0; %lines
else % If line structure is not empty
    % Update line number
    [sinl1,sinl2]=size(lines);
    i1=sinl2;
end
if isempty (points) % If points structure is empty
    % structure points 'pnum' : character array, point number (ex: i1)
    %                  'pass' : character array, point assemblage (ex: g st pl - bi chl)
    %                  'pal'  : substructure, point assemblage list (ex: p1 = 'g', p2 = 'st' ...)
    %                  'pcrd' : double numbers, point P-T coordinates (ex: 1.5 550.0)
    %                  'pphase1' : character array, phase out 1
    %                  'pphase2' : character array, phase out 2
    %                  'piso1' : double number, isopleth 1 value (ex: %x(g)=0.95)
    %                  'piso1' : double number, isopleth 2 value (ex:%g=0.01)
    %                  'sim' : double numer, marker if similar object (0=unique 1=similar)
    points = struct ('pnum', {}, 'pass', {}, 'pal', {}, 'pcrd', {}, 'pphase1', {}, 'pphase2', {}, 'piso1', {}, 'piso2', {},'iso', {},'sim',{});
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Count for points
    j1=0; % points
else % If points structure is not empty
    % Update point number
    [sinp1,sinp2]=size(points);
    j1=sinp2;
end
if isempty (isolated) % If isolated structure is empty
    % structure isolated 'pnum' : character array, point number (ex: i1)
    %                    'pass' : character array, point assemblage (ex: g st pl - bi chl)
    %                    'pal'  : substructure, point assemblage list (ex: p1 = 'g', p2 = 'st' ...)
    %                    'pcrd' : double numbers, point P-T coordinates (ex: 1.5 550.0)
    %                    'sim' : double numer, marker if similar object (0=unique 1=similar)
    isolated = struct ('pnum', {}, 'pass', {}, 'pal', {}, 'pcrd', {}, 'sim',{});
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Count for isolated
    s1=0; % isolated points
else % If isolated structure is not empty
    % Update point number
    [sini1,sini2]=size(isolated);
    s1=sini2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open the result file
filein=[param.pathin param.resultfile];
fid = fopen(filein);
% Test if file is empty
Tfile=fread(fid);
if ~isempty(Tfile)
    fseek(fid, 0, 'bof');
    % Counts for coordinates
    i2=1; % Line coordinates
    j2=1; % Point coordinates
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read the file, line after line and store data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while ~feof(fid)
        fline=fgetl(fid);
        if isempty(fline)==1 % Empty line
            continue
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif fline(1)=='%' % '%---' line
            continue
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif fline(1)=='b' % 'begin end' line
            continue
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif fline(1)=='u' % Line assemblage text
            % Separate line number from line assemblage
            [u,lass]=strtok(fline);
            % Remove spaces at the beginning
            while strcmp(lass(1),' ')
                lass(1)=[];
            end
            % Extract phases and phase out
            nb=1;
            [p,rest]=strtok(lass);
            phases(nb)={p};
            while ~isempty(rest)
                nb=nb+1;
                [p,rest]=strtok(rest);
                phases(nb)={p};
            end
            % Delete '-' and '' characters
            phases(strcmp(phases(1:end),'-'))=[];
            phases(strcmp(phases(1:end),''))=[];
            % Sort phases alphabetically
            phases=sort(phases);
            % Update line count
            i1=i1+1;
            %%%%%%%%%%%%%%%%%%%%%
            %%% Fill in structure
            [tls1,tls2]=size(lines); % Temporary lines size
            if tls2==0 % If lines structure empty
                t=0; % Marker (0=line 1=point 2=delete)
                i2=1;
                % Line number
                lines(i1).lnum=['u' num2str(i1)];
                % Line assemblage (text)
                lines(i1).lass=lass;
                % Line assemblage list (substructure)
                for al=1:length(phases)
                    fieldname=['p' num2str(al)];
                    lines(i1).lal.(fieldname)=phases(al);
                end
                % Default keep
                lines(i1).keep=0;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            else % If lines structure already filled
                t=0; % Marker (0=line 1=point 2=delete)
                i2=1;
                % Line number
                lines(i1).lnum=['u' num2str(i1)];
                % Line assemblage (text)
                lines(i1).lass=lass;
                % Line assemblage list (substructure)
                for al=1:length(phases)
                    fieldname=['p' num2str(al)];
                    lines(i1).lal.(fieldname)=phases(al);
                end
                % Default keep
                lines(i1).keep=0;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif fline(1)=='i' % Point assemblage text
            % Separate line number from line assemblage
            [i,pass]=strtok(fline);
            % Remove spaces at the beginning
            while strcmp(pass(1),' ')
                pass(1)=[];
            end
            % Extract phases and phases out
            nb=1;
            [p,rest]=strtok(pass);
            phases(nb)={p};
            while ~isempty(rest)
                nb=nb+1;
                [p,rest]=strtok(rest);
                phases(nb)={p};
            end
            % Delete '-' and '' characters
            phases(strcmp(phases(1:end),'-'))=[];
            phases(strcmp(phases(1:end),''))=[];
            % Sort phases alphabetically
            phases=sort(phases);
            % Update point count
            j1=j1+1;
            %%%%%%%%%%%%%%%%%%%%%
            %%% Fill in structure
            [tps1,tps2]=size(points); % Temporary points size
            if tps2==0 % If points structure empty
                t=1; % Marker (0=line 1=point 2=delete)
                j2=1;
                % Point number
                points(j1).pnum=['i' num2str(j1)];
                % Point assemblage (text)
                points(j1).pass=pass;
                % Point assemblage list (substructure)
                for ap=1:length(phases)
                    fieldname=['p' num2str(ap)];
                    points(j1).pal.(fieldname)=phases(ap);
                end
            else % If points structure already filled
                t=1; % Marker (0=line 1=point 2=delete)
                j2=1;
                % Point number
                points(j1).pnum=['i' num2str(j1)];
                % Point assemblage (text)
                points(j1).pass=pass;
                % Point assemblage list (substructure)
                for ap=1:length(phases)
                    fieldname=['p' num2str(ap)];
                    points(j1).pal.(fieldname)=phases(ap);
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif fline(1)=='<' % Isolated line/point text
            % Separate line number from line assemblage
            [name,isolated_pass]=strtok(fline);
            % Remove spaces at the beginning
            while strcmp(isolated_pass(1),' ')
                isolated_pass(1)=[];
            end
            % Extract phases and phases out
            nb=1;
            [isolated_pass,dash]=strtok(isolated_pass,'-');
            [p,rest]=strtok(isolated_pass);
            isolated_phases(nb)={p};
            while ~isempty(rest)
                nb=nb+1;
                [p,rest]=strtok(rest);
                isolated_phases(nb)={p};
            end
            % Delete '-' and '' characters
            isolated_phases(strcmp(isolated_phases(1:end),''))=[];
            % Sort phases alphabetically
            isolated_phases=sort(isolated_phases);
            % Marker
            t=3; % Marker (0=line 1=point 2=delete 3=isolated object)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else % Coordinates
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if t==0 % Marker for coordinates of a line
                % Extract P-T coordinates
                [P,tphase]=strtok(fline); % Separate P from T + phase out info
                [T,textphase]=strtok(tphase);  % Separate T from phase out info
                pt=[str2num(P) str2num(T)];
                % Extract phase out and modal value
                trans=strrep(textphase,'%','');
                trans=strrep(trans,'=','');
                [lphase,isotxt]=strtok(trans);
                isoval=str2num(isotxt);
                % Phase out
                lines(i1).lphase=lphase;
                % Mode value
                lines(i1).liso=isoval;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Fill in line coordinates
                lines(i1).lcrd(i2,:)=pt;
                % Test if line already present
                if i2==1 % If first coordinate (test not performed later)
                    [tls1,tls2]=size(lines); % Temporary line size
                    for check=1:(tls2-1) % For all existing lines
                        % If similar assemblage (lass), phase out (lphase) and isopleth value (liso)
                        if (strcmp(lines(i1).lass,lines(check).lass)) && (strcmp(lines(i1).lphase,lines(check).lphase)) && (lines(i1).liso==lines(check).liso)
                            % Records the number of the last similar object
                            lines(i1).sim=check;
                            break
                        else % No similar line
                            lines(i1).sim=0;
                        end
                    end
                end
                % Update coordinate increment
                i2=i2+1;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif t==1 % Marker for coordinates of a point
                % Extract P-T coordinates
                [P,tphase]=strtok(fline); % Separate P from T + phase out info
                [T,textphase]=strtok(tphase);  % Separate T from phase out info
                pt=[str2num(P) str2num(T)];
                points(j1).pcrd(j2,:)=pt;
                % Extract phases out and mode values
                [textp1, textp2]=strtok(textphase,','); % Split into the 2 phases out strings
                % Retrieve phase1 and mode value 1
                trans1=strrep(textp1,'%','');
                trans1=strrep(trans1,'=','');
                [pphase1,isotxt1]=strtok(trans1);
                piso1=str2num(isotxt1);
                points(j1).pphase1=pphase1;
                points(j1).piso1=piso1;
                % Retrieve phase2 and mode value 2
                trans2=strrep(textp2,',','');
                trans2=strrep(trans2,'=','');
                [pphase2,isotxt2]=strtok(trans2);
                piso2=str2num(isotxt2);
                points(j1).pphase2=pphase2;
                points(j1).piso2=piso2;
                % Test if point already present
                if j2==1 % If first coordinate (test not performed later)
                    [tps1,tps2]=size(points); % Temporary point size
                    for check=1:(tps2-1) % For all existing points
                        % If similar assemblage (pass), phase out1 (pphase1), phase out 2 (pphase2) and isopleths values (piso1 & piso2)
                        if (strcmp(points(j1).pass,points(check).pass)) && (strcmp(points(j1).pphase1,points(check).pphase1)) && (strcmp(points(j1).pphase2,points(check).pphase2)) && ( points(j1).piso1==points(check).piso1 ) && ( points(j1).piso2==points(check).piso2 )
                            % Records the number of the last similar object
                            points(j1).sim=check;
                            break
                        else % No similar point
                            points(j1).sim=0;
                        end
                    end
                end
                % Update coordinate increment
                j2=j2+1;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif t==3 % Marker coordinates of an isolated object
                % Update isolated object count
                s1=s1+1;
                %%%%%%%%%%%%%%%%%%%%%
                %%% Fill in structure
                [tis1,tis2]=size(isolated); % Temporary isolated size
                if tis2==0 % If isolated structure empty
                    ss2=1;
                    % Isolated object number
                    isolated(s1).pnum=['io' num2str(s1)];
                    % Isolated object assemblage (text)
                    isolated(s1).pass=isolated_pass;
                    % Isolated object assemblage list (substructure)
                    for ap=1:length(isolated_phases)
                        fieldname=['io' num2str(ap)];
                        isolated(s1).pal.(fieldname)=isolated_phases(ap);
                    end
                else % If points structure already filled
                    ss2=1;
                    % Isolated object number
                    isolated(s1).pnum=['io' num2str(s1)];
                    % Isolated object assemblage (text)
                    isolated(s1).pass=isolated_pass;
                    % Isolated object assemblage list (substructure)
                    for ap=1:length(isolated_phases)
                        fieldname=['io' num2str(ap)];
                        isolated(s1).pal.(fieldname)=isolated_phases(ap);
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Extract P-T coordinates
                [P,T]=strtok(fline); % Separate P from T
                pt=[str2num(P) str2num(T)];
                isolated(s1).pcrd(ss2,:)=pt;
                % Test if object already present
                [tis1,tis2]=size(isolated); % Temporary isolated size
                for check=1:(tis2-1) % For all existing objects
                    % If similar assemblage (pass) and PT values
                    if (strcmp(isolated(s1).pass,isolated(check).pass)) && (isolated(s1).pcrd(1,1)==isolated(check).pcrd(1,1)) && (isolated(s1).pcrd(1,2)==isolated(check).pcrd(1,2)) 
                        % Records the number of the last similar object
                        isolated(s1).sim=check;
                        break
                    else % No similar point
                        isolated(s1).sim=0;
                    end
                end
            end
        end
    end
else
    menu('No data in result file', 'Ok');
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Various tests if objects empty or similar
% If line with only one data point, duplicate coordinates
% If line without data points, ask to keep ?
deletel=[]; % Vector to delete empty lines, if wanted
[fls1,fls2]=size(lines); % Final line size
for dd=1:fls2
    [ndata,col]=size(lines(dd).lcrd);
    if ndata==1 % If only one coordinate for the line
        % Duplicate coordinates
        lines(dd).lcrd(2,:)=lines(dd).lcrd(1,:);
    elseif ndata==0 && lines(dd).keep==0 % If line is empty and question never asked (keep=0)
        % Question
        txtmenu=['Line u' num2str(dd) ' is empty, delete it ?'];
        question=menu(txtmenu, 'yes', 'no');
        if question==1 % If yes to delete line
            deletel(dd)=1;
            lines(dd).keep=0;  % Default keep
        else % If no to delete line
            delete(dd)=0;
            % Record the phase out for modal isopleths
            if ~strcmp(lines(dd).lass(1:end),' ')
                [in,out]=strtok(lines(dd).lass,'-');
                lphase=strrep(out,'- ','');
                lines(dd).lphase=lphase;
            end
            % Avoid asking again (keep=1)
            lines(dd).keep=1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%
% Test if similar line
[fls1,fls2]=size(lines); % Final line size
for ss=1:fls2
    if lines(ss).sim > 0 % If the number of a similar line is stored
        % Build text
        txt1={['Line u'  num2str(ss) ' is similar to Line u' num2str(lines(ss).sim)]};
        txt2={'What to do ?'};
        txtmenu=[txt1;txt2];
        q2=['Delete Line u' num2str(lines(ss).sim)];
        q3=['Delete Line u' num2str(ss)];
        % Menu
        question=menu(txtmenu, 'Keep both',q2,q3);
        if question==1 % If keep both chosen
            lines(ss).sim=0;  % Avoid asking again (not similar any more)
        elseif question==2 % If delete similar line
            deletel(lines(ss).sim)=1;
            lines(ss).sim=0;  % Avoid asking again (not similar any more)
        elseif question==3 % If delete current line
            deletel(ss)=1;
        end
    end
end
%%%%%%%%%%
% Delete selected lines (empty or similar)
if sum(deletel) % If lines to be deleted
    lines(deletel==1)=[];
    [fls3,fls4]=size(lines); % Final line size after delete
    for m=1:fls4 % Reassign all line numbers
        lines(m).lnum=['u' num2str(m)];
    end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatically delete empty points
deletep=[]; % Vector to delete empty points
% Look for empty points
[fps1,fps2]=size(points); % Final point size
for ff=1:fps2
    if isempty(points(ff).pcrd)
        deletep(ff)=1;
    else
        deletep(ff)=0;
    end
end
% Test if similar point
[fps1,fps2]=size(points); % Final line size
for rr=1:fps2
    if points(rr).sim > 0 % If the number of a similar point is stored
        % Build text
        txt1={['Point i'  num2str(rr) ' is similar to Point i' num2str(points(rr).sim)]};
        txt2={'What to do ?'};
        txtmenu=[txt1;txt2];
        q2=['Delete Point i' num2str(points(rr).sim)];
        q3=['Delete Point i' num2str(rr)];
        % Menu
        question=menu(txtmenu, 'Keep both',q2,q3);
        if question==1 % If keep both chosen
            points(rr).sim=0;  % Avoid asking again (not similar any more)
        elseif question==2 % If delete similar point
            deletep(points(rr).sim)=1;
            points(rr).sim=0;  % Avoid asking again (not similar any more)
        elseif question==3 % If delete current point
            deletep(rr)=1;
        end
    end
end
%%%%%%%%%%
% Delete selected points (empty or similar)
if sum(deletep)
    points(deletep==1)=[];
    [fps3,fps4]=size(points); % final point size after delete
    for l=1:fps4 % reassign all point numbers
        points(l).pnum=['i' num2str(l)];
    end
end
%%%%%%%%%%%%%%%
% Automatically delete similar isolated objects
deleteis=[]; % Vector to delete similar objects
% Look for similar objects
[fis1,fis2]=size(isolated); % Final isolated size
for ffs=1:fis2
    if isolated(ffs).sim~=0
        deleteis(ffs)=1;
    else
        deleteis(ffs)=0;
    end
end
isolated(deleteis==1)=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%