# AT-Macros: `@Async`

## Introduction

AT-Macros provides a powerful Swift peer macro, **`@Async`**, designed to automatically generate modern `async/await` versions of functions that use traditional completion handlers. This macro simplifies modernizing your codebase by reducing boilerplate code and making it easier to adopt Swift's modern concurrency features. 🧑‍💻

Simply attach `@Async` to a function that takes a completion handler, and the macro will create a new `async` function with the same name and parameters, returning the value asynchronously.

### How it Works

The `@Async` macro inspects a function and generates a corresponding `async` counterpart. It supports two common types of completion handlers:

1.  **Failable operations:** `(Result<Value, Error>) -> Void`
2.  **Non-failable operations:** `(Value) -> Void`

**Before:**

```swift
func fetchData(for id: String, completion: @escaping (Result<Data, Error>) -> Void) {
    // ... network request logic
}

func fetchUsername(for id: String, completion: @escaping (String) -> Void) {
    // ... logic
}
```

**After Macro Expansion:**

```swift
@Async
func fetchData(for id: String, completion: @escaping (Result<Data, Error>) -> Void) {
    // ... network request logic
}

// The macro generates this:
func fetchData(for id: String) async throws -> Data {
    try await withCheckedThrowingContinuation { continuation in
        fetchData(for: id) { result in
            continuation.resume(with: result)
        }
    }
}

@Async
func fetchUsername(for id: String, completion: @escaping (String) -> Void) {
    // ... logic
}

// The macro generates this:
func fetchUsername(for id: String) async -> String {
    await withCheckedContinuation { continuation in
        fetchUsername(for: id) { value in
            continuation.resume(returning: value)
        }
    }
}
```

-----

## Getting Started

### Installation Process

You can add AT-Macros to your project using the Swift Package Manager.

**Using Xcode:**

1.  Go to **File** \> **Add Packages...**
2.  Paste the repository URL into the search bar: `https://github.com/your-username/AT-Macros.git`
3.  Select the `AT-Macros` package and add it to your desired target.

### API Reference

The primary API is the `@Async` macro.

**`@Async`**
A peer macro that generates an `async` version of a function.

**Requirements:**

  * Must be attached to a `func`.
  * The function's **last parameter** must be a closure (completion handler).
  * The completion handler must have one of two signatures:
      * A single argument of type `Result<Success, Failure>` where `Failure` conforms to `Error`.
      * A single argument of any type `T`.

If these conditions aren't met, the compiler will produce an error guiding you on how to fix the usage.

-----

## Contribute

Contributions are welcome\! If you have a feature request, bug report, or want to improve the code, please feel free to contribute.

Thank you for making AT-Macros better\! 🙌