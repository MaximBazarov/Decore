import SwiftUI
import Decore

struct CounterView: View {
    var body: some View {
        VStack {
            Text("counter")
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
