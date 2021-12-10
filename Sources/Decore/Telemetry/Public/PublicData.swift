//  
//  PublicData.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

/// Data that can be sent through the ``PublicTelemetryChannel``
/// as well as ``SecureTelemetryChannel``.
public protocol PublicData {

    /// Public data key for key-value encoding.
    /// Used only by ``PublicTelemetryChannel``.
    var publicName: StaticString { get }

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    func encodePublicData(to encoder: Encoder) throws
}


