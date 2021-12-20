//  
//  StatePreset.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//

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
public typealias StatePreset = (Storage.Writer) -> Void
