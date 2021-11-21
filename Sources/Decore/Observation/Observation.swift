public extension Storage {

    class Observation: Hashable {

        /// Unique identifier of the observation
        var id: ObjectIdentifier { ObjectIdentifier(self) }

        /// Flag to eliminate multiple notification when only one value changed
        private(set) var isValid: Bool = false


        // MARK: - Callbacks

        /// Called when a value is about to be written into the ``Storage``
        func willChangeValue() {
            guard isValid else { return }
            isValid = false
        }

        /// Called after value is written into the ``Storage``
        func didChangeValue() {
            isValid = true
        }


        // MARK: - Hashable -

        public func hash(into hasher: inout Hasher) {
            id.hash(into: &hasher)
        }

        public static func == (lhs: Observation, rhs: Observation) -> Bool {
            lhs.id == rhs.id
        }

    }
}
