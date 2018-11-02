function  [lines,points]=cut_wizzard(lines,points)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=cut_wizzard(...)
% Automatically detect begin and end points for lines
%
% Input: - lines = struture array with calculated lines
%        - points = structure array with calculated points
%
% Output: - lines = struture array with calculated lines, updated with
%           begin and end points
%         - points = struture array with calculated points, updated with
%           begin and end points
%
% For the fields of lines and points structures, see readps
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
%
pointjoin=struct([]);
tmppoint=struct([]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create the structures with info on the line connected at a given point
for jj=1:spoints2 % For all points
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Point for modal isopleth
    if isempty (strfind(points(jj).pphase1,'(')) && isempty (strfind(points(jj).pphase2,'('))
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Create the 4 dataset for the curves joining the point in structure pointjoint
        % (lal:assemblage null:phase out liso:iso value name:point name)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Keep point name
        pointjoin(jj).name(1:4,:)=str2num(strrep(points(jj).pnum,'i',''));
        % Higher variance, phase1 out
        pointjoin(jj).lal(1,:)=points(jj).pal;
        pointjoin(jj).null(1,:)={points(jj).pphase1};
        pointjoin(jj).liso(1,:)=points(jj).piso1;
        % Higher variance, phase2 out
        pointjoin(jj).lal(2,:)=points(jj).pal;
        pointjoin(jj).null(2,:)={points(jj).pphase2};
        pointjoin(jj).liso(2,:)=points(jj).piso2;
        % Lower variance, phase1 out (assemblage without phase2 out)
        fldn=fieldnames(points(jj).pal);
        inc1=1;
        % Fill in without phase2 out
        for i=1:length(fldn)
            if ~strcmp(char(points(jj).pal.(char(fldn(i)))), points(jj).pphase2)
                fldn2=['p' num2str(inc1)];
                pointjoin(jj).lal(3).(fldn2)=points(jj).pal.(char(fldn(i)));
                inc1=inc1+1;
            end
        end
        %
        pointjoin(jj).null(3,:)={points(jj).pphase1};
        pointjoin(jj).liso(3,:)=points(jj).piso1;
        % Lower variance, phase2 out (assemblage without phase1 out)
        fldn=fieldnames(points(jj).pal);
        inc2=1;
        % Fill in without phase1 out
        for i=1:length(fldn)
            if ~strcmp(char(points(jj).pal.(char(fldn(i)))), points(jj).pphase1)
                fldn2=['p' num2str(inc2)];
                pointjoin(jj).lal(4).(fldn2)=points(jj).pal.(char(fldn(i)));
                inc2=inc2+1;
            end
        end
        % Loop to delete empty phase field
        nph=fieldnames(pointjoin(jj).lal(4));
        for clean=1:length(nph)
            if isempty(pointjoin(jj).lal(4).(char(nph(clean)))) % If empty field
                rmfield(pointjoin(jj).lal(4), char(nph(clean)));
            end
        end
        pointjoin(jj).null(4,:)={points(jj).pphase2};
        pointjoin(jj).liso(4,:)=points(jj).piso2;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Point for compositional isopleth
    if ~isempty (strfind(points(jj).pphase1,'(')) | ~isempty (strfind(points(jj).pphase2,'('))
        % Keep point name
        pointjoin(jj).name(1:2,:)=str2num(strrep(points(jj).pnum,'i',''));
        % Detect phase out, name and value of compositional isopleth
        if isempty (strfind(points(jj).pphase1,'('))
            nullphase=points(jj).pphase1;
            isoname=points(jj).pphase2;
            isovalue=points(jj).piso2;
        else
            nullphase=points(jj).pphase2;
            isoname=points(jj).pphase1;
            isovalue=points(jj).piso1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Create the 2 dataset for the curves joining the point in structure pointjointi
        % (lal : assemblage null: phase out liso: iso value)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Higher variance
        pointjoin(jj).lal(1,:)=points(jj).pal;
        pointjoin(jj).null(1,:)={isoname};
        pointjoin(jj).liso(1,:)=isovalue;
        % Lower variance, phase out
        fldn=fieldnames(points(jj).pal);
        inci=1;
        % Fill in without phase out
        for i=1:length(fldn)
            if ~strcmp(char(points(jj).pal.(char(fldn(i)))), nullphase)
                fldn2=['p' num2str(inci)];
                pointjoin(jj).lal(2).(fldn2)=points(jj).pal.(char(fldn(i)));
                inci=inci+1;
            end
        end
        pointjoin(jj).null(2,:)={isoname};
        pointjoin(jj).liso(2,:)=isovalue;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Detect begin and end
% Size of join structures
[sj1,sj2]=size(pointjoin);
for ll=1:slines2 % For all lines
    if isempty(lines(ll).linef) % If lines never cut before
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% CASE Modal isopleth
        if isempty (strfind(lines(ll).lphase,'(')) && ~isempty(lines(ll).lcrd) % If no '(' sign found, modal isopleth line (in non-empty line)
            m=1; % Marker for number of points found (0, 1 or 2)
            nbp=fieldnames(lines(ll).lal);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for tt=1:sj2 % For all junctions (i.e. points)
                [st1,st2]=size(pointjoin(tt).name);
                if st1==4 % Pointjoin for modal isopleth
                    for solution=1:4
                        npc=fieldnames(pointjoin(tt).lal(solution));
                        % Count the number of non empty fields
                        nf=0;
                        for epur=1:length(npc)
                            if ~isempty(pointjoin(tt).lal(solution).(char(npc(epur))))
                                nf=nf+1;
                            end
                        end
                        if length(nbp)==nf % If same number of phases
                            count=[];
                            for z=1:nf % For each phase
                                % If phase from assemblage, phase out and isopleth
                                % similar
                                if ( strcmp( lines(ll).lal.(char(nbp(z))), pointjoin(tt).lal(solution).(char(npc(z))) ) ) && ( strcmp( lines(ll).lphase,char(pointjoin(tt).null(solution)) ) ) && ( (lines(ll).liso)==(pointjoin(tt).liso(solution)) )
                                    count = [count 0]; % Similar
                                else
                                    count = [count 1]; % Different
                                end
                            end
                            if sum(count)==0 % Similar
                                if m==1
                                    % Temporary store point 1
                                    tmppoint=points(pointjoin(tt).name(solution));
                                    m=m+1;
                                elseif m==2
                                    % Temporary store point 1
                                    tmppoint(m)=points(pointjoin(tt).name(solution));
                                end
                            end
                        end
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % All points have been tested, now automatically recognize begin and
            % end, according to increasing temperature only
            if ~isempty (tmppoint)
                [tmp1,tmp2]=size(tmppoint);
                if tmp2==2 % If begin and end found
                    if tmppoint(1).pcrd(1,2)<tmppoint(2).pcrd(1,2) % if T1 < T2
                        lines(ll).ltbegin=tmppoint(1).pnum;
                        lines(ll).lbegin=tmppoint(1).pcrd;
                        lines(ll).ltend=tmppoint(2).pnum;
                        lines(ll).lend=tmppoint(2).pcrd;
                    else  % if T1 > T2
                        lines(ll).ltbegin=tmppoint(2).pnum;
                        lines(ll).lbegin=tmppoint(2).pcrd;
                        lines(ll).ltend=tmppoint(1).pnum;
                        lines(ll).lend=tmppoint(1).pcrd;
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% CASE compositional isopleth
        elseif ~isempty(lines(ll).lcrd)
            n=1; % Marker for number of points found (0, 1 or 2)
            nbp=fieldnames(lines(ll).lal);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for xx=1:sj2 % For all junctions (i.e. points)
                [st1,st2]=size(pointjoin(xx).name);
                if st1==2 % Pointjoin for compositional isopleth
                    for solution=1:2
                        npc=fieldnames(pointjoin(xx).lal(solution));
                        % Count the number of non empty fields
                        ng=0;
                        for epur=1:length(npc)
                            if ~isempty(pointjoin(xx).lal(solution).(char(npc(epur))))
                                ng=ng+1;
                            end
                        end
                        if length(nbp)==ng % If same number of phases
                            count=[];
                            for z=1:length(nbp) % For each phase
                                % If phase from assemblage, phase out and isopleth similar
                                if ( strcmp(lines(ll).lal.(char(nbp(z))), pointjoin(xx).lal(solution).(char(npc(z)))) ) && ( strcmp(lines(ll).lphase, char(pointjoin(xx).null(solution)) ) ) && ( (lines(ll).liso)==(pointjoin(xx).liso(solution)) )
                                    count = [count 0]; % Similar
                                else
                                    count = [count 1]; % Different
                                end
                            end
                            if sum(count)==0 % Similar
                                if n==1
                                    % Temporary store point 1
                                    tmppoint=points(pointjoin(xx).name(solution));
                                    n=n+1;
                                elseif n==2
                                    % Temporary store point 1
                                    tmppoint(n)=points(pointjoin(xx).name(solution));
                                end
                            end
                        end
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % All points have been tested, now automatically recognize begin and
            % end, according to increasing temperature only
            if ~isempty (tmppoint)
                [tmp1,tmp2]=size(tmppoint);
                if tmp2==2 % If begin and end found
                    if tmppoint(1).pcrd(1,2)<tmppoint(2).pcrd(1,2) % if T1 < T2
                        lines(ll).ltbegin=tmppoint(1).pnum;
                        lines(ll).lbegin=tmppoint(1).pcrd;
                        lines(ll).ltend=tmppoint(2).pnum;
                        lines(ll).lend=tmppoint(2).pcrd;
                    else  % if T1 > T2
                        lines(ll).ltbegin=tmppoint(2).pnum;
                        lines(ll).lbegin=tmppoint(2).pcrd;
                        lines(ll).ltend=tmppoint(1).pnum;
                        lines(ll).lend=tmppoint(1).pcrd;
                    end
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%