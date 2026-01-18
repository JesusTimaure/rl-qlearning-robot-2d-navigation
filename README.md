# RL: Qlearning for navigation in a 2D grid environment
Implementation of Q-learning algorithm in MATLAB to train a robot to navigate autonomously a 2D grid environment from a start point (A) to a goal point (B)

## Problem Formulation
The robot operates in a 2D grid environment and must be trained to find a collision-free path from the starting point to the goal point.
[Map5.bmp](https://github.com/user-attachments/files/24696977/Map5.bmp)

## Results

The policy obtained by QLearning can be shown in this arrow map, determining the direction of movement depending on robot's current position:

![Learned policy (arrows)](https://github.com/user-attachments/assets/808e5385-7eb2-44ca-933c-e79735cd8af4)

Below we can see a video of the robot navigating the grid environment from the starting point to the goal point
https://github.com/user-attachments/assets/afbdaff8-c19a-48c9-872b-3180867c0753

It can also be analized how, as expected, the reward curve increases as the episodes continue, with the rewards decreasing every 5000 episodes since the code boosts ε-greedy exploration at these times to allow the robot to explore again.

after every 5000 episodes so the robot starts exploring again
<width="2159" height="145" alt="image" src="https://github.com/user-attachments/assets/24154bc3-c08e-4f38-b55b-3aa6f67b804b" />

<img width="1710" height="1297" alt="image" src="https://github.com/user-attachments/assets/ea78a10e-2bb3-4660-8e2b-17bcbb83bf18" />
