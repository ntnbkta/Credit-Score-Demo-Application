//
//  TestBundle.swift
//  Credit ScoreTests
//
//  Created by Nithin Bhaktha on 16/10/22.
//

import Foundation

enum TestResourceName: String {
    case valid
    case invalid
    case empty
}

extension Bundle {
    static var UnitTest = Bundle(for: NetworkClientTests.self)

    func getData(file: TestResourceName) -> Data? {
        guard let url = Self.UnitTest.url(forResource: file.rawValue, withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }

    func getString(file: TestResourceName) -> String? {
        guard let data = getData(file: file) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func getSerialized<T: Codable>(objectType: T.Type, for file: TestResourceName) -> T? {
        guard let data = getData(file: file) else { return nil }

        return try? JSONDecoder().decode(objectType, from: data)
    }
}
