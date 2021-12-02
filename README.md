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

### Tracing
- A convenient way to log everything that happens with states, decisions, failures, non-fatal errors, etc.
Clear separation on Private and Public channels. Protects sensitive data from logging in to public channels e.g. console (print) while giving a full context in Secure channels.

### Persistance

- A convenient way to store the states on a disc or cloud storage or a database.
- Every modular state defines away and persistent storage within the state declaration. That means it's possible to store some states in one storage some in another and some don't store at all.