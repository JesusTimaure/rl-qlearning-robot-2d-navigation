# RL: Qlearning for navigation in a 2D grid environment
This repository presents the implementation of a Q-learning algorithm in MATLAB to train a robot to navigate autonomously a 2D grid environment from a start point (A) to a goal point (B). Important to note the robot can only move in 4 directions

## Problem Formulation
The robot operates in a 2D grid environment and must be trained to find a policy that ensures a collision-free path from the starting point to the goal point through the use of Q-Learning
![Map5](https://github.com/user-attachments/assets/dedfd0ed-766d-4537-93bf-8c1b177249ac)

## Results

The policy obtained by QLearning can be shown in this arrow map, determining the direction of movement depending on robot's current position:

![Learned policy (arrows)](https://github.com/user-attachments/assets/808e5385-7eb2-44ca-933c-e79735cd8af4)

Below we can see a video of the robot navigating the grid environment from the starting point to the goal point
https://github.com/user-attachments/assets/afbdaff8-c19a-48c9-872b-3180867c0753

It can also be analized how, as expected, the reward curve increases as the episodes continue, with the rewards decreasing every 5000 episodes since the code boosts ε-greedy exploration at these times to allow the robot to explore again.

<width="2159" height="145" alt="image" src="https://github.com/user-attachments/assets/24154bc3-c08e-4f38-b55b-3aa6f67b804b" />

<img width="1710" height="1297" alt="image" src="https://github.com/user-attachments/assets/ea78a10e-2bb3-4660-8e2b-17bcbb83bf18" />
