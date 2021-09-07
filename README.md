# Decore
The state management library that built with modularisation in mind.

# How to use

There are two main features Decore gives you:
- State declaration
- Read/Write or both, access to the declared state.

To declare the state, you need to define its name and its structure using one of the [containers](#containers):
```swift
struct Count: Atom {
    typealias Value = Int
    static var initial = { 0 }
}
```
Where ```Count``` is the name of your state and `Value` is a structure of the data. If you want to build a tree-like state you can nest the state declaration into other `enum` or `struct` like with other types you want to namespace.

You also provide the `initial` value for cases when this state is read before it's written. Note that you provide it as a function that returns that value, it will be called only if reading happened before writing.

Now when you have your state declared, you can access it as read-only using `StateOf` accessor:
```swift
@StateOf(Count.self) var count
```
Use it like any other read-only variable e.g. `print(item)` or you can be notified about every change in the state:

```swift
@StateOf(Count.self, onChange: { read in
    let value = read()
    print(value)
}) var count;
```
## Mutable state
When you need to mutate the state you need to mark your state declaration as `Mutable` and use `BindingTo` instead of `StateTo` 
```swift
struct Count: Atom, Mutable {
    static var initial = { 0 }
}
```

Done. Use it like any other variable through `BindingTo`.
```swift
@BindingTo(Count.self) var item
```

or observing:

```swift
@BindingTo(Count.self, onChange: { read in
    let value = read()
    print(value)
}) var count;
```


P.S. I'm very sorry that you have to put `;` after a property wrapper declaration with closure, I'm thinking on solving it.

# Thread-safety not included.

Warning: Decore is synchronous storage, so when you access the values you need to make sure that this is happening from a single thread. I have ideas on how to make it automatic, but I didn't want to include it for now.

# Containers
