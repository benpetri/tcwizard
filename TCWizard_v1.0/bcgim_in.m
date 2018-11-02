function [cb,iminfo]=bcgim_in(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=bcgim_in(...)
% Import background image and parameters
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
% Output: - cb_up = double number, state of background image (0=not displayed 1=displayed), updated
%         - iminfo = structure with information on the background image, updated
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

if isempty(char(iminfo.path)) % If no background image
    % Select background image
    cd(param.pathin);
    [bcgname,bcgpath]=uigetfile('*.*','Background image ?');
    cd(param.matpath);
    % Store path and name
    iminfo(1).path=[bcgpath bcgname];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Ask for image limits
    PTlim=inputdlg({'Pmin Pmax (separated by space)','Tmin Tmax (separated by space)'},'Image limits');
    P=char(PTlim(1));
    [Plmin,Plmax]=strtok(P);
    % Store Plmin Plmax
    iminfo(1).P=[str2num(Plmin) str2num(Plmax)];
    T=char(PTlim(2));
    [Tlmin,Tlmax]=strtok(T);
    % Store Tlmin Tlmax
    iminfo(1).T=[str2num(Tlmin) str2num(Tlmax)];
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Display image
    cb=1;
    plotps(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
    % Set button
    but_imhide = evalin('base','but_imhide');
    set(bcgim,'Enable','on','cdata',but_imhide);
else % Import new background image
    % Question
    new = questdlg('Do you want to import a new background image ?','Import ?','Yes','No','No');
    %%%%%%%%%%%%%%%%%%%%%%%%
    switch new
        case 'Yes' % If new image
            cd(param.pathin);
            [bcgname,bcgpath]=uigetfile('*.*','Background image ?');
            cd(param.matpath);
            iminfo(1).path=[bcgpath bcgname];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Ask for image limits
            P=inputdlg('Pmin Pmax (separated by space)');
            P=char(P);
            [Plmin,Plmax]=strtok(P);
            % Store Plmin Plmax
            iminfo(1).P=[str2num(Plmin) str2num(Plmax)];
            T=inputdlg('Tmin Tmax (separated by space)');
            T=char(T);
            [Tlmin,Tlmax]=strtok(T);
            % Store Tlmin Tlmax
            iminfo(1).T=[str2num(Tlmin) str2num(Tlmax)];
            % Display image
            cb=1;
            plotps(lines,points,axes,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
            % Set button
            but_imhide = evalin('base','but_imhide');
            set(bcgim,'Enable','on','cdata',but_imhide);
    end
end