# InFlightValue

Awaits already in-flight calls and their value.

A common application is when concurrent calls require authentication secrets which are expired and should only be
refreshed one at a time. This acts as a queue for the result if another thread of execution already started the network
request.

## Usage

For each call that should only be executed one at a time, create a new instace of `InFlightValueProvider`:

```swift
let value = InFlightValueProvider {
    [...]
    let (data, _) = try await URLSession.default.data(for: request)
    return data
}

let result1 = try await value.get()
// from another queue...
let result2 = try await value.get()
```

This ensures that subsequent calls to the value while the request is in-flight will return with the same result as the
original call. Once the value has been returned to all waiting threads, the provider will do its work once again.

## Installation

Using the Swift Package Manager, add this line to your `Package.swift` as a dependency:

```swift
    .package(url: "https://github.com/sgade/InFlightValue", from: "1.0.0"),
```
