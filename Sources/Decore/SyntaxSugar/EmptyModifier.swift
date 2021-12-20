//  
//  EmptyModifier.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
private struct EmptyModifier: ViewModifier {

    func body(content: Content) -> some View {
        return content
    }
}
#endif
