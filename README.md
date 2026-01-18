# RL: Qlearning for navigation in a 2D grid environment
This repository presents the implementation of a Q-learning algorithm in MATLAB to train a robot to navigate autonomously a 2D grid environment from a start point (A) to a goal point (B). Important to note the robot operates with a discrete action space of four movements: up, down, left, right

## Environment
Formed by:
- Discrete 2D grid world
- States: robot position (x, y)
- Actions: {Up, Down, Left, Right}
- Rewards:
 - +200 for reaching the goal
 - -0.5 per step
 - -100 for hitting obstacles

<p align="center">
![Map5](https://github.com/user-attachments/assets/dedfd0ed-766d-4537-93bf-8c1b177249ac)
</p>

## Algorithm
- **Method**: Q-Learning
- **Update rule**: $Q(s_t, a_t) = r_{t+1} + \gamma \max_{a'} Q(s_{t+1}, a')$
- **Exploration stratergy**: ε-greedy. For the agent this means its actions are:
 - Random with probability ε
 - The result of maximizing the Q function $\gamma \max_{a} Q(s, a)$ with probability 1-ε
- **Learning rate**: α = 0.3
- **Discount factor**: γ = 0.95
- **Number of steps per episode** = 1000

## Results
After training for 20000 episodes, the learned policy converges to an efficient path from A to B.
Here we have the optimal policy map
![Learned policy (arrows)](https://github.com/user-attachments/assets/808e5385-7eb2-44ca-933c-e79735cd8af4)

Finally there's the robot trajectory from start to goal

https://github.com/user-attachments/assets/afbdaff8-c19a-48c9-872b-3180867c0753

It can also be analized how, as expected, the reward curve increases as the episodes continue, with the rewards decreasing every 5000 episodes since the code boosts ε-greedy exploration at these times to allow the robot to explore again.

<img width="1710" height="1297" alt="image" src="https://github.com/user-attachments/assets/ea78a10e-2bb3-4660-8e2b-17bcbb83bf18" />
