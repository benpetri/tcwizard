function output_txt = cursorupdate(empt,event_obj,u81,u82,u83,u84,u85,u86,u87)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=cursorupdate(...)
% Update function displaying the properties of the point selected by the cursor in
% datacursor mode
%
% Input: - empt = Currently not used in the update function
%        - event_obj = Object containing event data structure
%        - u81 to u87 = handles of the static text boxes displaying point
%        informations
%
% Output: - output_txt = Data cursor text containing the text to be
%           displaid on the figure
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

%%% Get cursor info
% Get the position from the cursor
position = get(event_obj,'Position');
Tcrs=position(1);
Pcrs=position(2);
% Get object information
target = get(event_obj,'Target');
% PTNB not ok if line cut
% ptnb = get(event_obj,'DataIndex');
% Handle of the graphics object
hoinfo=get(target);
% Tag of the graphics object = line number (if <1000) or of point number (if>1000)
tag=str2num(hoinfo.Tag);
%%% Import variables
lines=evalin('base','lines'); % Import lines from the main workspace
points=evalin('base','points'); % Import points from the main workspace
phaselist=evalin('base','phaselist'); % Import phaselist from the main workspace
excess=evalin('base','excess'); % Import phaselist from the main workspace
data=evalin('base','data'); % Import data (dogmin results) from the main workspace
data=struct2cell(data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Array building from lines data
if tag<1000 % LINE info
    isonamcur=fieldnames(lines);
    isonamcur(1:13)=[];
    isovalcur=zeros(size(isonamcur));
    for i=1:size(isonamcur,1)
        tempiso=cell2mat(isonamcur(i));
        if isequal(lines(tag).(tempiso),[])==0
            % Added 07/2013, If line cut, find actual coordinate
            ind1=find(lines(tag).lcrd(:,1)==Pcrs);
            ind2=find(lines(tag).lcrd(:,2)==Tcrs);
            if ~isempty(ind1) && ~isempty(ind2) && ind1==ind2
                ptnb=ind1;
            end
            isovalcur(i)=lines(tag).(tempiso)(ptnb);
        else
            isovalcur(i)=999;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif tag >= 1000 && tag <= 1999 % POINT info
    isonamcur=fieldnames(points);
    isonamcur(1:10)=[];
    isovalcur=zeros(size(isonamcur));
    for i=1:size(isonamcur,1)
        tempiso=cell2mat(isonamcur(i));
        if isequal(points(tag-1000).(tempiso),[])==0
            %isovalcur(i)=points(tag-1000).(tempiso)(ptnb);
            isovalcur(i)=points(tag-1000).(tempiso)(1);
        else
            isovalcur(i)=999;
        end
    end
elseif  tag >= 2000 % DOGMIN info
    dmptna=data(3,:,tag-2000);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tag < 2000
    % If isopleth absent from calculation, delete it from the list
    j=1;
    for i=1:size(isovalcur,1)
        if isovalcur(j) == 999
            isovalcur(j)=[];
            isonamcur(j)=[];
            j=j-1;
        end
        j=j+1;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Display precision
    Tcrs=roundn(Tcrs,-1);
    Pcrs=roundn(Pcrs,-2);
    isovalcur=roundn(isovalcur,-4);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Modify field names with parentheses
    for j=1:length(isonamcur)
        for k=1:length(phaselist)
            if strfind ( char(isonamcur(j)),char(phaselist(k)) ) % If phase present
                % Add parentheses ( ex: xst -> x(st) )
                rep=['(' char(phaselist(k)) ')'];
                isonamcur(j)={strrep(char(isonamcur(j)),char(phaselist(k)),rep)};
            end
        end
        for k2=1:length(excess)
            if strfind ( char(isonamcur(j)),char(excess(k2)) ) % If phase present as excess
                % Add parentheses ( ex: xst -> x(st) )
                rep=['(' char(excess(k2)) ')'];
                isonamcur(j)={strrep(char(isonamcur(j)),char(excess(k2)),rep)};
            end
        end
        isonamcur(j)={strrep(char(isonamcur(j)),'_','')};
        %%%%
        % Correct liquid isopleths ( ex: anL -> an(L) )
        if ~isempty(strfind(char(isonamcur(j)),'L'))
            isonamcur(j)={strrep(char(isonamcur(j)),'L','(L)')};
        end
        % Correct li(q), (q)(L)...
        if ~isempty(strfind(char(isonamcur(j)),'li(q)'))
            isonamcur(j)={strrep(char(isonamcur(j)),'li(q)','liq')};
        elseif ~isempty(strfind(char(isonamcur(j)),'(q)(L)'))
            isonamcur(j)={strrep(char(isonamcur(j)),'(q)(L)','q(L)')};
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Building of display data
    % Line or point number
    if tag<1000
        tagdsp=['Curve: u' num2str(tag)];
    else
        tagdsp=['Point: i' num2str(tag-1000)];
    end
    % P-T coordinates
    Tdsp=['T: ' num2str(Tcrs)];
    Pdsp=['P: ' num2str(Pcrs)];
    % Assemblage
    if tag<1000
        [assdsp,out]=strtok(lines(tag).lass,'-');
    else
        [assdsp,out]=strtok(points(tag-1000).pass,'-');
    end
    assdsp(end)=[];
    % First bloc
    dspinfo={tagdsp Tdsp Pdsp assdsp};
    % Static text blocs
    uar(1)=u81;
    uar(2)=u82;
    uar(3)=u83;
    uar(4)=u84;
    uar(5)=u85;
    uar(6)=u86;
    uar(7)=u87;
    % Build list of isopleth data
    if isempty(isovalcur) == 0
        for i=1:size(isonamcur,1)
            tmpdspiso=[cell2mat(isonamcur(i)) ': ' num2str(isovalcur(i))];
            dspinfo(i+4)={tmpdspiso};
        end
    else
        dspinfo(5)={'No info. to display'};
    end
    % Add the target name of the calculation and begin and end if line cut
    if tag<1000
        if strfind(lines(tag).lphase,'(') ~= 0
            if ~isempty(lines(tag).linef)
                set(uar(1),'String',[dspinfo(1) dspinfo(4) ['Isopleth: ' lines(tag).lphase] ['Begin: ' lines(tag).ltbegin] ['End: ' lines(tag).ltend] dspinfo(2:3)]);
            else
                set(uar(1),'String',[dspinfo(1) dspinfo(4) ['Isopleth: ' lines(tag).lphase] dspinfo(2:3)]);
            end
        else
            if ~isempty(lines(tag).linef)
                set(uar(1),'String',[dspinfo(1) dspinfo(4) ['Modal prop.: ' lines(tag).lphase] ['Begin: ' lines(tag).ltbegin] ['End: ' lines(tag).ltend] dspinfo(2:3)]);
            else
                set(uar(1),'String',[dspinfo(1) dspinfo(4) ['Modal prop.: ' lines(tag).lphase] dspinfo(2:3)]);
            end
        end
    else
        set(uar(1),'String',[dspinfo(1) dspinfo(4) ['Isopleth: ' points(tag-1000).pphase1 ' ' points(tag-1000).pphase2] dspinfo(2:3)]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Actualize the static text boxes with the new data to be displaid

    if ((size(dspinfo,2)-4)/7)+1 > 2
        for l1=2:((size(dspinfo,2)-4)/7)+1
            set(uar(l1),'String',dspinfo((l1-2)*7+5:(l1-1)*7+4));
        end
        set(uar(7),'String',dspinfo((l1-1)*7+5:size(dspinfo,2)));
        if (size(dspinfo,2)-4)/7 ~= 7*l1
            set(uar(l1+1),'String',dspinfo((l1-1)*7+5:size(dspinfo,2)));
        end
        if l1+1<7
            set(uar(l1+2:7),'String','')
        end
    else
        l1=1;
        if (size(dspinfo,2)-4)/7 ~= 7*l1
            set(uar(l1+1),'String',dspinfo((l1-1)*7+5:size(dspinfo,2)));
        end
        if l1+1<7
            set(uar(l1+2:7),'String','')
        end
    end
elseif tag > 2000
    Tcrs=roundn(Tcrs,-1);
    Pcrs=roundn(Pcrs,-2);
    tagdsp=['Dogmin: ' num2str(tag-2000)];
    Tdsp=['T: ' num2str(Tcrs)];
    Pdsp=['P: ' num2str(Pcrs)];
    % First bloc
    dspinfo={tagdsp Tdsp Pdsp};
    dspass={'Assemblage:' cell2mat(dmptna)};
    % Static text blocs
    uar(1)=u81;
    uar(2)=u82;
    uar(3)=u83;
    uar(4)=u84;
    uar(5)=u85;
    uar(6)=u86;
    uar(7)=u87;
    % Add the target name of the calculation and begin and end if line cut
    set(uar(1),'String',dspinfo(1:3));
    set(uar(2),'String',dspass(1:2));
    set(uar(3:7),'String','');
end
% Update the data displaid on the figure
output_txt = {['T: ',num2str(Tcrs)],['P: ',num2str(Pcrs)]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%