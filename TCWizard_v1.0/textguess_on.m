function textguess_on(param,excess,lines,points,cursor,static)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% textguess_on(...)
% Add selected starting guesses to the project file
%
% Input:  - param = structure with initial parameters (see paramin)
%         - excess = cell array of excess phases specified in the project
%                    file
%         - lines = struture array with calculated lines
%         - cursor = handles to the datacursor
%         - static = handles to the static text box displaying the starting
%                    guesses used for calculation
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

% Structure with datacursor info
info_struct = getCursorInfo(cursor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building starting guess list
if ~isempty(info_struct)
    % P-T coordinates for guess
    Tguess=info_struct.Position(1);
    Pguess=info_struct.Position(2);
    % Get object Tag (Tag<1000=line Tag>1000=point)
    target = get(info_struct.Target);
    tag=str2num(target.Tag);
    %%%%%%%%%%%%%%%%%%%%%%%%
    if tag<1000 % If point of a line selected
        % Find point index
        index=find(lines(tag).lcrd(:,1)==Pguess);
        %%% Keep usefull field names
        guess_list=fieldnames(lines(tag));
        % Delete first fields
        guess_list(1:13)=[];
        % Delete 'mode' fields
        for i=1:length(guess_list)
            if strfind(char(guess_list(i)),'mode')
                del(i)=1;
            elseif isempty(lines(tag).(char(guess_list(i))))
                del(i)=1;
            else
                del(i)=0;
            end
        end
        guess_list(del==1)=[];
        % Export phases
        export=struct2cell(lines(tag).lal);
    elseif tag>1000 % If point selected
        % Point number
        pnum=tag-1000;
        % Find point index
        index=1;
        %%% Keep usefull field names
        guess_list=fieldnames(points(pnum));
        % Delete first fields
        guess_list(1:10)=[];
        % Delete 'mode' fields
        for i=1:length(guess_list)
            if strfind(char(guess_list(i)),'mode')
                del(i)=1;
            elseif isempty(points(pnum).(char(guess_list(i))))
                del(i)=1;
            else
                del(i)=0;
            end
        end
        guess_list(del==1)=[];
        % Export phases
        export=struct2cell(points(pnum).pal);
    end
    % Create field text
    fieldtext={};
    for j=1:length(guess_list)
        % Default assign
        fieldtext(j)={char(guess_list(j))};
        for k=1:length(export)
            if strfind ( char(guess_list(j)),char(export{k,1}) ) % If phase present
                % Add parentheses ( ex: xst -> x(st) )
                rep=['(' char(export{k,1}) ')'];
                fieldtext(j)={strrep(char(guess_list(j)),char(export{k,1}),rep)};
            end
        end
        for k2=1:length(excess)
            if strfind ( char(guess_list(j)),char(excess(k2)) ) % If phase present as excess
                % Add parentheses ( ex: xst -> x(st) )
                rep=['(' char(excess(k2)) ')'];
                fieldtext(j)={strrep(char(guess_list(j)),char(excess(k2)),rep)};
            end
        end
        %%%%
        % Correct liquid isopleths ( ex: anL -> an(L) )
        if ~isempty(strfind(char(fieldtext(j)),'L'))
            fieldtext(j)={strrep(char(fieldtext(j)),'L','(L)')};
        end
        % Correct (q)(L)...
        if ~isempty(strfind(char(fieldtext(j)),'(q)(L)')) % Correct q(L)
            fieldtext(j)={strrep(char(fieldtext(j)),'(q)(L)','q(L)')};
        end

    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Modify project file
    % Extract original text
    pf_nw=strrep(param.protext,'setiso yes','setiso yes$');
    [a,b]=strtok(pf_nw,'$');
    b=strrep(b,'$','');
    % Open file
    fid1 = fopen([param.pathin param.project],'w+');
    % Beginning of file
    fprintf(fid1,'%c',a);
    % Overwrite new text
    % P-T guess line
    fprintf(fid1,'\r\n\r\nptguess %s %s\r\n', num2str(Pguess), num2str(Tguess));
    header='% --------------------------------------------------------';
    fprintf(fid1,'%s\r\n',header);
    % Successive starting guesses
    for m=1:length(guess_list)
        if tag<1000 % If point of a line
            fprintf(fid1,'xyzguess %s     %s\r\n', char(fieldtext(m)), num2str(lines(tag).(char(guess_list(m)))(index)));
        elseif tag>1000 % If point
            fprintf(fid1,'xyzguess %s     %s\r\n', char(fieldtext(m)), num2str(points(pnum).(char(guess_list(m)))(index)));
        end
    end
    fprintf(fid1,'%s\r\n',header);
    % End of file
    fprintf(fid1,'%c',b);
    fclose(fid1);
    %%%%%%%%%%%%%%%%%%
    % Update static text box
    statict(1)={'Using P-T'};
    statict(2)={[num2str(round(Pguess)) ' - ' num2str(round(Tguess))]};
    if tag<1000
        statict(3)={['on line ' lines(tag).lnum]};
    elseif tag>1000
        statict(3)={['from point ' points(pnum).pnum]};
    end
    statictf=char(statict);
    set(static,'String',statictf);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else % If no data selected with cursor
    menu('No data selected','Ok');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%