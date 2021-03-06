%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called when an object is clicked
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Input-
%obj:	Object that has been clicked on
%evt:   Which event triggered this callback (not sure)

function clickedCallback(obj,evt)
    
    %We need to seperate the second part of the function.
    %There must also be a change to let nothing happen even though the oibject was clicked.
    %It's more efficient then to redraw everything.
    continueAllowed = 0;
    
    %Get muehleFigure
    muehleFigure = findobj('Name','Muehle');
    
    %Phase 2 & 3 need two clicks, we need to wait for a second click
    muehleFigure.UserData.click = muehleFigure.UserData.click + 1;
    
    %Phase 1
    if muehleFigure.UserData.phase(1) == 1 && muehleFigure.UserData.mode == "move"
        muehleFigure.UserData.moveTo = obj.UserData(1); %UserData(1): is the object's linear index (of Luca's board)
        continueAllowed = 1;
    
    %Remove a opponent's stone
    elseif muehleFigure.UserData.mode == "remove"
        
        %Transfer index to muehleFigure
        muehleFigure.UserData.index = obj.UserData(1);
        muehleFigure.UserData.board(muehleFigure.UserData.index) = 0;
        uiresume(muehleFigure);
    
    %Phase 2 and 3
    elseif muehleFigure.UserData.phase(1) >= 2
        
        %First Click
        if muehleFigure.UserData.click == 1 && obj.UserData(2) == 1 %UserData(2): is the type of rectangle that has been clicked on
            muehleFigure.UserData.moveFrom = obj.UserData(1);
            continueAllowed = 1;
        
        %Second Click
        elseif muehleFigure.UserData.click == 2 && obj.UserData(2) == 0 %%UserData(2): The second time the player must click on a possible move
            %Delete old tag
            delete(findobj('Position',[matrixToPosition(muehleFigure.UserData.moveFrom, 1, "rectangle") matrixToPosition(muehleFigure.UserData.moveFrom, 2, "rectangle") 0.5 0.5],'Tag','clickable'));
            muehleFigure.UserData.board(muehleFigure.UserData.moveFrom) = 0;
            muehleFigure.UserData.moveTo = obj.UserData(1); 
            continueAllowed = 1;
        end
    end
    
    if continueAllowed == 1
        %Transfer index of clicked object to muehleFigure
        muehleFigure.UserData.index = obj.UserData(1);

        %Delete old stone
        delete(findobj('Position',[matrixToPosition(muehleFigure.UserData.index, 1, "rectangle") matrixToPosition(muehleFigure.UserData.index, 2, "rectangle") 0.5 0.5],'Tag','clickable'));

        %Set new, highlighted, stone
        rectangle('Position',[matrixToPosition(muehleFigure.UserData.index, 1, "rectangle") matrixToPosition(muehleFigure.UserData.index, 2, "rectangle") 0.5 0.5],'FaceColor',[0.5 0.25 1 1],'Clipping','off','UserData',muehleFigure.UserData.index);

        %Show possible moves in phases 2&3
        if muehleFigure.UserData.phase(1) == 2 || muehleFigure.UserData.phase(1) == 3

            displayText("Chose where to put it", [0 0 0], 0.07);
            
            possible = possibilities(muehleFigure, muehleFigure.UserData.index, "move", true);
            if isnan(possible(1))
                uiresume(muehleFigure);
            end
            
        end
        
        %Loosen 'uiwait' in GUI.m to continue with game
        if muehleFigure.UserData.phase(1) == 1 || (muehleFigure.UserData.phase(1) > 1 && muehleFigure.UserData.click == 2)
            uiresume(muehleFigure);
            muehleFigure.UserData.board(muehleFigure.UserData.index) = muehleFigure.UserData.playerType;
        end
    else
        muehleFigure.UserData.click = muehleFigure.UserData.click - 1;
    end
end
