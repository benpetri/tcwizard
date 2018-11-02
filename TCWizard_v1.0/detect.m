function detect(popup,edit,lines)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% [...]=detect(...)
% Detect location of user's selected isopeth value on the available lines
%
% Input: - popup = handles to the popupmenu containing the selected isopleth
%        - edit = handles to the edit text box with the selected isopleth value
%        - lines = structure with calculated lines
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

% Get values from the figure
isoplet=get(popup,'Value');
fields=fieldnames(lines);
isoplet=char(fields(isoplet+13));
value_ini=get(edit,'String');
value=str2num(value_ini);
% Definition of variables
Piso=[];
Tiso=[];
t=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detection of isopleth trend
if strcmp(num2str(value_ini),'Value') % If no value entered
    menu('No isopleth value','Ok');
else % If value entered
    % Number of lines
    [sl1,sl2]=size(lines);
    for k1=1:sl2 % For each line
        if ~isempty(lines(k1).(isoplet)) && ~isempty(lines(k1).linef)
            % Number of coordinates
            [si1,si2]=size(lines(k1).(isoplet));
            if lines(k1).(isoplet)(1) < lines(k1).(isoplet)(si1) % If increasing isopleth values
                ind1=max(find(lines(k1).(isoplet)<value));
                ind2=min(find(lines(k1).(isoplet)>value));
            else % If decreasing isopleth values
                ind1=min(find(lines(k1).(isoplet)<value));
                ind2=max(find(lines(k1).(isoplet)>value));
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Interpolation around the isopleth value
            if ~isempty(ind1) && ~isempty(ind2) && ind1~=si1 && ind2~=si1
                % Sort indexes
                ind=[ind1; ind2];
                ind=sort(ind);
                if ind(1)-2>0 && ind(2)+2<length(lines(k1).(isoplet)) % If possible to interpolate with 2 additional points on each side
                    coeff=spline(lines(k1).lcrd(ind(1)-2:ind(2)+2,1),lines(k1).lcrd(ind(1)-2:ind(2)+2,2));
                    newP=linspace(lines(k1).lcrd(ind(1)-2,1),lines(k1).lcrd(ind(2)+2,1),50);
                    newT=ppval(coeff,newP);
                else % If not, interpolation between 2 points !
                    coeff=spline(lines(k1).lcrd(ind(1):ind(2),1),lines(k1).lcrd(ind(1):ind(2),2));
                    newP=linspace(lines(k1).lcrd(ind(1),1),lines(k1).lcrd(ind(2),1),25);
                    newT=ppval(coeff,newP);
                end
                % If found and if on final line (cut), store P-T interpolation
                if min(lines(k1).linef(:,2))<newT(length(newT/2)) &&  newT(length(newT/2))<max(lines(k1).linef(:,2))
                    % Il faudrait pondérer suivant l'écart entre ind(1) et
                    % value et ind(2) et value
                    Piso(t)=newP(round(length(newP)/2));
                    Tiso(t)=newT(round(length(newT)/2));
                    t=t+1;
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sort according to increasing temperature
    path=[Tiso; Piso];
    path=sortrows(path');
    plot(path(:,1),path(:,2),'Marker', 'pentagram','MarkerEdgeColor','black','MarkerFaceColor','black','MarkerSize',10,'LineStyle',':','Color','black');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%