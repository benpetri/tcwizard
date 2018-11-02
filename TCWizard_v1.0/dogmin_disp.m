function dogmin_disp(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% dogmin_disp(...)
% Show/Hide dogmin results
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
but_dogminon = evalin('base','but_dogminon');
but_dogminoff = evalin('base','but_dogminoff');
%%%
% Get current display status
state=get(dog,'Tag');
if strcmp(state,'Show') % Data displayed -> Hide data
    % Set Show button
    set(dog,'cdata', but_dogminon,'Tag','Hide','TooltipString','Show data');
    % Delete dogmin legend graphics
    htmp=findall(gcf,'Tag','dglegend');
    delete(htmp);
    % Plot previous results only (with possible background image)
    plotps(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
else % Data not displayed -> Show data    
    % Plot dogmin data
    hold on
    dogmin_plot(data,dog);
    hold off
    % Set Hide button
    set(dog,'cdata', but_dogminoff,'Tag','Show','TooltipString','Hide data');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%