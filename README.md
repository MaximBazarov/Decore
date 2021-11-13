# Decore

A package to enable modular data layer in your swift apps.

## Features

- TBD

## Planned Features 

### Modular State Modeling

- Provides you with a declarative way to model your modular state. 
- Provides a convenient way to declare states that are calculated from other states.

### State Observation

- Provides a way to observe any state counterpart and be notified about changes.

### Automatic Data Dependencies

- Recalculates the state when the states it is calculated from change.

### Structured State Mutation

- Instead of direct mutations, there's a separation between decision making and decision execution. So your components don't have to execute the decisions they made but send a Decision into the decision bus instead.
