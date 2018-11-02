function lt=al2sio5(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% al2sio5(...)
% Show/Hide Al2SiO5 orientation diagram
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

%%% Import icons
but_alsion = evalin('base','but_alsion');
but_alsioff = evalin('base','but_alsioff');
%%%
if ~isempty(param) % If project selected
    % Get current display status
    state=get(al,'Tag');
    if strcmp(state,'Show') % Diagram displayed -> Hide diagram
        % If diagram now hidden, put Show button
        set(al,'cdata', but_alsion,'Tag','Hide','TooltipString','Show and-ky-sill');
        %%% Plot only previous results (with possible background image)
        plotps(lines, points, axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
    else % Diagram not displayed -> Show diagram
        %%% Plot al2sio5 lines
        hold on
        lt(1)=plot([0 550],[-2.23 4.425],'Color',[0.7 0.7 0.7],'LineWidth',2,'Visible','on','HitTest','off'); % and ky
        lt(2)=plot([550 851.02],[4.425 0],'Color',[0.7 0.7 0.7],'LineWidth',2,'Visible','on','HitTest','off'); % sill and
        lt(3)=plot([550 1200],[4.425 18.2768],'Color',[0.7 0.7 0.7],'LineWidth',2,'Visible','on','HitTest','off'); % sill ky
        hold off
        % Set axes limits according to P-T range
        set (axes,'Xlim', [str2num(get(Tmin,'String')) str2num(get(Tmax,'String'))]);
        set (axes,'Ylim', [str2num(get(Pmin,'String')) str2num(get(Pmax,'String'))]);
        xlabel('T(°C)');
        ylabel('P(kbar)');
        % If diagram now displayed, put Hide button
        set(al,'cdata', but_alsioff,'Tag','Show','TooltipString','Hide and-ky-sill');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%