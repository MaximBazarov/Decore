extension Storage {

    class WeakObservation: Hashable {
        weak var value: Observation?
        init(_ value: Observation) {
            self.value = value
        }

        static func == (lhs: WeakObservation, rhs: WeakObservation) -> Bool {
            lhs.value == rhs.value
        }

        func hash(into hasher: inout Hasher) {
            value?.hash(into: &hasher)
        }
    }

    /// Each container might be observed by many observations,
    /// also we don't want to have a strong reference to the observations,
    /// to not capture their self
    /// Also it removes those ``Observation``s that are `nil`
    class ObservationStorage: Hashable {

        func insert(_ observation: Observation) {
            storage.insert(WeakObservation(observation))
        }

        func didChangeValue() {
            let (toDispose, toNotify) = splitDisposeFromNotify( )
            toNotify.forEach { $0.value?.didChangeValue() }
            toDispose.forEach { storage.remove($0) }
        }

        func willChangeValue() {
            let (toDispose, toNotify) = splitDisposeFromNotify( )
            toNotify.forEach { $0.value?.willChangeValue() }
            toDispose.forEach { storage.remove($0) }
        }

        /// Enumerates all the observation inserting them into two sets:
        /// - The observations to notify
        /// - The observation to remove from further notifications,
        /// because they were deallocated.
        /// - Returns: (toDispose, toNotify) each is of type Set of ``WeakObservation``
        func splitDisposeFromNotify() -> (Set<WeakObservation>, Set<WeakObservation>) {
            var toDispose = Set<WeakObservation>()
            var toNotify = Set<WeakObservation>()
            storage.forEach { weakObservation in
                if weakObservation.value == nil {
                    toDispose.insert(weakObservation)
                    return
                }
                toNotify.insert(weakObservation)
            }
            return (toDispose, toNotify)
        }


        static func == (lhs: ObservationStorage, rhs: ObservationStorage) -> Bool {
            lhs.id == rhs.id
        }

        public var id: ObjectIdentifier {
            ObjectIdentifier(self)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }



        private var storage: Set<WeakObservation> = []

    }

}

