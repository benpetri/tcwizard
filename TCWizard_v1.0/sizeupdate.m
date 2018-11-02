function sizeupdate(figure1,AX,u81,u82,u83,u84,u85,u86,u87,u90,u91,u92,u93,u15,u16,u94,u94b,u95,u96,u0,u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u13,u14,u45,u48,u46,u47,u32,u33,u34,u35,u36,u37,u38,u39,u40,u41,u43,u44,u42,u49,u3000,u4000,u5000,u6000,u7000,h1,h2,h3,panL1,panL2,panL3,panL4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=sizeupdate(...)
% Update the position and the size of each graphical element when resizing
% the main window
%
% Input: - handles of all graphical objects which need to be moved
%
% Output: /
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

% Initial figure position: [20 35 1200 700]
% monres = get(0,'MonitorPosition'); % Get the resolution of the screen
figpos = get(figure1,'Position'); % Get the position of the main figure

set (AX, 'Position', [216/figpos(3) 154/figpos(4) 1-435.6/figpos(3) 1-189/figpos(4)])

set (u0, 'Position', [53.33 figpos(4)-30 53.33 30])
set (u1, 'Position', [106.66 figpos(4)-30 53.34 30])
set (u2, 'Position', [figpos(3)-615 figpos(4)-23 47 15])
set (u3, 'Position', [figpos(3)-565 figpos(4)-23 47 15])
set (u4, 'Position', [figpos(3)-515 figpos(4)-23 47 15])
set (u5, 'Position', [figpos(3)-465 figpos(4)-23 47 15])
set (u6, 'Position', [figpos(3)-415 figpos(4)-23 47 15])
set (u7, 'Position', [figpos(3)-365 figpos(4)-23 47 15])
set (u8, 'Position', [figpos(3)-315 figpos(4)-23 47 15])
set (u9, 'Position', [figpos(3)-265 figpos(4)-23 47 15])
set (u10, 'Position', [0 figpos(4)-30 53.33 30])
set (u13, 'Position', [218 figpos(4)-25 100 18])
set (u14, 'Position', [figpos(3)-689.5 figpos(4)-26 70 20])
set (u15, 'Position', [figpos(3)-207 figpos(4)-203 30 30])
set (u16, 'Position', [figpos(3)-207 figpos(4)-238 30 30])

set (u32, 'Position', [figpos(3)-163 507.5 163 20])
set (u33, 'Position', [figpos(3)-45 488.5 15 17.5])
set (u34, 'Position', [figpos(3)-30 487.5 30 20])
set (u35, 'Position', [figpos(3)-163 460 54.34 15])
set (u36, 'Position', [figpos(3)-108.66 460 54.33 16])
set (u37, 'Position', [figpos(3)-54.33 460 54.33 16])
set (u38, 'Position', [figpos(3)-101.5 360 40 40])
set (u39, 'Position', [figpos(3)-101.5 310 40 40])
set (u40, 'Position', [figpos(3)-101.5 210 40 40])
set (u41, 'Position', [figpos(3)-101.5 160 40 40])
set (u42, 'Position', [figpos(3)-163 40 163 60])
set (u43, 'Position', [figpos(3)-163 114 55 336])
set (u44, 'Position', [figpos(3)-55 114 55 336])
set (u45, 'Position', [figpos(3)-163 figpos(4)-60 163 30])
set (u46, 'Position', [figpos(3)-163 figpos(4)-45 110 40])
set (u47, 'Position', [figpos(3)-53 figpos(4)-25 53 20])
set (u48, 'Position', [figpos(3)-163 figpos(4)-90 163 30])
set (u49, 'Position', [figpos(3)-163 0 40 40])

set (u81, 'Position', [figpos(3)/2-318 10 100 100])
set (u82, 'Position', [figpos(3)/2-218 10 100 100])
set (u83, 'Position', [figpos(3)/2-118 10 100 100])
set (u84, 'Position', [figpos(3)/2-018 10 100 100])
set (u85, 'Position', [figpos(3)/2+82 10 100 100])
set (u86, 'Position', [figpos(3)/2+182 10 100 100])
set (u87, 'Position', [figpos(3)/2+282 10 100 100])

set (u90, 'Position', [figpos(3)-207 figpos(4)-63 30 30])
set (u91, 'Position', [figpos(3)-207 figpos(4)-98 30 30])
set (u92, 'Position', [figpos(3)-207 figpos(4)-133 30 30])
set (u93, 'Position', [figpos(3)-207 figpos(4)-168 30 30])
set (u94, 'Position', [figpos(3)-207 figpos(4)-273 30 30])
set (u94b, 'Position', [figpos(3)-207 figpos(4)-308 30 30])
set (u95, 'Position', [figpos(3)-207 figpos(4)-343 30 30])
set (u96, 'Position', [figpos(3)-207 figpos(4)-378 30 30])

set (u3000, 'Position', [figpos(3)-101.5 0 40 40])
set (u4000, 'Position', [figpos(3)-40 0 40 40])
set (u5000, 'Position', [figpos(3)/2-411.5 90 65 20])
set (u6000, 'Position', [figpos(3)/2-411.5 35 65 50])
set (u7000, 'Position', [figpos(3)/2-411.5 10 65 20])

set (h1, 'Position', [0 640.5/figpos(4) 159.6/figpos(3) 28/figpos(4)])
set (h2, 'Position', [0 39.9/figpos(4) 158.4/figpos(3) 28/figpos(4)])
set (h3, 'Position', [1-164.4/figpos(3) 539/figpos(4) 164.4/figpos(3) 42/figpos(4)])


set (panL1, 'Position', [-12/figpos(3) -7/figpos(4) 175.2/figpos(3) 676.9/figpos(4)])
set (panL2, 'Position', [0.5-414/figpos(3) 5.6/figpos(4) 804/figpos(3) 105/figpos(4)])
set (panL3, 'Position', [1-166.8/figpos(3) 1-93.8/figpos(4) 187.2/figpos(3) 91.7/figpos(4)])
set (panL4, 'Position', [1-166.8/figpos(3) -7/figpos(4) 187.2/figpos(3) 590.8/figpos(4)])

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%