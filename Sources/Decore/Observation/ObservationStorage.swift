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

        /// Returns all observations removing disposed ones.
        var observations: [ObjectIdentifier: StorageObservation] {
            var outdatedObservations = Set<ObjectIdentifier>()
            var validObservations = Set<ObjectIdentifier>()
            observationStorage.forEach { id, weakRef in
                if weakRef.value == nil {
                    outdatedObservations.insert(id)
                    return
                }
                validObservations.insert(id)
            }

            outdatedObservations.forEach({
                observationStorage.removeValue(forKey: $0)
            })

            return validObservations
                .reduce(into: [ObjectIdentifier: StorageObservation]()) { acc, id in
                    guard let observation = observationStorage[id]?.value else { return }
                    acc[id] = observation
                }
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

