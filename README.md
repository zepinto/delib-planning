# Introduction

In classical planning, autonomous systems \(robots\) interact with the world first by understanding it's state \(sensing\), then by planning the actions required to change it in order to achieve a desired objective \(planning\) and then by executing those actions and verifying that the resulting state matches the desired state \(acting\). Thus, automated planning typically consists in one or more sequences of sense-plan-act which will drive the state of the world towards the desired state.

In the real-world, however, there is not a single goal that the robot is trying to achieve but a set of parallel objectives that it is trying to verify at all times together with a varying set of goals that can be simplified onto sub-goals that can be achieved in the near term. For instance, consider the objective of "watching the latest Star Wars movie". To fulfil this objective a person must:

1. Look up theater show times and select a nearby theater and time.
2. Buy tickets.
3. Travel to the theater making sure to depart early enough to arrive on time.
4. Talk to no one making sure that spoilers are avoided at all times.
5. Take the best available seat location.
6. Watch the movie.

The previous set of sub-goals have very different timelines, for instance the 2. and 3. goals can be done simultaneously if the person is taking public transportation. Moreover, goal 4. is to be verified throughout the entire time. A simple sense-plan-act loop to derive the entire plan would not be feasible as the available seats are not known apriori nor the interactions that take place during the day. T-REX looks at planning and plan execution in this more adaptive way. Different world abstractions are expressed in different timelines, each with its own plan, executing in parallel with other plans.

The concept of timeline is very powerful because it both allows separation of concerns but also inter-timeline dependency. For instance, one can only watch a movie AFTER buying the tickets but one can buy the tickets CONCURRENTLY \(during\) with travelling to the theater. 

Both T-REX and Europa exploit this concept of timelines for hierarchical plan decomposition (a task results in several subtasks generated in a different timeline) and separation of concerns. Europa also allows modelling the real-world via timelines, intervals on those timelines (temporal tokens) and relationships between them.

To know more about timelines, T-REX and EUROPA, have a look in [this paper](https://link.springer.com/chapter/10.1007/978-1-4614-5659-9_3).

# Compiling everything

To help with compilation, this project includes an helping script with several functions that can help you compile all software needed to run a simple T-REX model (for AUVs). To compile everything use the following:

```bash
git clone https://github.com/zepinto/europa-tools
cd europa_tools
source trex_utils.bash
build_all
```

After the previous you will have the *europa_tools* folder with **neptus**, **dune**, **trex** and **europa** subfolders. To start T-REX, use the command ```start_trex```. To start DUNE, use the command ```start_dune``` and, to start Neptus, use ```start_neptus```.

