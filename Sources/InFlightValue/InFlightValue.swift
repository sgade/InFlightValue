//
//  InFlightValue.swift
//  InFlightValue
//
//  Created by Sören Gade on 29.11.21.
//  Copyright © 2021 Sören Gade. All rights reserved.
//

public actor InFlightValueProvider<Value> {

    public typealias ValueProducer = () async throws -> Value

    private var producer: ValueProducer
    private var activeTask: Task<Value, Error>?

    public init(_ producer: @escaping ValueProducer) {
        self.producer = producer
    }

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
