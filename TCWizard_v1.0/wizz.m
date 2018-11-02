%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%               TCWizard                %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%       Graphical User Interface        %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%      Main program to be executed      %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%           PRESS F5 TO START           %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%      SEE ALSO TCWizard Help File      %%%%%%%%%%%%%%%%%%
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

close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Definition of variables
% Initial parameters from the project file
param = struct ('pathin',{},'project',{},'axfile',{},'resultfile',{},'ofile',{},'PTrange',{},'matpath',{});
excess=[];
phaselist=[];
list_path=cell(0);
isolist={'...'}; % display for initial listbox
iminfo = struct('P',{},'T',{},'path',{}); % background image
cb=0; % display background image (0=no 1=yes)
kill=0;

% Structures for storing the calculated lines and points
lines = struct([]); % for classical P-T calculations
points = struct([]); % for classical P-T calculations
isolated = struct([]); % for isolated objects in the P-T space
data = struct ('P',{},'T',{},'ass',{},'color',{}); % for dogmin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Graphical interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Figure
figure1 = figure('Name','TC Wizard','NumberTitle','off','Units','Pixels','Position',[20 35 1200 700],'MenuBar','none');
set(figure1,'CloseRequestFcn','textguess_off;');

%%% Axes
AX=axes('Parent',figure1) ;
xlabel('T(°C)');
ylabel('P(kbar)');

%%% Panels
panL1 = uipanel(); % Simple calculation panel
panL2 = uipanel(); % Informations panel
panL3 = uipanel(); % Isopleths detection panel
panL4 = uipanel(); % Wizard calculation panel

% panL1 = uipanel('Position',[-.01 -.01 .146 .967]); % Main calculation panel
% panL2 = uipanel('Position',[.155 .008 .67 .150]); % Informations panel
% panL3 = uipanel('Position',[.861 .866 .156 .131]); % Isopleth detection panel
% panL4 = uipanel('Position',[.861 -.01 .156 .844]); % Wizard calculation panel

%%% P-T diagram - Datacursor info
u80=datacursormode;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Information Panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Static text boxes to display point information
u81 = uicontrol('Style','text','String','Point information :','HorizontalAlignment','left');
u82 = uicontrol('Style','text','String','','HorizontalAlignment','left');
u83 = uicontrol('Style','text','String','','HorizontalAlignment','left');
u84 = uicontrol('Style','text','String','','HorizontalAlignment','left');
u85 = uicontrol('Style','text','String','','HorizontalAlignment','left');
u86 = uicontrol('Style','text','String','','HorizontalAlignment','left');
u87 = uicontrol('Style','text','String','','HorizontalAlignment','left');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display Tools
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% For Matlab 2011 & more recent versions (pan, zoom and cursor)
% u88 = zoom;
% u89 = pan;
% but_zi = imread('button_zoomin.png');
% but_zo = imread('button_zoomout.png');
% but_pan = imread('button_pan.png');
% but_datacur = imread('button_datacur.png');
% u90 = uicontrol('Style','pushbutton','cdata',but_zi,'Position',[995 630 30 30],'Callback','zoom_in(u80,u88,u89)','TooltipString','Zoom In');
% u91 = uicontrol('Style','pushbutton','cdata',but_zo,'Position',[995 595 30 30],'Callback','zoom_out(u80,u88,u89)','TooltipString','Zoom Out');
% u92 = uicontrol('Style','pushbutton','cdata',but_pan,'Position',[995 560 30 30],'Callback','pan_on(u80,u88,u89)','TooltipString','Pan');
% u93 = uicontrol('Style','pushbutton','cdata',but_datacur,'Position',[995 525 30 30],'Callback','datacur_on(u80,u88,u89,u81,u82,u83,u84,u85,u86,u87)','TooltipString','Data Cursor');

