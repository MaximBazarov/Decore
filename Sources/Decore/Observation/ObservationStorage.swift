//
//  ObservationStorage.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

extension Storage {

    class WeakObservation {
        weak var value: Observation?
        init(_ value: Observation) {
            self.value = value
        }
    }

    /// Each container might be observed by many observations,
    /// also we don't want to have a strong reference to the observations,
    /// to not capture their self
    /// Also it removes those ``Observation``s that are `nil`
    class ObservationStorage: Hashable {

        func insert(_ observation: Observation) {
            observationStorage[observation.id] = WeakObservation(observation)
        }

        func didChangeValue() {
            let (toDispose, toNotify) = splitDisposeFromNotify( )
            toNotify.forEach { id in
                guard let observation = observationStorage[id]?.value
                else { return }
                observation.willChangeValue()
            }
            toDispose.forEach { id in
                observationStorage.removeValue(forKey: id)
            }
        }

        func willChangeValue() {
            let (toDispose, toNotify) = splitDisposeFromNotify( )
            toNotify.forEach { id in
                guard let observation = observationStorage[id]?.value
                else { return }
                observation.willChangeValue()
            }
            toDispose.forEach { id in
                observationStorage.removeValue(forKey: id)
            }
        }

        /// Enumerates all the observation inserting them into two sets:
        /// - The observations to notify
        /// - The observation to remove from further notifications,
        /// because they were deallocated.
        /// - Returns: (toDispose, toNotify) each is of type Set of ``WeakObservation``
        func splitDisposeFromNotify() -> (Set<ObjectIdentifier>, Set<ObjectIdentifier>) {
            var toDispose = Set<ObjectIdentifier>()
            var toNotify = Set<ObjectIdentifier>()
            observationStorage.forEach { id, weakRef in
                if weakRef.value == nil {
                    toDispose.insert(id)
                    return
                }
                toNotify.insert(id)
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



        private(set) var observationStorage: [ObjectIdentifier: WeakObservation] = [:]

    }

}

