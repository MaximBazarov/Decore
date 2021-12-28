//
//  KeyedContainer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//


/// Entity that has a unique key.
public protocol KeyedContainer {

    /// Unique key to identify this entity.
    static func key() -> Storage.Key
}

