//  
//  SecureTelemetryChannel.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

/// A ``Telemetry`` channel to send sensitive data.
/// This channel must guarantee the protection of the data.
public protocol SecureTelemetryChannel {

    /// Post a ``Telemetry/SensitiveEvent`` with a ``SensitiveData`` payload.
    func postSensitive<T: SensitiveData>(
        event: Telemetry.SensitiveEvent,
        context: Context,
        payload: T)


    /// Post a ``Telemetry/SensitiveEvent`` without a payload.
    func postSensitive(event: Telemetry.SensitiveEvent, context: Context)
}
