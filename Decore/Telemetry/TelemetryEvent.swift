//  
//  TelemetryEvent.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

/// A data structure that holds the name of the event
/// to be used as an event unique key.
protocol TelemetryEvent {
    var name: String { get }
}

extension Telemetry {

    public struct PublicEvent: TelemetryEvent {
        var name: String
    }

    /// Event to send over the ``SecureTelemetryChannel`` only.
    ///
    /// Use this event type when you don't want this event to exposed publicly.
    public struct SensitiveEvent: TelemetryEvent {
        public init(_ name: String) {
            self.name = name
        }

        var name: String
    }

    public struct DecoreEvent: TelemetryEvent {
        var name: String
    }

}
