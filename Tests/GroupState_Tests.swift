////
////  GroupState_BindTests.swift
////  Decore
////
////  Copyright © 2020 Maxim Bazarov
////
//
//import XCTest
//import Decore
//import SwiftUI
//
//@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
//final class GroupState_BindTests: XCTestCase {
//
//    struct RemoteImageStatus: GroupState {
//        typealias ID = URL
//
//        enum Value {
//            case requested
//            case inProgress
//            case success(Data)
//            case failure(Error)
//        }
//
//        static func initialValue(for id: URL) -> Value {
//            .requested
//        }
//    }
//
//
//    struct RemoteImage {
//        let provider: RemoteImageProvider
//        let url: URL
//        @BindGroup(RemoteImageStatus.self) var remoteImages
//
//        init(_ url: URL) {
//            self.url = url
//            provider = RemoteImageProvider(for: url)
//        }
//
//        var image: Data? {
//            switch remoteImages[url] {
//                case .success(let data):
//                    return data
//                case .requested, .inProgress, .failure(_):
//                    return nil
//            }
//        }
//    }
//
//    actor RemoteImageProvider: GroupOperator<Int,Int> {
//
//        typealias ID = URL
//        @BindGroup(RemoteImageStatus.self) var remoteImages
//        var updatesCount: Int
//
//        func perform(for id: ID) {
//            let status = remoteImages[id]
//            switch status {
//                case .requested:
//                    nextStatus(for: id)
//                default:
//                    break
//            }
//        }
//
//        required internal init(for id: ID) {
//            self.updatesCount = 0
//        }
//
//        func nextStatus(for id: ID) {
//            remoteImages[id] = .success(Data())
//        }
//    }
//
//    // MARK: - Read -
//
//    func test_Bind_GroupState_read_InitialValue_shouldReturnInitialValue() throws {
//        let sut = RemoteImage(URL(string: "http://google.com/logo.png")!)
//        XCTAssertNotNil(sut.image)
//
//    }
//
//}
