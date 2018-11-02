function dogmin_plot(data,button)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% dogmin_plot(...)
% Plot results of Gibbs energy minimization mode
%
% Input: - data = structure with dogmin data
%        - button = handles to the Show/Hide dogmin results button
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

if ~isempty(data)
    %%% Build list of assemblages
    [sd1,sd2]=size(data);
    export=struct2cell(data);
    ass_list(1:sd2)=export(3,:,1:sd2);
    ass_list=unique(ass_list);
    %%% Create colormap
    cl=colormap(hsv(length(ass_list)));
    Zlist=(1:length(ass_list))';
    for cc=1:sd2
        % Assign color code
        data(cc).color=cl(strcmp(ass_list,data(cc).ass),:);
        data(cc).Z=Zlist(strcmp(ass_list,data(cc).ass),:);
        % Plot
        plot(data(cc).T,data(cc).P,'Color',data(cc).color,'Marker','s','MarkerFaceColor',data(cc).color,'MarkerSize',5.0,'DisplayName',data(cc).ass,'Tag',num2str(cc+2000))
        hold on
    end
    % Set button
    set(button,'Enable','on');
    set(button,'TooltipString','Hide dogmin data');
    set(button,'Tag','Show');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % %%%%% Legend version with figure
%%% Delete existing legend
htmp=findobj('Tag','dglegend');
if ~isempty(htmp)
    delete(htmp);
end
% % % %%% Build legend graphics
% % % % Extract number of assemblages
% % % cmdat=struct2cell(data);
% % % z=cell2mat(cmdat(5,:,1:sd2));
% % % zleg=unique(z);
% % % %%% Graphics
% % % % If too many assemblages, two columns
% % % if length(zleg)<=25
% % %     height=20*length(zleg);
% % %     width=300;
% % % else
% % %     height=20*25; % Fixed length 25 elements
% % %     width=620;
% % % end
% % % rectH=(width*0.015/height);
% % % effheight=height-(0.04*height)-(rectH*height);
% % % interval_size=effheight/(length(zleg)-1);
% % % % Build figure
% % % figure2 = figure('Name','Do G min : Legend','NumberTitle','off','Position',[300 100 width height],'MenuBar','none','Tag','dglegend');
% % % set(gca,'Visible','off');
% % % for k=1:length(zleg)
% % %     if k<=25
% % %         yp=0.02+( (k-1)*(interval_size/height) ) + ( (k-1)*0.015 );
% % %         % Legend marker
% % %         leg(k)=annotation('rectangle','Position', [0.05 yp 0.015 rectH],'FaceColor',cl(k,:),'Tag','dglegend');
% % %         % Assemblage text (mysterious offset=0.22)
% % %         legt(k)=annotation('textbox','Position', [(0.05+0.015+0.025) yp 0.5 rectH],'String',ass_list(k),'VerticalAlignment','middle','EdgeColor','none','Tag','dglegend');
% % %     else
% % %         yp=0.02+( (k-26)*(interval_size/height) ) + ( (k-26)*0.015 );
% % %         % Legend marker
% % %         leg(k)=annotation('rectangle','Position', [(0.5+0.05) yp 0.015 rectH],'FaceColor',cl(k,:),'Tag','dglegend');
% % %         % Assemblage text (mysterious offset=0.22)
% % %         legt(k)=annotation('textbox','Position', [(0.5+0.05+0.015+0.025) yp 0.5 rectH],'String',ass_list(k),'VerticalAlignment','middle','EdgeColor','none','Tag','dglegend');
% % %     end
% % % end
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %%%%% Legend version with graphics
% % % %%% Delete existing legend
% % % htmp=findall(gcf,'Tag','dglegend');
% % % if ~isempty(htmp)
% % %     delete(htmp);
% % % end
% % % %%% Build legend graphics
% % % % Extract number of assemblages
% % % cmdat=struct2cell(data);
% % % z=cell2mat(cmdat(5,:,1:sd2));
% % % zleg=unique(z);
% % % %%% Graphics
% % % height=0.025*length(zleg)+0.015; % height of the legend box
% % % ypos=0.93-height; % y position of the legend box
% % % leg=annotation('rectangle','Position', [0.19 ypos 0.16 height],'Tag','dglegend','FaceColor','w');
% % % for k=1:length(zleg)
% % %     yp=0.93-0.015-(k-1)*(0.025);
% % %     % Legend marker
% % %     leg(k)=annotation('rectangle','Position', [0.20 (yp-0.01) 0.01 0.01],'FaceColor',cl(k,:),'Tag','dglegend');
% % %     % Assemblage text (mysterious offset)
% % %     legt(k)=annotation('textbox','Position', [0.21 (yp-0.1+0.012) 0.1 0.1],'String',ass_list(k),'FitHeightToText','on','EdgeColor','none','Tag','dglegend');
% % % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %%%% Legend version with Legend function (warnings)
% % % % Get all dogmin data (square markers)
% % % h=findobj('Marker','square');
% % % % Extract assemblages
% % % for m=1:length(h)
% % %     asd(m)={get(h(m),'DisplayName')};
% % % end
% % % % Remove multiple
% % % asd2(1)=asd(1);
% % % inc=1;
% % % for n=2:length(asd)
% % %     g=[];
% % %     for nn=1:length(asd2)
% % %         if strcmp(asd(n),asd2(nn))
% % %             g=[g 1];
% % %         else
% % %             g=[g 0];
% % %         end
% % %     end
% % %     if ~sum(g)
% % %         inc=inc+1;
% % %         asd2(inc)=asd(n);
% % %     end
% % % end
% % % % Display legend
% % % L2=legend(h,asd2(1:end),'Location','Northwest');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%