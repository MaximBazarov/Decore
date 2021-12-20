//  
//  File.swift
//  View+Writer
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
private struct EmptyModifier: ViewModifier {

    @StorageFor(Self.self) var storage

    func body(content: Content) -> some View {
        return content
    }
}

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)

public extension View {

    /// Presets ``Storage`` for the given `SwiftUI.View`
    /// with values based on ``StatePreset``
    ///
    /// **Usage:**
    /// Create a preset
    /// ```
    /// enum StoryBook {
    ///
    ///     static let seven: StatePreset = { write in
    ///         write(7, into: Counter.self)
    ///     }
    ///
    /// }
    /// ```
    ///
    /// use this modifier to preset state
    /// ```
    /// struct CounterView_Previews: PreviewProvider {
    ///     static var previews: some View {
    ///         CounterView()
    ///             .presetState(StoryBook.seven)
    ///     }
    /// }
    /// ```
    ///
    func presetState(
        _ presetUsing: (Storage.Writer) -> Void,
        file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function
    ) -> some View
    {
        let wrapper = EmptyModifier()
        let context = Context(file: file, fileID: fileID, line: line, column: column, function: function)
        let writer = Storage.Writer(context: context, storage: wrapper.storage)
        presetUsing(writer)
        return modifier(wrapper)
    }
}

#endif
