import Foundation

public enum NetworkError: Error, Equatable {
    case badResponseCode(Int)
    case decodingError
    case unknown
}
