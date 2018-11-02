function [lines,points,excess,phaselist,param,ignore,data,cb,iminfo]=loadpl(im,disp,dogbut)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=loadpl
% Load matlab .mat file containing the initial parameters for wizzard and
% the data calculated with Thermocalc.
% 
% Input: - imp = handles to the Import background image button
%        - disp = handles to the Show/Hide background image button
%
% Output :  - lines = structure with calculated lines
%           - points = structure with calculated points
%           - excess = cell array of excess phases specified in the project
%           file
%           - phaselist = cell array of available phases (without excess
%           phases)
%           - param = structure of initial parameters (see paramin)
%           - ignore = cell array of ignored phases specified in the
%           project file
%           - data = structure with dogmin data
%           - cb = double number,state of background image (0=not displayed 1=displayed)
%           - iminfo = structure with information on the background image (see bcgim_in)
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

%%% Store TC package path
matpath=pwd;

%%% Load file
[ldname,ldpath]=uigetfile('*.mat','Load file ?');
cd(ldpath);
load(ldname);

%%% Ask for project file
[Namein,Pathin]=uigetfile('*.txt','Project file ?');

%%% Ask for image file, if any
[si1,si2]=size(iminfo);
if si1~=0
    [Nameimage,Pathimage]=uigetfile('*.*','Image file ?');

end

%%% Reassign paths
param.pathin=Pathin;
param.matpath=matpath;
iminfo.path=[Pathimage Nameimage];
% Go back to matlab path
cd(param.matpath);

% Erase older results by running TC
firstrun=[param.pathin '1run.txt'];
fid2=fopen(firstrun,'w+');
fprintf(fid2,'\r\n\r\n');
fclose(fid2);
% Run TC to generate the phase list
cd(param.pathin);
[s,t]=dos('tc333.exe < 1run.txt');
cd(param.matpath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% If background image is loaded, set button to Hide
if si1~=0
    set(im,'Enable','on');
    set(disp,'Enable','on');
end
% Test if background image has to be displayed or not
if cb==0 % Image is not displayed, button should be show
    but_imshow = imread('button_imshow.png');
    set(disp,'cdata',but_imshow);
else % Image is displayed, button should be hide
    but_imhide = imread('button_imhide.png');
    set(disp,'cdata',but_imhide);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Import icon
but_dogminoff = evalin('base','but_dogminoff');
%%% If dogmin data, enable button and plot
if ~isempty(data)
    set(dogbut,'Enable','on');
    set(dogbut,'cdata',but_dogminoff,'Tag','Show','TooltipString','Hide data');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%