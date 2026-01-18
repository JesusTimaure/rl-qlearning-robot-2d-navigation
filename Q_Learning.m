clc; clear;

%% Step 1: Load and Convert Image to Grid Map
img = imread('Map5.bmp');
grayImg = im2gray(img);                     % Convert to grayscale if RGB
binaryMap = imbinarize(grayImg);            % White = 1 (free), Black = 0 (obstacle)
gridMap = ~binaryMap;                    % Flip: 1 = obstacle, 0 = free
gridMap = logical(gridMap);
[rows, cols] = size(gridMap);

%% Step 2: Define Environment
startPos = [1, 1];
goalPos = [rows-10, cols-10];
actions = [0 -1; 0 1; -1 0; 1 0];         % Left, Right, Up, Down
numActions = size(actions, 1);

% Hyperparameters
alpha = 0.3;          % Learning rate
gamma = 0.95;         % Discount factor
epsilon = 1.0;        % Exploration rate
eps_decay = 0.999;    % Decay rate
min_epsilon = 0.01;
maxEpisodes = 20000;
maxSteps = 1000;

% Check goal validity
if gridMap(goalPos(1), goalPos(2)) == 1
    error("Goal position isn't valid. Please choose a valid goal");
end

% Initialize Q-table, in case of beggining algorithm from scratch, detele
% the file Qtable_autosave.mat in directory
if isfile('Qtable_autosave.mat')
    load('Qtable_autosave.mat', 'Q', 'episode', 'rewards_per_episode');
    startEp = episode +1;
    fprintf('Loaded saved Q-table from episode %d.\n', episode);
else
    Q = zeros(rows, cols, numActions);
    rewards_per_episode = zeros(maxEpisodes, 1);
    startEp = 1;
end

%% Step 3: Training
for ep = startEp:maxEpisodes
    state = startPos;
    totalReward = 0;
    
    for step = 1:maxSteps
        r = rand;
        sRow = state(1); sCol = state(2);
        
        % Choose action
        if r < epsilon
            a = randi(numActions);  % Explore
        else
            [~, a] = max(Q(sRow, sCol, :));  % Exploit
        end

        % Take action
        newState = state + actions(a, :);
        nsRow = newState(1); nsCol = newState(2);
        
        % Check bounds and obstacle
        if nsRow < 1 || nsRow > rows || nsCol < 1 || nsCol > cols || gridMap(nsRow, nsCol) == 1
            reward = -100;
            Q(sRow, sCol, a) = Q(sRow, sCol, a) + alpha * (reward - Q(sRow, sCol, a));
            totalReward = totalReward + reward;
            continue;  % Invalid move ends episode
        elseif isequal(newState, goalPos)
            reward = 200;
            Q(sRow, sCol, a) = Q(sRow, sCol, a) + alpha * (reward - Q(sRow, sCol, a));
            totalReward = totalReward + reward;
            break;
        else
            reward = -0.5;  % Cost per step
            % Q-learning update
            Q(sRow, sCol, a) = Q(sRow, sCol, a) + ...
                alpha * (reward + gamma * max(Q(nsRow, nsCol, :)) - Q(sRow, sCol, a));
            totalReward = totalReward + reward;
        end
        state = newState;
    end
    
    % Track reward
    rewards_per_episode(ep) = totalReward;
    
    % Decay exploration rate
    epsilon = max(min_epsilon, epsilon * eps_decay);
    
    % Boost in exploration
    if mod(ep, 5000) == 0
        epsilon = max(epsilon, 0.3);
    end

    episode = ep;

    % Auto-save Q-table and rewards every 200 episodes
    if mod(ep, 100) == 0
        fprintf('Episode %d complete. Total Reward = %.2f, Epsilon = %.4f\n', episode, totalReward, epsilon);
        save('Qtable_autosave.mat', 'Q', 'episode', 'rewards_per_episode');
    end
end


save('Qtable_final.mat', 'Q', 'rewards_per_episode');  % Final Q-table
disp('Training Complete!');
fprintf('Final Q-table saved as Qtable_final.mat\n');

% Plot reward curve
figure;
plot(1:maxEpisodes, rewards_per_episode, 'b');
xlabel('Episode');
ylabel('Total reward');
title('Q-Learning Reward Curve')
grid on;

%% Step 4: Visualize Policy
figure;
imagesc(~gridMap); 
colormap(gray);
axis equal tight;
title('Learned Policy (Arrows)');
hold on;
for r = 1:rows
    for c = 1:cols
        if gridMap(r,c) == 0
            [~, bestA] = max(Q(r,c,:));
            dir = actions(bestA, :);
            quiver(c, r, dir(2)*0.4, dir(1)*-0.4, 'r', 'LineWidth', 1.2, 'MaxHeadSize', 2);
        end
    end
end
plot(startPos(2), startPos(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(goalPos(2), goalPos(1), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

%% Step 5: Animate the Agent Following the Policy (Video Version)
videoFile = 'trajectory.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 10;  % Adjust as needed (frames per second)
open(v);

figure;
imagesc(~gridMap);
colormap('gray');
axis equal tight;
hold on;

% Plot start and goal
plot(startPos(2), startPos(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(goalPos(2), goalPos(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);

% Initialize robot plot handle
hRobot = plot(startPos(2), startPos(1), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
title('Agent Trajectory');

drawnow;
frame = getframe(gcf);
writeVideo(v, frame);

state = startPos;

for t = 1:maxSteps
    sRow = state(1); sCol = state(2);
    [~, a] = max(Q(sRow, sCol, :));
    newState = state + actions(a, :);
    nsRow = newState(1); nsCol = newState(2);

    if nsRow < 1 || nsRow > rows || nsCol < 1 || nsCol > cols || gridMap(nsRow, nsCol) == 1
        break;
    end

    set(hRobot, 'XData', nsCol, 'YData', nsRow);
    drawnow;

    % Capture and write frame to video
    frame = getframe(gcf);
    writeVideo(v, frame);

    state = newState;

    if isequal(state, goalPos)
        disp('Goal reached');
        break;
    end

    pause(0.05);  % Optional: keep for visual pacing during preview
end

close(v);  % Finalize video file
disp(['Video saved to ', videoFile]);