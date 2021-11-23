import SwiftUI
import Decore

struct Title: GroupContainer {
    typealias Element = String
    typealias ID = Int

    static func initialValue(for id: ID) -> Element {
        "A shiny new todo item!"
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
