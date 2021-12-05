# Decore

Decore allows you to declare the state of your app or framework, which is modular and atomic. The moto of the decore is "You declare, I'll take care" :)

It provides you with the way to:
  1. Declare state components, that describe what type of data you store and how to access it by providing you with containers e.g.
```swift
// Counter is the name this state counterpart is accessed with
struct Counter: Container {
    typealias Value = Int // State component stores an integer number

    static func initialValue() -> Int { 
        // when a read operation happens 
        // before any value vas written use this value
        return 0
    }
}
```
  2. Provides you with a declarative way to access data, without any unnecessary code nor dependency injection:
```swift
import SwiftUI
import Decore

struct CounterView: View {
    // Declare you want to access Counter declared above
    @Observe(Counter.self) var counter
  
    // will notify when value changed
    var body: some View {
        Text("\(counter)")
    }
}
```  
## >>> The following is to be implemented yet:
  3. Provides a way to test your app without additional dependency inversion, the only dependency you have is state counterparts like `Counter`. This includes all kinds of tests with an easy injection of side effects handlers etc.
  
  5. Provides a secure tracing, where you define how data is being traced using either secure or public channels separately.
  
  6. Decision-based state mutations, views, and other consumers of the state only fire `Decision` that they make, Decision handlers run side effects work, async operations, etc, and fire their decision back.
  
  7. Transactional decision handling: Every decision is handled in one single transaction. All writes are performed at the end of the transaction. That guarantees one single update regardless of the number of handlers.

  8. Syntax is minimized to only a necessary declaration, no boilerplate.



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
