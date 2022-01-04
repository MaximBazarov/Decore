//
//  Observation.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//



/// An object that is added to the storage when the value is read.
/// So every time the read value changes, this object's ``willChangeValue()``
/// and ``didChangeValue()-2jxs5`` get called.
public protocol StorageObservation: AnyObject {

    typealias ID = ObjectIdentifier

    /// Called before the observed value changes
    func willChangeValue()

    /// Called after the observed value changes
    func didChangeValue()
}


public extension StorageObservation {

    /// Default implementation doing nothing.
    func didChangeValue() {}
}

public extension StorageObservation {

    /// Unique identifier of the observation
    var id: ID { ObjectIdentifier(self) }
}
