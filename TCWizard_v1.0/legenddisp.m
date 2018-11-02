function legenddisp(button,axes, lines)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% legenddisp(...)
% Show/Hide legend
%
% Input: - button = handles to the Legend Show/Hide button
%        - axes = handles to the figure axes
%        - lines = struture array with calculated lines
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

% Get current display status
state=get(button,'Tag');
if strcmp(state,'Hide') % Legend displayed -> Hide legend
    legend('off')
    s=2;
else % Legend not displayed -> Show legend
    hline = findobj(gcf, 'type', 'line'); % Get line objects displayed on the axes
    dl1={lines.lphase}; % Get names of lines
    for i=1:size(hline,1)
        col(i,:)=get(hline(size(hline,1)-i+1),'Color'); % Get color of displayed lines
    end
    dl2=num2cell(zeros(size(dl1)));
    tv=0;
    tc=zeros(size(col));
    for i=1:size(dl1,2) % Loop to avoid redundancy in the legend
        for j=1:size(dl1,2)
                if tc(j,:)==col(i,:)
                    tv=1;
                end
        end
        if tv==1
            dl2{i}=999;
        else
            dl2{i}= dl1{i};
            tc(i,:)=col(i,:);
        end
        tv=0;
    end
    j=1;
    for i=1:size(dl2,2) % Synchronize lines chosen to be displayed in the legend, names in the legend, color of lines on the axes
        if dl2{i} ~= 999
            dl3{j}=dl2{i};
            col2(j,:)=col(i,:);
            j=j+1;
        end
    end
    for i=1:size(col2,1) % Sort everything
        col3(i,:)=col2(size(col2,1)+1-i,:);
    end
    legend(dl3)
    hline = findobj(gcf, 'type', 'line'); % Update the lines displayed on the axes AND in the legend
    for i=1:size(dl3,2)
        set(hline(i*2),'Color',col3(i,:)); % Update color of the legend to avoid color discrepancies between axes and legend
    end
    s=1;
end
% %%% Import icons
but_legon = evalin('base','but_legon');
but_legoff = evalin('base','but_legoff');
%
if s==1 % If diagram displayed, put Hide button
    set(button,'cdata', but_legoff,'Tag','Hide','TooltipString','Hide legend');
else % If diagram not displayed, put Show button
    set(button,'cdata', but_legon,'Tag','Show','TooltipString','Show legend');
end

end