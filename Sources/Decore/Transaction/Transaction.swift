//  
//  Transaction.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

import Foundation

class Transaction {
    var id: ObjectIdentifier { ObjectIdentifier(self) }

}


struct CurrentTransaction: Container {
    typealias Value = ObjectIdentifier?

    static func initialValue() -> Value { .none }
}
