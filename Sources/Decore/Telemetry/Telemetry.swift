//  
//  Telemetry.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

/// Multichannel event-bus to report events.
/// Each registered ``SecureTelemetryChannel`` get each ``SensitiveEvent`` and
/// ``SensitiveData`` with ``Context`` of the place in the code
/// where the source of the event occurred.
public enum Telemetry {

    /// Register a ``SecureTelemetryChannel`` to receive events.
    public static func add<C: SecureTelemetryChannel>(_ secureChannel: C) {
        fatalError()
    }

    /// Register a ``PublicTelemetryChannel`` to receive events.
    public static func add<C: PublicTelemetryChannel>(_ publicChannel: C) {
        fatalError()
    }

}


