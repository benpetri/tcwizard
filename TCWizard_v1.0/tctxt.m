function tctxt(param,phaselist,ch_ass,ch_mode,ed_mode,st,tatp,Tmin,Tmax,Pmin,Pmax,isn,isv,sab)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% tctxt(...)
% Create the temporary text file to run Thermocalc
%
% Input: - param = structure of initial parameters (see paramin)
%        - phaselist = cell array of available phases (without excess
%          phases)
%        - ch_ass = vector of handles for checkboxes with the assemblage
%        - ch_mode = vector of handles for checkboxes with the mode
%        - ed_mode = vector of handles for edit text with mode values
%        - st = handles to the radiobutton for calculation mode
%        - tatp = handles to the radiobutton for calculating T at P or not
%        - Tmin, Tmax = handles to the edit text boxes for the T° range
%        - Pmin, Pmax = handles to the edit text boxes for the P° range
%        - isn = handles to the edit text box with the name of the
%          calculated isopleth (if compositional isopleths mode)
%        - isv = handles to the edit text box with the value of the
%          calculated isopleth (if compositional isopleths mode)
%        - sab = handles to the pushbutton "GO" (display hourglass)
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

% Get parameters from the interface
state=get(st,'Value'); % Get Mode/Isopleth radiobutton (0=Mode 1=Isopleths)
ass_list=cell2mat (get(ch_ass,'Value') ); % Get vector for the assemblage
out_list=cell2mat (get(ch_mode,'Value') ); % Get vector for the phase(s) out
modeval=str2num( char(get(ed_mode,'String')) ); % Get vector for the mode values
isoname=get(isn,'String'); % Get isopleth name
isovalue=get(isv,'String'); % Get isopleth value
tpquestion=get(tatp,'Value'); % Get T at P radiobutton (1=T at P(default) 0=P at T)
% Get P-T range if changed in edit text boxes
Tmin_change=str2num(get(Tmin,'String'));
Tmax_change=str2num(get(Tmax,'String'));
Pmin_change=str2num(get(Pmin,'String'));
Pmax_change=str2num(get(Pmax,'String'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Markers for point/line calculation (0=line 1=point) and if assemblage and
% phase out not selected (0=calculation allowed 1= no calculation)
point_ok=0;
no_ass=0;
no_out=0;
no_iso=0;
no_val=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test if Name and Value for isopleths are typed
if state==1 % If compositional isopleth calculation
    if strcmp(isoname,'Name') % If no isopleth name typed
        menu('No isopleth name','Ok');
        no_iso=1; % Marker to avoid calculation
    end
    if strcmp(isovalue,'Value') % If no isopleth value typed
        menu('No isopleth value','Ok');
        no_val=1; % Marker to avoid calculation
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modal isopleth calculation
if state==0
    % Process assemblage
    if sum(ass_list)>0 % If assemblage selected
        assemblage=(phaselist(ass_list==1));
        ass_txt=[];
        for na=1:length(assemblage)
            % Build assemblage line
            ass_txt=[ass_txt ' ' char(assemblage(na))];
        end
    else % If no starting assemblage selected
        menu('No starting assemblage','Ok');
        no_ass=1; % Marker
    end
    % Process modal isopleths
    phout=(phaselist(out_list==1));
    if ~isempty(phout) % If phase(s) out selected
        phase_out(1)=phout(1); % If line calculation
        if length(phout)>1 % If point calculation
            phase_out(2)=phout(2);
            % Update marker to point calculation
            point_ok=1;
        end
    else % If no phase(s) out selected
        if sum(ass_list)>0 % If assemblage selected
            % If no phase(s) out selected
            menu('No phase out selected','Ok');
            no_out=1; % Marker
        end
    end
    % Process Mode values
    if sum(modeval)==0 % If mode values are all zero
        mode(1)=0; % If line calculation
        if point_ok==1
            mode(2)=0; % If point calculation
        end
    else % If 1 or 2 mode values are not zero
        modes=modeval(out_list==1);
        mode(1)=modes(1); % If line calculation
        if length(modes)>1 % If point calculation
            mode(2)=modes(2);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Open, create and write in the temp file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (no_ass~=1) % If assemblage selected
        %%%%%%%%%%%%%%%%%%
        if (no_out==1) % If calculation of "isolated point/line" (i.e. no phase out), modify project file
            nwproj=param.protext;
            % Turn off isopleths
            nwproj=strrep(nwproj,'setiso yes','setiso no');
            %%% Open and write
            fidN = fopen([param.pathin param.project],'w+');
            fprintf(fidN,'%c',nwproj);
            fclose(fidN);
            phase_out(1)={''};
        end
        % Temporary file used by Thermocalc is tctemp.txt and created in the project folder
        filetc=[param(1).pathin 'tctemp.txt'];
        fid = fopen(filetc,'w+');
        % Assemblage question
        fprintf(fid,'%s\r\n',ass_txt);
        % Variance question (not answering)
        fprintf(fid,'\r\n');
        % Phase(s) out question(s)
        if point_ok==0 % If line calculation
            fprintf(fid,'%s\r\n',char(phase_out(1))); % If one phase out, line
        else % If point calculation
            fprintf(fid,'%s\r\n',[char(phase_out(1)) ' ' char(phase_out(2))]); % If two phases out, point
        end
        % Modal isopleth value question(s)
        if (no_out~=1)
            if point_ok==0 % If line calculation
                fprintf(fid,'%d\r\n',mode(1)); % Mode value
            else % If point calculation
                fprintf(fid,'%d\r\n',mode(1)); % Mode value for the first phase
                fprintf(fid,'%d\r\n',mode(2)); % Mode value for the second phase
            end
            % Isopleth calculation question
            if point_ok==0 % If line calculation (question is not asked if point calculation)
                fprintf(fid,'\r\n'); % Not answering
            end
        end
        % P-T range questions
        if point_ok==1 % If point calculation
            if (param.PTrange(2,:)==[Pmin_change Pmax_change]) % If similar P range
                if (param.PTrange(1,:)==[Tmin_change Tmax_change]) % If similar T range
                    % fprintf(fid,'\r\n'); % default PT range
                else % If new T range
                    fprintf(fid,'%.1f %.1f %.1f %.1f\r\n',Tmin_change, Tmax_change, Pmin_change, Pmax_change); % New P-T range
                end
            else % If new P range
                fprintf(fid,'%.1f %.1f %.1f %.1f\r\n',Tmin_change, Tmax_change, Pmin_change, Pmax_change); % New P-T range
            end
        else % If line calculation
            % T at P question and P-T range
            if tpquestion==1 % Calculate T at P(default)
                if (no_out~=1)
                    fprintf(fid,'\r\n'); % T at P (not answering, default)
                    isolated_calc=0; % Marker
                else
                    isolated_calc=1; % Marker
                end
                % P range
                if param.PTrange(2,:)==[Pmin_change Pmax_change] % If default P range
                    fprintf(fid,'\r\n'); % Default P range
                else % If new P range
                    fprintf(fid,'%.1f %.1f\r\n',Pmin_change, Pmax_change); % New P range
                end
                % T range
                if param.PTrange(1,:)==[Tmin_change Tmax_change] % If default T range
                    fprintf(fid,'\r\n'); % Default T range
                else % If new T range
                    fprintf(fid,'%.1f %.1f\r\n',Tmin_change, Tmax_change); % New T range
                end
                % P step (automatically calculated)
                Pstep=(Pmax_change-Pmin_change)/100;
                Tstep=(Tmax_change-Tmin_change)/100;
                if (isolated_calc==0)
                    fprintf(fid,'%.2f',Pstep); % P step
                elseif (isolated_calc==1) && (Pmin_change==Pmax_change)                    
                    fprintf(fid,'%.2f',Tstep); % exceptional T step
                elseif (isolated_calc==1) && (Tmin_change==Tmax_change)
                    fprintf(fid,'%.2f',Pstep); % P step
                else
                    Pstep=(Pmax_change-Pmin_change)/10;
                    Tstep=(Tmax_change-Tmin_change)/10;
                    fprintf(fid,'%.2f\r\n',Tstep); % exceptional T step
                    fprintf(fid,'%.2f',Pstep); % P step
                end
            else % Calculate P at T
                % T at P question, put 'n'
                fprintf(fid,'n\r\n');
                % T range
                if param.PTrange(1,:)==[Tmin_change Tmax_change] % If default T range
                    fprintf(fid,'\r\n'); % Default T range
                else % If new T range
                    fprintf(fid,'%.1f %.1f\r\n',Tmin_change, Tmax_change); % New T range
                end
                % P range
                if param.PTrange(2,:)==[Pmin_change Pmax_change] % If default P range
                    fprintf(fid,'\r\n'); % Default P range
                else % If new P range
                    fprintf(fid,'%.1f %.1f\r\n',Pmin_change, Pmax_change); % New P range
                end
                % T step (automatically calculated)
                Tstep=(Tmax_change-Tmin_change)/100;
                fprintf(fid,'%.2f',Tstep); % T step
            end
        end
        % Close temporary file
        fclose(fid);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compositional isopleth calculation
elseif state==1
    % Process assemblage
    if sum(ass_list)>0 % If assemblage selected
        assemblage=(phaselist(ass_list==1));
        ass_txt=[];
        for na=1:length(assemblage)
            % Build assemblage line
            ass_txt=[ass_txt ' ' char(assemblage(na))];
        end
    else % If no starting assemblage selected
        menu('No starting assemblage','Ok');
        no_ass=1; % Marker
    end
    % Process modal isopleths
    phout=(phaselist(out_list==1));
    if ~isempty(phout)
        if length(phout)==1 % If phase out selected
            phase_out(1)=phout(1); % Only 1 phase out, isopleth choosed later
            % Update marker to point calculation
            point_ok=1;
        else % If too many phases out selected
            if sum(ass_list)>0 % If assemblage selected
                menu('Too many phases out selected','Ok');
                no_out=1; % Marker
            end
        end
    end
    % Process Mode values
    if sum(modeval)==0 % If zero modal value
        mode(1)=0;
    else % If non zero modal value
        modes=modeval(out_list==1);
        mode(1)=modes(1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Open, create and write in the temp file
    if (no_ass~=1) && (no_out~=1) && (no_iso~=1) && (no_val~=1) % If assemblage, phase out, isopleth name and value selected
        % Temporary file used by Thermocalc is tctemp.txt and created in the project folder
        filetc=[param(1).pathin 'tctemp.txt'];
        fid = fopen(filetc,'w+');
        % Assemblage question
        fprintf(fid,'%s\r\n',ass_txt);
        % Variance question (not answering)
        fprintf(fid,'\r\n');
        % Phase(s) out question(s)
        if ~isempty(phout) % If point calculation
            fprintf(fid,'%s\r\n',char(phase_out(1))); % One phase out
        else % If line calculation (no phase out)
            fprintf(fid,'\r\n');
        end
        % Modal isopleth value question(s)
        if point_ok==1 % If point calculation
            if mode(1)==0 % If zero modal value
                fprintf(fid,'0\r\n');
            else % If non zero modal value
                fprintf(fid,'%d\r\n',mode(1));
            end
        end
        % Isopleth name question
        fprintf(fid,'%s\r\n',isoname); % Isopleth name
        % Isopleth value question
        fprintf(fid,'%s\r\n',isovalue); % Isopleth value
        % P-T range question
        if point_ok==1 % If point calculation
            if (param.PTrange(2,:)==[Pmin_change Pmax_change]) % If similar P range
                if (param.PTrange(1,:)==[Tmin_change Tmax_change]) % If similar T range
                    % fprintf(fid,'\r\n'); % default PT range
                else % If new T range
                    fprintf(fid,'%.1f %.1f %.1f %.1f\r\n',Tmin_change, Tmax_change, Pmin_change, Pmax_change); % New P-T range
                end
            else % If new P range
                fprintf(fid,'%.1f %.1f %.1f %.1f\r\n',Tmin_change, Tmax_change, Pmin_change, Pmax_change); % New P-T range
            end
        else % If line calculation
            % T at P question and P-T range
            if tpquestion==1 % Calculate T at P(default)
                fprintf(fid,'\r\n'); % T at P (not answering, default)
                % P range
                if param.PTrange(2,:)==[Pmin_change Pmax_change] % If default P range
                    fprintf(fid,'\r\n'); % Default P range
                else % If new P range
                    fprintf(fid,'%.1f %.1f\r\n',Pmin_change, Pmax_change); % New P range
                end
                % T range
                if param.PTrange(1,:)==[Tmin_change Tmax_change] % If default T range
                    fprintf(fid,'\r\n'); % Default T range
                else % If new T range
                    fprintf(fid,'%.1f %.1f\r\n',Tmin_change, Tmax_change); % New T range
                end
                % P step (automatically calculated)
                Pstep=(Pmax_change-Pmin_change)/100;
                fprintf(fid,'%.2f',Pstep); % P step
            else % Calculate P at T
                % T at P question, put 'n'
                fprintf(fid,'n\r\n');
                % T range
                if param.PTrange(1,:)==[Tmin_change Tmax_change] % If default T range
                    fprintf(fid,'\r\n'); % Default T range
                else % If new T range
                    fprintf(fid,'%.1f %.1f\r\n',Tmin_change, Tmax_change);  % New T range
                end
                % P range
                if param.PTrange(2,:)==[Pmin_change Pmax_change] % If default P range
                    fprintf(fid,'\r\n'); % Default P range
                else % If new P range
                    fprintf(fid,'%.1f %.1f\r\n',Pmin_change, Pmax_change); % New P range
                end
                % T step (automatically calculated)
                Tstep=(Tmax_change-Tmin_change)/100;
                fprintf(fid,'%.2f',Tstep); % T step
            end
        end
        % Close temporary file
        fclose(fid);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display hourglass on "GO" button
im=imread('button_sablier.png');
set(sab,'String','');
set(sab,'cdata',im);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Start error timer
T=timer('TimerFcn','cd(param.matpath);tckiller(param)','StartDelay',15);
start(T);
%%% Execute tc333.exe
cd(param.pathin);
[a,b]=dos('tc333.exe < tctemp.txt');
cd(param.matpath);
% Stop and delete existing timers (tctxt and tckiller)
stop(T);
delete(timerfind);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove hourglass from "GO" button (calculation successfully done)
set(sab,'String','GO');
set(sab,'cdata',[]);
%%%%%%%%%
% Reset project file to original
fidN = fopen([param.pathin param.project],'w+');
fprintf(fidN,'%c',param.protext);
fclose(fidN);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%