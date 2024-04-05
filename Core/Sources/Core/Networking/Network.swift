import Foundation

protocol Networking {
    func send<T: Decodable>(request: URLRequest) async -> Result<T, NetworkError>
}

/// Basic network layer that takes care about sending request and processing response.
final class Network: Networking {

    private let session: URLSession

    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }

    func send<T: Decodable>(request: URLRequest) async -> Result<T, NetworkError> {
        guard let (data, response) = try? await session.data(for: request),
              let httpResponse = response as? HTTPURLResponse else {
            return .failure(.unknown)
        }

        guard httpResponse.statusCode == 200 else {
            return .failure(.badResponseCode(httpResponse.statusCode))
        }

        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(.decodingError)
        }

        return .success(decodedResponse)
    }
}
