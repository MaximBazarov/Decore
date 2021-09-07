/// Observation is a wrapper for the notification function.
/// It'll call the `onInvalidate` once, every time the value in storage has changed.
/// Observation is being added to each read operation,
/// so we observe only values we are interested in.
public final class Observation: Hashable {

    public var onInvalidate: () -> Void

    public let context: Context
    private var isValueValid: Bool

    public
    init(
        _ context: Context,
        isValueValid: Bool = true
    ) {
        self.isValueValid = isValueValid
        self.context = context
        self.onInvalidate = {}
    }

    public
    func invalidateIfNeeded() {
        guard isValueValid else { return }
        self.isValueValid = false
        onInvalidate()
    }

    public
    func ready() {
        self.isValueValid = true
    }
}

extension Observation  {

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }

    public static func == (lhs: Observation, rhs: Observation) -> Bool {
        lhs.id == rhs.id
    }

}

