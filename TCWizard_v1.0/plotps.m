function plotps(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% plotps(...)
% Plot Thermocalc results
%
% Input: - lines = struture array with calculated lines
%        - points = structure array with calculated points
%        - axes = handles to the figure axes
%        - Tmin, Tmax = handles to the edit text boxes for the T° range
%        - Pmin, Pmax = handles to the edit text boxes for the P° range
%        - popup = handles to the popupmenu with list of isopleths for detection
%        - use = handles to the use point button in the information panel
%        - cb = double number, state of background image (0=not displayed 1=displayed)
%        - iminfo = structure with information on the background image (see bcgim_in)
%        - bcgim = handles to the Show/Hide background image button
%        - al = handles to the Show/Hide Al2SiO5 button
%        - dog = handles to the Show/Hide dogmin results button
%        - data = structure with dogmin results
%        - param = structure with intitial parameters
%        - isolated = structure array with isolated objects
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

% Clear current axis
cla
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Display background image if selected
if cb==1 % If show selected
    % Import image
    im = imread(iminfo(1).path);
    % Flip
    im=flipdim(im,1);
    % Plot image
    ddd=image([iminfo(1).T(1) iminfo(1).T(2)],[iminfo(1).P(1) iminfo(1).P(2)],im);
    hold on
    set(ddd,'HitTest','off');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Definition of variables
% Sizes of structures
[spoints1,spoints2]=size(points);
[slines1,slines2]=size(lines);
if slines2~=0
    % Structure for line colors
    list = struct ('phase', {}, 'color', {});
    color=[];
    % List of all phases out infos to build the color table
    export=struct2cell(lines);
    ind=1;
    for h=1:slines2
        ppp=cell2mat(export(5,:,h));
        if ~isempty(ppp)
            phout(ind)={ppp};
            ind=ind+1;
        end
    end
    list_phout=unique(phout);
    for i=1:length(list_phout)
        list(i).phase=list_phout(i);
    end
    % Colormap table
    [slist1,slist2]=size(list);
    cl=colormap(hsv(slist2));
    for clb=1:slist2
        list(clb).color(1,:)=cl(clb,:);
    end
    % Phase list for the legend
    legcell=struct2cell(list);
    pleg=legcell(1:2:numel(legcell));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot lines
for p1=1:slines2 % For all lines
    [slc1,slc2]=size(lines(p1).lcrd);
    if ~isempty(lines(p1).lcrd)
        if isempty(lines(p1).linef) % If cut, plot final coordinates
            % Look for the color coding
            for phseek=1:slist2
                if strcmp(lines(p1).lphase(1,:), list(phseek).phase(1,:))
                    color=list(phseek).color;
                    % Brighten background color (for background color)
                    %bcgcol=rgb2hsv(list(phseek).color);
                    %bcgcol(2)=0.2;
                    %bcgcol=hsv2rgb(bcgcol);                    
                end
            end
            if ~isempty(color) % If color coding
                % Line, text with name of line and Tag for datacursormode
                plot(lines(p1).lcrd(:,2),lines(p1).lcrd(:,1), 'Color', color,'Tag', num2str(p1));
                test=text(lines(p1).lcrd(round(slc1/2),2),lines(p1).lcrd(round(slc1/2),1), lines(p1).lnum, 'Color', color,'FontWeight','bold');
                hold on
            else  % If no color coding
                % Line, text with name of line and Tag for datacursormode
                plot(lines(p1).lcrd(:,2),lines(p1).lcrd(:,1),'Tag', num2str(p1));
                text(lines(p1).lcrd(round(slc1/2),2),lines(p1).lcrd(round(slc1/2),1), lines(p1).lnum, 'FontWeight','bold');
                hold on
            end
        else % If not cut, plot initial coordinates
            % Look for the color coding
            for phseek=1:slist2
                if strcmp(lines(p1).lphase(1,:), list(phseek).phase(1,:))
                    color=list(phseek).color;
                    % Brighten background color (for background color)
                    %bcgcol=rgb2hsv(list(phseek).color);
                    %bcgcol(2)=0.2;
                    %bcgcol=hsv2rgb(bcgcol);  
                end
            end
            [slcf1,slcf2]=size(lines(p1).linef);
            if ~isempty (color) % If color coding
                % Line, text with name of line and Tag for datacursormode
                plot(lines(p1).linef(:,2),lines(p1).linef(:,1),'Color', color,'Tag', num2str(p1));
                text(lines(p1).linef(round(slcf1/2),2),lines(p1).linef(round(slcf1/2),1), lines(p1).lnum, 'Color', color,'FontWeight','bold');
                hold on
            else % If no color coding
                % Line, text with name of line and Tag for datacursormode
                plot(lines(p1).linef(:,2),lines(p1).linef(:,1),'Tag', num2str(p1));
                text(lines(p1).linef(round(slcf1/2),2),lines(p1).linef(round(slcf1/2),1), lines(p1).lnum, 'FontWeight','bold');
                hold on
            end
        end
    else
        continue
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot points
for p2=1:spoints2 % For all points
    if ~isempty(points(p2).pcrd)
        [spc1,spc2]=size(points(p2).pcrd);
        % Point, text with name of point and Tag for datacursormode (>1000)
        plot(points(p2).pcrd(1,2),points(p2).pcrd(1,1),'k+','Tag', num2str(p2+1000));
        text(points(p2).pcrd(1,2),points(p2).pcrd(1,1), points(p2).pnum,'Color','k','FontWeight','bold','VerticalAlignment','top');
        hold on
    else
        continue
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate the popupmenu with list of isopleths for detection
% Import phase list and excess phases
phaselist=evalin('base','phaselist'); % Import phaselist from the main workspace
excess=evalin('base','excess'); % Import phaselist from the main workspace
if ~isempty (lines)
    isolist=fieldnames(lines);
    isolist(1:13)=[]; % Delete the first 13 lines (do not contain isopleth info)
    % Modify field names with parentheses
    for j=1:length(isolist)
        for k=1:length(phaselist)
            if strfind ( char(isolist(j)),char(phaselist(k)) ) % If phase present
                % Add parentheses ( ex: xst -> x(st) )
                rep=['(' char(phaselist(k)) ')'];
                isolist(j)={strrep(char(isolist(j)),char(phaselist(k)),rep)};
            end
        end
        for k2=1:length(excess)
            if strfind ( char(isolist(j)),char(excess(k2)) ) % If phase present as excess
                % Add parentheses ( ex: xst -> x(st) )
                rep=['(' char(excess(k2)) ')'];
                isolist(j)={strrep(char(isolist(j)),char(excess(k2)),rep)};
            end
        end
        isolist(j)={strrep(char(isolist(j)),'_','')};
        %%%%
        % Correct liquid isopleths ( ex: anL -> an(L) )
        if ~isempty(strfind(char(isolist(j)),'L'))
            isolist(j)={strrep(char(isolist(j)),'L','(L)')};
        end
        % Correct li(q), (q)(L)...
        if ~isempty(strfind(char(isolist(j)),'li(q)'))
            isolist(j)={strrep(char(isolist(j)),'li(q)','liq')};
        elseif ~isempty(strfind(char(isolist(j)),'(q)(L)')) % Correct q(L)
            isolist(j)={strrep(char(isolist(j)),'(q)(L)','q(L)')};
        end
    end
    % Update popup menu
    set(popup,'String',isolist);
    set(use,'Enable','on');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% DISPLAY EXISTING DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Display Al2SiO5 diagram if selected
st_al=get(al,'Tag');
if strcmp(st_al,'Show')
   set(al,'Tag','Hide');
   al2sio5(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Display dogmin data if present
st_dog=get(dog,'Tag');
if strcmp(st_dog,'Show')
    set(dog,'Tag','Hide');
    dogmin_disp(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% If isolated objects
[si1,si2]=size(isolated);
if si2>0
    for iss=1:si2
        plot(isolated(iss).pcrd(:,2),isolated(iss).pcrd(:,1),'.','Color', [0.75 0.75 0.75],'Tag', ['isolated' num2str(iss)]);
        hold on
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set axes limits according to Tmin, Tmax and Pmin, Pmax in the figure
if spoints2>0 | slines2>0 | si2>0
    set (axes,'Xlim', [str2num(get(Tmin,'String')) str2num(get(Tmax,'String'))]);
    set (axes,'Ylim', [str2num(get(Pmin,'String')) str2num(get(Pmax,'String'))]);
    set (axes,'Ydir', 'normal');
    xlabel('T(°C)');
    ylabel('P(kbar)');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%