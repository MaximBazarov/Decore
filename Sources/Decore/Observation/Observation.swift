class Observation: Hashable {

    private(set) var isValid: Bool = false

    func willChangeValue() {
        guard isValid else { return }
        isValid = false
    }

    func didChangeValue() {
        isValid = true
    }

}

extension Observation {

    var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }

    static func == (lhs: Observation, rhs: Observation) -> Bool {
        lhs.id == rhs.id
    }

}
