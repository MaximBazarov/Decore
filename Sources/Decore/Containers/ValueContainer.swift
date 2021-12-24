//
//  ValueContainer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

/// Value Atom is a wrapper for the ``Value``.
/// It allows to create your own types for any ``Value`` type.
/// Is a parent protocol for other type of containers
/// e.g. ``Atom`` and ``ContainerGroup``.
/// ``Storage`` can't read nor write values of `ValueContainer`.
public protocol ValueContainer {
    /// Type of the value stored in this container.
    associatedtype Value
}
