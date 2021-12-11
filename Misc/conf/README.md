# SimpleConfig.json

This is a simplified version of the `SampleConfig.json` file. Place it in `server/conf` if you want to use it.

## Some notes

- It is configured to use only 1 team of 15 agents, so the game runs faster if all your agents have sent an action in each step.
- There is a `randomSeed`configured, so each game should look the same.
- The grid is rather small at 50x50 cells.
- Events are set to 0.
- randomFail is set to 0.
- There are a few obstacles. If you want to test without them at first, set the value of `instructions` to `[]` instead.