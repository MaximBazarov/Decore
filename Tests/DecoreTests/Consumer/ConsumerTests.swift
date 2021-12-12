//  
//  ConsumerTests.swift
//  
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


import XCTest
@testable import Decore

final class ConsumerTests: XCTestCase {

    struct A: Container {
        typealias Value = Int
        static func initialValue() -> Value { 1 }
    }

    class ConsumerObserveTest: Consumer {
        @Observe(A.self) var a

        var updateSequence: [A.Value] = []

        override func onUpdate() {
            updateSequence.append(a)
        }
        
        func run() { _ = a }
    }

    func test_performance_Consumer_autoSubscription() {
        measure {
            let _ = ConsumerObserveTest()
        }
    }

func test_Consumer_Observe_shouldGetOnUpdateAndBeAbleToReadValue() throws {
    @Bind(A.self) var a
    let sut = ConsumerObserveTest()
    sut.run()
    a = 2
    XCTAssertEqual(sut.updateSequence, [2])
}

}
