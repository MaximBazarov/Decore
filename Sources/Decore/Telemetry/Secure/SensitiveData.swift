//  
//  File.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


/// Data that can only be sent through the ``SecureTelemetryChannel``
public protocol SensitiveData {

    /// Sensitive data key for key-value encoding.
    /// Used only by ``SecureTelemetryChannel``.
    var sensitiveName: StaticString { get }

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    func encodeSensitiveData(to encoder: Encoder) throws
}


