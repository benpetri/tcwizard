function cb=bcgim(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=bcgim(...)
% Show/Hide background image
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
% Output: - cb = double number, state of background image (0=not displayed 1=displayed), updated
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
but_imshow = evalin('base','but_imshow');
but_imhide = evalin('base','but_imhide');

%%% Display
if isempty(iminfo) % If no background image selected
    menu('No image selected','Ok');
elseif cb==1 % Image displayed -> Hide image
    % Update cb marker and plot
    cb=0;
    plotps(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
    % Set button to Show
    set(bcgim,'cdata',but_imshow);
elseif cb==0 % Image not displayed -> Show image
    % Update cb marker and plot
    cb=1;
    plotps(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
    % Set button to Hide
    set(bcgim,'cdata',but_imhide);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%