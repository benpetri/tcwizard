function savefig(lines,points,ax1,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% savefig(...)
% Export axes into eps file
%
% Input: - param = structure with initial parameters (see paramin)
%        - lines = struture array with calculated lines
%        - points = structure array with calculated points
%        - axes = handles to the figure axes
%        - Tmin, Tmax = handles to the edit text boxes for the T° range
%        - Pmin, Pmax = handles to the edit text boxes for the P° range
%        - popup = handles to the popupmenu with list of isopleths for detection
%        - use = handles to the use point button in the information panel
%        - cb = double number, state of background image (0=not displayed 1=displayed)
%        - iminfo = structure with information on the background image (see bcgim_in)
%        - bcgim = handles to the Show/Hide background image button
%        - isolated = structure array with isolated objects
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

% Get file format
filename=[];
cd(param.pathin);
[filename,pathname]=uiputfile( {'EPS(*.epsc)';'JPEG(*.jpg)';'TIFF(*.tif)';'Illustrator(*.ai)'},'Save as');
cd(param.matpath);
if ~isempty(filename)
    % Create file name and format
    [name,format]=strtok(filename,'.');
    format=strrep(format,'.','');
    % Create new figure (temporary)
    figure2 = figure('Name','Export');
    AX2=axes('Parent',figure2);
    % Plot results in new figure
    plotps(lines,points,AX2,Tmin,Tmax,Pmin,Pmax,popup,use,cb,iminfo,bcgim,al,dog,data,param,isolated);
    % Save figure
    cd(pathname);
    saveas(figure2,name,format);
    cd(param.matpath);
    % Close temporary figure
    close(figure2);
end