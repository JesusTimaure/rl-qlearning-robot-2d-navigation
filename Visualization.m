%This code is run in order to visualize the agent implement the saved
%policy saved as back up

clc; clear; close all;

% Load the backup data
load('policy_backup.mat', 'Q', 'startPos', 'goalPos');

% Rename for convenience
Q_vis = Q;
sPos = startPos;
gPos = goalPos;


% Load the same map used during training
img = imread('Map5.bmp');
grayImg = im2gray(img);                     % Convert to grayscale if RGB
binaryMap = imbinarize(grayImg);            % White = 1 (free), Black = 0 (obstacle)
gridMap = ~binaryMap;                    % Flip: 1 = obstacle, 0 = free
gridMap = logical(gridMap);
[rows, cols] = size(gridMap);

% Define actions (same order used during training)
actions = [0 -1; 0 1; -1 0; 1 0];
numActions = size(actions, 1);
maxSteps = 1000;

% Prepare video writer
videoFile = 'policy_execution.mp4';
v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = 10;
open(v);

% Plot environment
figure;
imagesc(~gridMap);
colormap('gray');
axis equal tight;
hold on;

% Start and goal markers
plot(sPos(2), sPos(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(gPos(2), gPos(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);

% Blue dot (agent)
hRobot = plot(sPos(2), sPos(1), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
title('Executing Learned Policy');
drawnow;

% Record first frame
writeVideo(v, getframe(gcf));

% Start policy following
state = sPos;
for t = 1:maxSteps
    sRow = state(1); sCol = state(2);
    [~, a] = max(Q_vis(sRow, sCol, :));
    newState = state + actions(a, :);
    nsRow = newState(1); nsCol = newState(2);

    % Stop if next state is invalid or obstacle
    if nsRow < 1 || nsRow > rows || nsCol < 1 || nsCol > cols || gridMap(nsRow, nsCol) == 1
        disp('Hit wall or boundary. Stopping.');
        break;
    end

    % Trail dot
    plot(nsCol, nsRow, 'b.', 'MarkerSize', 10);

    % Move robot
    set(hRobot, 'XData', nsCol, 'YData', nsRow);
    drawnow;
    writeVideo(v, getframe(gcf));

    state = newState;

    % Check for goal
    if isequal(state, gPos)
        disp('Goal reached!');
        break;
    end

    pause(0.05);  % Optional for visual pacing
end

% Finish video
close(v);
disp(['Video saved to ', videoFile]);
