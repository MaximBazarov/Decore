import SwiftUI
import Decore

struct Title: GroupContainer {
    typealias Element = String
    typealias ID = Int

    static func initialValue(for id: ID) -> Element {
        "A shiny new todo item! "
    }
}

struct IsComplete: GroupContainer {
    typealias Element = Bool
    typealias ID = Int

    static func initialValue(for id: ID) -> Element {
        false
    }
}

struct AllTodos: Container {
    typealias Value = [Int]

    static func initialValue() -> Value {
        []
    }
}

struct NewID: Computation {
    typealias Value = Int

    static func value(read: Storage.Reader) -> Value {
        // reading the value for AllTodos container
        let all = read(AllTodos.self)
        // finding the maximum index in the array
        let biggestIndex = all.reduce(into: 0) { acc, el in
            acc = max(acc, el)
        }
        // return next after the biggest index
        return biggestIndex + 1
    }
}



struct ContentView: View {

    @Observe(NewID.self) var newID
    @Bind(AllTodos.self) var allTodos
    @Bind(Title.self) var title
    @Bind(IsComplete.self) var isComplete

    var body: some View {
        VStack {
            Button("Add") {
                allTodos.append(newID)
            }
            List(allTodos, id: \.self) { id in
                HStack {
                    if isComplete[id] {
                        Text(title[id]).strikethrough()
                    } else {
                        TextField("Title", text: $title[id])
                    }

                    Spacer()
                    Button(isComplete[id] ? "Undone": "Done") {
                        isComplete[id].toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
//
//static var previews: some View {
//    PrepareStorage{
//        Set(AllTodos.self, [1,2,3])
//        Set(Title.self, at: 1, "Preview bla bla")
//        Set(Title.self, at: 2, "Preview bla bla 2")
//    }.show{
//        ContentView()
//    }
//
//}