%%% For older Matlab version (pan, zoom and cursor)
but_zi = imread('button_zoomin.png');
but_zo = imread('button_zoomout.png');
but_pan = imread('button_pan.png');
but_datacur = imread('button_datacur.png');
but_alsion = imread('button_alsion.png');
but_alsioff = imread('button_alsioff.png');
but_dogminon = imread('button_dogminon.png');
but_dogminoff = imread('button_dogminoff.png');
but_savefig = imread('button_savefig.png');
but_importim = imread('button_importim.png');
but_imshow = imread('button_imshow.png');
but_imhide = imread('button_imhide.png');
but_legon = imread('button_legon.png');
but_legoff = imread('button_legoff.png');
u90 = uicontrol('Style','pushbutton','cdata',but_zi,'Callback','zoom_in(u80)','TooltipString','Zoom In');
u91 = uicontrol('Style','pushbutton','cdata',but_zo,'Callback','zoom_out(u80)','TooltipString','Zoom Out');
u92 = uicontrol('Style','pushbutton','cdata',but_pan,'Callback','pan_on(u80)','TooltipString','Pan');
u93 = uicontrol('Style','pushbutton','cdata',but_datacur,'Callback','datacur_on(u80,u81,u82,u83,u84,u85,u86,u87)','TooltipString','Data Cursor');
u15 = uicontrol('Style','pushbutton','cdata',but_alsion,'Callback','al2sio5(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Show/Hide and-ky-sill');
u16 = uicontrol('Style','pushbutton','cdata', but_legon,'Callback','legenddisp(u16,AX,lines);','TooltipString','Show/Hide legend');
u94 = uicontrol('Style','pushbutton','cdata',but_dogminoff,'Enable','off','Callback','dogmin_disp(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Show/Hide Dogmin results');
u94b = uicontrol('Style','pushbutton','cdata',but_savefig,'Callback','savefig(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Export figure');
u95 = uicontrol('Style','pushbutton','cdata',but_importim,'Callback','[cb,iminfo]=bcgim_in(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Import Background Image');
u96 = uicontrol('Style','pushbutton','cdata',but_imhide,'Enable','off','Callback','cb=bcgim(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Show/Hide image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Calculation Panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Top - Project Management Tools & P-T range
u0 = uicontrol('Style','pushbutton','String','Load','Callback','[lines,points,excess,phaselist,param,ignore,data,cb,iminfo]=loadpl(u95,u96,u94); [ch1,ch2,ed1,phaselist]=projectin(param,excess,phaselist,ignore,u7,u9,u3,u5,u54,u43,AX,u13); [lines,points,isolated]=readps(param,lines,points,isolated); [loglines,logpoints]=reado(param.pathin,excess); [lines,points,isolated]=addlog(lines,loglines,points,logpoints,isolated); drawout(lines,points,param); plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Load pseudosection');
u1 = uicontrol('Style','pushbutton','String','Save','Callback','savepl(lines,points,param,excess,phaselist,ignore,data,cb,iminfo);','TooltipString','Save pseudosection');
u2 = uicontrol('Style','text','String','Pmin');
u3 = uicontrol('Style','edit','String','...');
u4 = uicontrol('Style','text','String','Pmax');
u5 = uicontrol('Style','edit','String','...');
u6 = uicontrol('Style','text','String','Tmin');
u7 = uicontrol('Style','edit','String','...');
u8 = uicontrol('Style','text','String','Tmax');
u9 = uicontrol('Style','edit','String','...');
u10 = uicontrol('Style','pushbutton','String','Proj. File','Callback','[param,excess,phaselist,ignore]=paramin(param);[ch1,ch2,ed1,phaselist]=projectin(param,excess,phaselist,ignore,u7,u9,u3,u5,u54,u43,AX,u13);','TooltipString','Choose Thermocalc project file');
%%% Project name and Reset axes
u13 = uicontrol('Style','text','String','Project Name','FontSize',10,'FontWeight','bold');
u14 = uicontrol('Style','pushbutton','String','Reset Axes','Callback','resetaxes(param,AX,u7,u9,u3,u5)','TooltipString','Reset Axes');
%%% Radiobuttons
h1 = uibuttongroup();
u11 = uicontrol('Style','Radio','String','Mode','pos',[10 5 60 15],'Parent',h1,'Tag','radiobutton1');
u12 = uicontrol('Style','Radio','String','Isopleth','pos',[80 5 60 15],'Parent',h1,'Tag','radiobutton2');

%%% Middle - Text, phases, mode
u20 = uicontrol('Style','text','String','Phases','Position',[0 620 42.5 15]);
u21 = uicontrol('Style','text','String','Ass','Position',[47.5 620 30 15]);
u22 = uicontrol('Style','text','String','Mode','Position',[82.5 620 30 15]);
u23 = uicontrol('Style','text','String','Value','Position',[117.5 620 42.5 15]);

%%% Bottom - End
u50 = uicontrol('Style','pushbutton','String','GO','Position',[120 0 40 40],'Callback','tctxt(param,phaselist,ch1,ch2,ed1,u12,u55,u7,u9,u3,u5,u52,u53,u50);[lines,points,isolated]=readps(param,lines,points,isolated); [loglines,logpoints]=reado(param.pathin,excess); [lines,points,isolated]=addlog(lines,loglines,points,logpoints,isolated); drawout(lines,points,param); plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Run Thermocalc');
u51 = uicontrol('Style','text','String','Isopleth','Position',[0 71 53 15],'Enable','off');
u52 = uicontrol('Style','edit','String','Name','Position',[54 71 53 16],'Enable','off');
u53 = uicontrol('Style','edit','String','Value','Position',[107 71 53 16],'Enable','off');
u54 = uicontrol('Style','text','String','Excess Phases:  + ','Position',[0 90 160 15]);
h2 = uibuttongroup();
u55 = uicontrol('Style','Radio','String','T at P','pos',[10 5 60 15],'Parent',h2);
u56 = uicontrol('Style','Radio','String','P at T','pos',[80 5 60 15],'Parent',h2);
but_cut1 = imread('button_cut1.png');
but_cutn = imread('button_cutn.png');
u57 = uicontrol('Style','pushbutton','cdata',but_cutn,'Position',[80 0 40 40],'Callback','lines1=chooseps(lines,points); lines=lines1; lines=cutps(lines,points); drawout(lines,points,param); plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Cut lines');
u58 = uicontrol('Style','pushbutton','cdata',but_cut1,'Position',[40 0 40 40],'Callback','[lines1,choice]=recut(lines); lines=lines1; lines1=chooseps(lines,points,choice); lines=lines1; lines=cutps(lines,points); drawout(lines,points,param); plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Cut line');
u59 = uicontrol('Style','pushbutton','String','Clear','Position',[0 0 40 40],'Callback','[lines,points]=clearlast(lines,points); drawout(lines,points,param);plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Delete Curve/Point');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wizard Panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Isopleth Detection Panel
u45 = uicontrol('Style','pushbutton','String','Detect isopleths','Callback','detect(u46,u47,lines);','TooltipString','Detect isopleth trend');
u48 = uicontrol('Style','pushbutton','String','Clear isopleths','Callback','cla; plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Clear isopleth trend');
u46 = uicontrol('Style','popupmenu','String',isolist);
u47 = uicontrol('Style','edit','String','Value');

% Top - Start
h3 = uibuttongroup();
u30 = uicontrol('Style','Radio','String','Mode Wizard','pos',[30 22.5 100 15],'Parent',h3,'Tag','radiobutton3');
u31 = uicontrol('Style','Radio','String','Isopleth Wizard','pos',[30 5 100 15],'Parent',h3,'Tag','radiobutton4');

% Middle - Phase list
u32 = uicontrol('Style','edit','String','Starting Assemblage');
u33 = uicontrol('Style','text','String','-');
u34 = uicontrol('Style','edit','String','Ph.');

u35 = uicontrol('Style','text','String','Isopleth','Enable','off');
u36 = uicontrol('Style','edit','String','Name','Enable','off');
u37 = uicontrol('Style','edit','String','Value','Enable','off');

but_add=imread('button_add.png');
but_del=imread('button_del.png');
but_up=imread('button_up.png');
but_down=imread('button_down.png');
u38 = uicontrol('Style','pushbutton','cdata',but_add,'Callback','list_path=buttonadd(u43,u44,list_path);','TooltipString','Add to list');
u39 = uicontrol('Style','pushbutton','cdata',but_del,'Callback','list_path=buttondel(u44,list_path);','TooltipString','Delete from list');
u40 = uicontrol('Style','pushbutton','cdata',but_up,'Callback','list_path=buttonup(u44,list_path);','TooltipString','Move up');
u41 = uicontrol('Style','pushbutton','cdata',but_down,'Callback','list_path=buttondown(u44,list_path);','TooltipString','Move down');

u43 = uicontrol('Style','listbox','String','...'); 
u44 = uicontrol('Style','listbox','String',[]); 

% Bottom - End
but_gowiz=imread('button_gowiz.png');
u42 = uicontrol('Style','pushbutton','cdata',but_gowiz,'Callback','[slbegin1,slbegin2]=size(lines);[spbegin1,spbegin2]=size(points); [list_asbl,out_list]=mode_wizzard(param,u32,u34,u44,u42,u31,u36,u37);[lines,points,isolated]=readps(param,lines,points,isolated); [loglines,logpoints]=reado(param.pathin,excess); [lines,points,isolated]=addlog(lines,loglines,points,logpoints,isolated); drawout(lines,points,param); plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated); wizz_log(lines,points,param,u32,u34,u44,u31,u36,u37,list_asbl,out_list,slbegin2,spbegin2);','TooltipString','Run Thermocalc in Wizard mode');
logfile=[param.pathin 'wizzard_log.txt'];
u49 = uicontrol('Style','pushbutton','String','Log','Callback','cd(param.pathin);winopen(logfile);cd(param.matpath);','TooltipString','Open the log of the last wizard run');

but_cutw = imread('button_cutw.png');
but_dogmin = imread('button_dogmin.png');
u3000 = uicontrol('Style','pushbutton','cdata',but_cutw,'Callback','[lines,points]=cut_wizzard(lines,points);lines=cutps(lines,points); drawout(lines,points,param); plotps(lines,points,AX,u7,u9,u3,u5,u46,u5000,cb,iminfo,u96,u15,u94,data,param,isolated);','TooltipString','Cut lines in Wizard mode');
u4000 = uicontrol('Style','pushbutton','cdata',but_dogmin,'Callback','data=dogmin_wizzard(param,phaselist,data,u94);','TooltipString','Run Thermocalc in dogmin mode');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Selection Change Functions
set(h1,'SelectionChangeFcn',{@radioupdate1,u51,u52,u53});
set(h3,'SelectionChangeFcn',{@radioupdate2,u35,u36,u37,u34});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button to use starting guesses
u5000 = uicontrol('Style','pushbutton','String','Use point','Enable','off','Callback','textguess_on(param,excess,lines,points,u80,u6000);','TooltipString','Use selected P-T guess');
u6000 = uicontrol('Style','text','String','Using initial project file');
u7000 = uicontrol('Style','pushbutton','String','Initial','Callback','textguess_off(param,u6000);','TooltipString','Use initial P-T guess');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Update and Close Functions
set(u80,'DisplayStyle','datatip','SnapToDataVertex','on','Enable','on','UpdateFcn',{@cursorupdate,u81,u82,u83,u84,u85,u86,u87});
set(figure1,'ResizeFcn','sizeupdate(figure1,AX,u81,u82,u83,u84,u85,u86,u87,u90,u91,u92,u93,u15,u16,u94,u94b,u95,u96,u0,u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u13,u14,u45,u48,u46,u47,u32,u33,u34,u35,u36,u37,u38,u39,u40,u41,u43,u44,u42,u49,u3000,u4000,u5000,u6000,u7000,h1,h2,h3,panL1,panL2,panL3,panL4);');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%