import SwiftUI
import Decore

struct Counter: Container {
    typealias Value = Int
    static func initialValue() -> Int {
        0
    }
}

struct CounterView: View {

    @Bind(Counter.self) var counter

    var body: some View {
        HStack {
            Button("-") { counter -= 1 }
            .buttonStyle(.borderedProminent)
            Spacer()
            Text("\(counter)")
            Spacer()
            Button("+") { counter += 1 }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        return CounterView()
    }
}

final class TestViewHostingController: UIHostingController<CounterView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(rootView: CounterView())
    }
}
