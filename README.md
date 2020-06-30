# What is this repo?

This repo has an implementation of a test task for KRY. Text of the task can be found at [TASK.md](https://github.com/Auralien/Kry-Demo-App/blob/master/TASK.md).

## About implementation

It took me approximately 3-4 hours to finish the task. Even though I have spent that much time on the task, there is definitely a lot of room for improvement in the code. Some things that I would like to stress out regarding the task are presented below.

1. `PARTLY_SUNNY_RAIN` was replaced by `PARTLY_SUNNY`. I was not sure why enum in the app has different value the backend provides, but generally the backend usually is a source of truth, so I considered that to be an error in the app's implementation. Given more time I could, likely, cook something smarter.
2. Networking logic extracted into `APIManager`.
3. `Add location` feature generates and adds a location based on a number of random values for places, statuses and temperature. Since it was not specified in the task how data entry should look like in this case I opted for the simplest solution.
4. I've added `Pull to refresh` function that was not in the task but looks logical for this screen.
5. Networking code can be definitely written in a more compact way, especially error handling.