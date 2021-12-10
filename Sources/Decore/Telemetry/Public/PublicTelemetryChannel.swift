//  
//  PublicChannel.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


/// A ``Telemetry`` channel to send data that might be exposed publicly.
public protocol PublicTelemetryChannel {

    /// Post a ``Telemetry/PublicEvent`` with a ``PublicData`` payload.
    func postPublic<T: PublicData>(
        event: Telemetry.PublicEvent,
        context: Context,
        payload: T)

    /// Post a ``Telemetry/PublicEvent`` without a payload.
    func postPublic(event: Telemetry.PublicEvent, context: Context)
}
