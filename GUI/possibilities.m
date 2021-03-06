%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display possible moves & removes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Input-
%muehleFigure:      Current figure
%index:             Linear index of Luca's 3x3x3 board
%mode("move"):      Get all possible moves
%mode("remove"):    Get all possible removes
%visible:           Set if the possible moves/removes should be drawn or not

function possible = possibilities(muehleFigure, index, mode, visible)

    %Valid linear indices for Luca's 3x3x3 board
    A = [1 2 3 4 6 7 8 9 10 11 12 13 15 16 17 18 19 20 21 22 24 25 26 27];
    possible = [NaN];

    for i=A
        %Get all valid moves
        if mode == "move"
            if (isValidMove(muehleFigure.UserData.board, index, i, muehleFigure.UserData.playerType , muehleFigure.UserData.phase(1), muehleFigure.UserData.phase(2))) == 1
                possible(end+1) = i;
            end

        %Get all valid removes
        elseif mode == "remove"
            if (validRemove(muehleFigure.UserData.board,muehleFigure.UserData.playerType, i)) == 1
                possible(end+1) = i;
            end    
        end
    end

    %Draw all the valid moves and removes + Error handling if there is nothing available
    possible(1) = [];

    if ~isempty(possible)

        if visible == true

            for i=possible   
                if mode == "move"
                    color = [0 1 0 0.5]; %move
                else
                    color = [1 1 0 0.5]; %remove
                end
            
                %'UserData, i = index, 0: possible moves, -1: black, 1: white
                rectangle('Position',[matrixToPosition(i, 1, "rectangle") matrixToPosition(i, 2, "rectangle") 0.5 0.5],'FaceColor',color,'Clipping','off','UserData', [i 0],'Tag','clickable','ButtonDownFcn',@clickedCallback);   
            end
        end  
    else
        possible = NaN;
    end

end