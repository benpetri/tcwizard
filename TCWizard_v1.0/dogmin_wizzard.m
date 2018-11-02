function data=dogmin_wizzard(param,phaselist,data,button)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=dogmin_wizzard(...)
% Run Thermocalc with Gibbs energy minimization mode
%
% Input: - param = structure with initial parameters (see paramin)
%        - phaselist = cell array of available phases (without excess
%           phases)
%        - data = structure with dogmin data
%               * P = P coordinate of the point
%               * T = T coordinates of the point
%               * ass = point assemblage
%               * color = color code of the assemblage (generated in
%                         dogmin_plot)
%        - button = handles to the Show/Hide results button
%
% Output: - data = structure with dogmin data, updated
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

%%% Dogmin initial parameters
if isempty(phaselist) % if no project file
    menu('Choose a project file','Ok');
else
    %%% Question Phase list
    % Build available phase list
    defpl=[];
    for d1=1:length(phaselist)
        defpl=[defpl ' ' char(phaselist(d1))];
    end
    ask(1)={'List of selected phases (separated by space)'};
    ask(2)={['Available: ' defpl]};
    phase_ask=char(ask);
    quest=inputdlg({phase_ask,'Pmin Pmax Pstep (separated by space)','Tmin Tmax Tstep (separated by space)'},'Dogmin parameters');
    pl=quest(1);
    %%% Question P range and step
    P=char(quest(2));
    [Pmin,rest]=strtok(P);
    [Pmax,Pstep]=strtok(rest);
    %%% Question T range and step
    T=char(quest(3));
    [Tmin,rest]=strtok(T);
    [Tmax,Tstep]=strtok(rest);
    %%%
    phases={};
    % Test if all initial parameters were entered
    if isempty(P) | isempty(T) | isempty(pl)
        menu('Missing initial parameters','Ok');
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Modify project file
        nwproj=param.protext;
        % Turn on dogmin, off isopleths
        nwproj=strrep(nwproj,'setiso yes','setiso no');
        nwproj=strrep(nwproj,'dogmin no','dogmin yes');
        % Set up P-T range and step
        txtrep1=['setdefTwindow yes ' Tmin ' ' Tmax ' %'];
        nwproj=strrep(nwproj,'setdefTwindow yes',txtrep1);
        txtrep2=['setdefPwindow yes ' Pmin ' ' Pmax ' %'];
        nwproj=strrep(nwproj,'setdefPwindow yes',txtrep2);
        % Split text
        nwproj=strrep(nwproj,'project no','$project no');
        [nwproj1,nwproj2]=strtok(nwproj,'$');
        nwproj2=strrep(nwproj2,'$','');
        %%% Open and write
        fid1 = fopen([param.pathin param.project],'w+');
        % Beginning of file
        fprintf(fid1,'%c',nwproj1);
        % Inserted new text
        fprintf(fid1,'\r\n\r\nsetTinterval yes %s \r\n', Tstep);
        % Beginning of file
        fprintf(fid1,'%c',nwproj2);
        fclose(fid1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Parameters for waitbar
        if str2num(Pmax)==str2num(Pmin) % If unique row
            iterations=0;
        else
            iterations=(str2num(Pmax)-str2num(Pmin))/str2num(Pstep);
            iterations=round(iterations);
        end
        [s1,s2]=size(data);
        fill=s2+1;
        h=waitbar(0,'Please wait...');
        %%%%% Begin main loop
        for i=0:iterations
            % Update waitbar text
            txtwait=['Calculating row ' num2str(i+1) ' / ' num2str(iterations+1)];
            set(get(findobj(h,'type','axes'),'title'), 'string', txtwait)
            %%% Build the temp text file for tc
            % Open, create and write in the temp file
            filetc=[param(1).pathin 'dgtemp.txt'];
            fid2 = fopen(filetc,'w+');
            fprintf(fid2,'%s\r\n',char (pl)); % phase list
            fprintf(fid2,'6\r\n'); % max variance question = 6
            Pwrite=str2num(Pmin)+i*str2num(Pstep);
            fprintf(fid2,'%2.2f %2.2f\r\n',Pwrite, Pwrite); % P low, high (same)
            fprintf(fid2,'%s %s\r\nn',Tmin, Tmax); % T low, high
            fclose(fid2);
            %%% Run thermocalc
            cd(param.pathin);
            [a,b]=dos('tc333.exe < dgtemp.txt');
            cd(param.matpath);
            %%% Extract data text from tc-log (problems in b output sometimes)
            % Open and read log file
            fidlog=fopen ([param.pathin 'tc-log.txt'],'r');
            all=fscanf(fidlog, '%c');
            fclose(fidlog);
            % Isolate data
            dgtxt=strrep(all,'Gibbs energy minimisation info','$');
            dgtxt=strrep(dgtxt,'n            G        del','$');
            dgtxt=strrep(dgtxt,'(Use these results at your own risk!)','$');
            % li = phase list, da = data
            [before,lidaafter]=strtok(dgtxt,'$');
            [li,daafter]=strtok(lidaafter,'$');
            [da,after]=strtok(daafter,'$');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Save dogmin data
            %%%%%%%%%%%%%%%%%%%%
            % Save phases
            if isempty(phases) % If no record
                nb=1;
                % Extract phases
                li=strrep(li,'P(kbar)   T(¡C)','');
                [t1,t2]=strtok(li);
                phases(nb)={t1};
                while ~isempty(t2)
                    nb=nb+1;
                    [t1,t2]=strtok(t2);
                    phases(nb)={t1};
                end
                % Delete last empty
                phases(end)=[];
            end
            %%%%%%%%%%%%%%%%%%%%
            % Write data in file
            fid3 = fopen([param.pathin 'dgdata.txt'],'w+');
            fprintf(fid3,'%s',da);
            fclose(fid3);
            % Open file for reading and saving
            fid3 = fopen([param.pathin 'dgdata.txt']);
            while ~feof(fid3)
                % Read line
                fline=fgetl(fid3);
                if ~isempty(fline)
                    % Extract P and T
                    [P,rest]=strtok(fline);
                    [T,rest]=strtok(rest);
                    for ss=1:length(phases)
                        [p1,rest]=strtok(rest);
                        arr(ss)={p1};
                    end
                    %%% Test if P written (non decimal)
                    if strcmp(P,'-') | strcmp(P,'+') % P not written in log file, use Pwrite
                        P=Pwrite;
                    else % P written in log file
                        P=str2num(P);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Test if point already present
                    [st1,st2]=size(data);
                    mk=[];
                    for mm=1:st2
                        if (P==data(mm).P) && (str2num(T)==data(mm).T) % If similar coordinates
                            % Do not record point, marker 1
                            mk=[mk 1];
                        else
                            % Record point, marker 0
                            mk=[mk 0];
                        end
                    end
                    %%%%%%%%%%%%%
                    if sum(mk)==0 % If point can be recorded
                        % If ¥ symbols present (sometimes not displayed ??)
                        if ~isempty (char(arr))                         
                            % Fill in data structure
                            data(fill).P=P;
                            data(fill).T=str2num(T);
                            assemblage=phases(strcmp(arr,'¥'));
                            ass=[];
                            for d1=1:length(assemblage)
                                ass=[ass ' ' char(assemblage(d1))];
                            end
                            % Delete first space
                            ass(1)='';
                            data(fill).ass=ass;
                            %
                            fill=fill+1;
                        end
                    end
                end
            end
            % Update waitbar fill
            waitbar((i+1)/(iterations+1));
        end %% End main loop
        % Close waitbar
        close(h);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% PLOT dogmin data
        hold on
        dogmin_plot(data,button);
        hold off
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Reset project file to original
        fid1 = fopen([param.pathin param.project],'w+');
        fprintf(fid1,'%c',param.protext);
        fclose(fid1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%