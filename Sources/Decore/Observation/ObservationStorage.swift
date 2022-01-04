//
//  ObservationStorage.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

extension Storage {

    class WeakObservation {
        weak var value: StorageObservation?
        init(_ value: StorageObservation) {
            self.value = value
        }
    }

    /// Each container might be observed by many observations,
    /// also we don't want to have a strong reference to the observations,
    /// to not capture their self
    /// Also it removes those ``Observation``s that are `nil`
    class ObservationStorage: Hashable {

        func insert(_ observation: StorageObservation) {
            observationStorage[observation.id] = WeakObservation(observation)
        }

        func didChangeValue() {
            let (toDispose, toNotify) = observations( )
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
            let (toDispose, toNotify) = observations( )
            toNotify.forEach { id in
                guard let observation = observationStorage[id]?.value
                else { return }
                observation.willChangeValue()
            }
            toDispose.forEach { id in
                observationStorage.removeValue(forKey: id)
            }
        }


        typealias Observations = (
            valid: Set<ObjectIdentifier>,
            invalid: Set<ObjectIdentifier>
        )
        /// Enumerates all the observation inserting them into two sets:
        /// - The observations to notify
        /// - The observation to remove from further notifications,
        /// because they were deallocated.
        /// - Returns: (toDispose, toNotify) each is of type Set of ``WeakObservation``
        var observations: Observations {
            var invalid = Set<ObjectIdentifier>()
            var valid = Set<ObjectIdentifier>()
            observationStorage.forEach { id, weakRef in
                if weakRef.value == nil {
                    invalid.insert(id)
                    return
                }
                valid.insert(id)
            }
            return (valid: valid, invalid: invalid)
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

