//
//  InFlightValueProvider.swift
//  InFlightValue
//
//  Created by Sören Gade on 29.11.21.
//  Copyright © 2021 Sören Gade. All rights reserved.
//

/// Provides access to in-flight calls to values of a producer.
public actor InFlightValueProvider<Value> {

    /// Provides a `Value` or throws an `Error`.
    public typealias ValueProducer = () async throws -> Value

    private var producer: ValueProducer
    /// A possible in-flight call. `nil` if not awaiting any calls currently.
    private var activeTask: Task<Value, Error>?

    public init(_ producer: @escaping ValueProducer) {
        self.producer = producer
    }

    /**
     Returns the `Value` of the producer, or its `Error`.

     - If no operation is currently active, this will call the producer to aquire a value to return.
     - If there currently is an active operation, this will await that operation and returns its result.

     - Returns: The producer's `Value` or `Error`.
     */
    public func get() async throws -> Value {
        if let activeTask = activeTask {
            return try await activeTask.value
        }

        let newTask = Task<Value, Error> {
            return try await producer()
        }

        defer { activeTask = nil }
        activeTask = newTask

        return try await newTask.value
    }

}
