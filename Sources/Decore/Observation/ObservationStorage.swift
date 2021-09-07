/// Observation storage writes observation to have a `weak` reference.
/// Also it removes those ``Observation``s that are `nil`
class ObservationStorage: Hashable {

    func insert(_ observation: Observation) {
        storage.insert(Element(observation))
    }

    func ready() {
        storage.forEach { $0.observation?.ready() }
    }

    func invalidateIfNeeded() -> (Int,Int) {
        var invalidated = 0
        var toDispose = Set<Element>()
        storage.forEach { element in
            guard let observation = element.observation else {
                toDispose.insert(element)
                return
            }
            invalidated += 1
            observation.invalidateIfNeeded()
        }
        toDispose.forEach{
            print("!!~  ├─ removed observation \($0)")
            storage.remove($0)
        }
        return (invalidated, toDispose.count)
    }


    class Element: Hashable {
        weak var observation: Observation?
        init(_ observation: Observation) {
            self.observation = observation
        }
    }

    private var storage: Set<Element> = []

}

extension ObservationStorage.Element {
    static func == (lhs: ObservationStorage.Element, rhs: ObservationStorage.Element) -> Bool {
        lhs.observation == rhs.observation
    }

    func hash(into hasher: inout Hasher) {
        observation?.hash(into: &hasher)
    }
}

extension ObservationStorage {

    static func == (lhs: ObservationStorage, rhs: ObservationStorage) -> Bool {
        lhs.id == rhs.id
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

