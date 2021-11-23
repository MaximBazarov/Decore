import SwiftUI
import Decore

struct Counter: GroupContainer {
    typealias Value = Int
    typealias ID = Int

    static func initialValue(for id: Int) -> Int { 0 }
}

struct CounterIndexList: Container {
    typealias Value = [Int]
    static func initialValue() -> [Int] { [] }
}

struct NewIndex: Computation {
    typealias Value = Int

    static func value(read: Storage.Reader) -> Int {
        let counterIndex = read(CounterIndexList.self)
        return counterIndex.count + 1
    }
}


struct CounterListView: View {

    @Bind(CounterIndexList.self) var counterIndexList
    @Observe(NewIndex.self) var newIndex

    var body: some View {

        VStack(alignment: .center, spacing: 32) {
            Spacer()
            ScrollView {
                ForEach(counterIndexList, id: \.self) { index in
                    CounterView(
                        counterIndex: index)
                }
            }
            HStack { Spacer() }
            FancyButton(title: "+") {
                counterIndexList.append(newIndex)
            }
            Text("Next Index: \(newIndex)").foregroundColor(.white)
            Spacer()
        }
        .ignoresSafeArea()
        .padding()
        .ignoresSafeArea()
        .background(LinearGradient(
            colors: green,
            startPoint: .bottom,
            endPoint: .top
        ))


        
    }
}

let purple80 = [
    Color("P80-1"),
    Color("P80-2")
]

let green = [
    Color("C1"),
    Color("C2"),
    Color("C3"),
]

let mauve = [
    Color("Mauve-1"),
    Color("Mauve-2"),
]

struct CounterListView_Previews: PreviewProvider {
    static var previews: some View {
        let s = Warehouse[.defaultStorage]
        s.update(value: [1,2,3], atKey: CounterIndexList.key())
        return CounterListView()
    }
}

final class TestViewHostingController: UIHostingController<CounterListView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(rootView: CounterListView())
    }
}


