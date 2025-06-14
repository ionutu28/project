function snake_g()
    clc; clear; close all;
    global snake dir food score gameOver timerObj hScore hHigh hOver highScore;
    global paused;

    snake = [10 10];
    dir = [0 1];
    score = 0;
    gameOver = false;
    paused = false;

    if exist('highscore.mat', 'file')
    s = load('highscore.mat');
    if isfield(s, 'highScore')
        highScore = s.highScore;
    else
        highScore = 0;
    end
else
    highScore = 0;
end

    food = generateFood();

    fig = figure('Name','Snake game','Color','k', ...
        'KeyPressFcn',@keyControl, ...
        'MenuBar','none','NumberTitle','off', ...
        'Position',[200 200 500 550]);

    ax = axes('Parent', fig, ...
        'Position', [0.05 0.2 0.9 0.75]);
    axis([1 20 1 20]); axis square;
    set(ax, 'XTick',1:20, 'YTick',1:20, 'XColor','w', 'YColor','w');
    grid on; hold on;

    hScore = uicontrol('Style','text', ...
        'Position',[50 510 120 25], ...
        'String','Scor: 0', ...
        'FontSize',12, 'BackgroundColor','white');

    hHigh = uicontrol('Style','text', ...
        'Position',[180 510 120 25], ...
        'String',['High: ' num2str(highScore)], ...
        'FontSize',12, 'BackgroundColor','white');

    hOver = text(10, 10, '', ...
        'HorizontalAlignment','center', ...
        'FontSize', 16, 'Color','r', ...
        'Visible','off');

    uicontrol('Style','pushbutton', 'String','Restart', ...
        'FontSize',12, ...
        'Position',[330 510 100 30], ...
        'Callback',@restartGame);

    timerObj = timer('ExecutionMode','fixedRate', ...
                     'Period', 0.2, ...
                     'TimerFcn', @gameLoop);
    start(timerObj);
end

function keyControl(~, event)
    global dir paused;

    switch event.Key
        case 'uparrow',    if ~isequal(dir,[0 -1]), dir = [0 1]; end
        case 'downarrow',  if ~isequal(dir,[0 1]), dir = [0 -1]; end
        case 'leftarrow',  if ~isequal(dir,[1 0]), dir = [-1 0]; end
        case 'rightarrow', if ~isequal(dir,[-1 0]), dir = [1 0]; end
        case 'p' % PAUZĂ
            paused = ~paused;
    end
end

function gameLoop(~, ~)
    global snake dir food score gameOver timerObj hScore hHigh hOver highScore paused;

    if gameOver || paused
        return;
    end

    head = snake(end,:) + dir;

    if any(head < 1 | head > 20) || ismember(head, snake, 'rows')
        gameOver = true;
        stop(timerObj);
        if score > highScore
            highScore = score;
            save('highscore.mat','highScore');
            set(hHigh, 'String', ['High: ' num2str(highScore)]);
        end
        set(hOver, 'String', 'GAME OVER', 'Visible', 'on');
        return;
    end

    snake = [snake; head];

    if isequal(head, food)
        score = score + 1;
        food = generateFood();
        set(hScore, 'String', ['Scor: ' num2str(score)]);
    else
        snake(1,:) = [];
    end

    drawBoard();
end

function food = generateFood()
    global snake;
    while true
        food = randi([1 20],1,2);
        if ~ismember(food, snake, 'rows'), break; end
    end
end

function drawBoard()
    global snake food;
    cla;
    fill([0 21 21 0], [0 0 21 21], [0.1 0.5 0.1]);
    for i = 1:size(snake,1)-1
        rectangle('Position',[snake(i,1)-0.5, snake(i,2)-0.5, 1, 1], ...
                  'FaceColor','g','EdgeColor','k');
    end
    rectangle('Position',[snake(end,1)-0.5, snake(end,2)-0.5, 1, 1], ...
              'FaceColor',[0 0.8 0],'EdgeColor','k');
    rectangle('Position',[food(1)-0.5, food(2)-0.5, 1, 1], ...
              'FaceColor','r','EdgeColor','k');
end

function restartGame(~, ~)
    global snake dir food score gameOver timerObj hScore hOver;

    if isvalid(timerObj)
        stop(timerObj);
    end

    snake = [10 10];
    dir = [0 1];
    score = 0;
    food = generateFood();
    gameOver = false;

    if isgraphics(hScore)
        set(hScore, 'String', 'Scor: 0');
    end
    if isgraphics(hOver)
        set(hOver, 'Visible', 'off');
    end

    start(timerObj);
end


