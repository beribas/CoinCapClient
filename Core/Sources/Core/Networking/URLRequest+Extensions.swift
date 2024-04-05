import Foundation

extension URLRequest {
    /// Creates `URLRequest` from given `RequestDefinition`.
    /// Can cause a `fatalError` in case the data provided by `RequestDefinition` is invalid.
    /// - Parameter requestDefinition: Request definition providing necessary components.
    init(requestDefinition: RequestDefinition) {
        guard var urlComponents = URLComponents(string: requestDefinition.baseURL) else {
            fatalError("Error building URL from base URL!")
        }

        urlComponents.path = requestDefinition.path

        switch requestDefinition.method {
        case .get:
            if let queryParameters = requestDefinition.queryParameters {
                urlComponents.queryItems = queryParameters.map { .init(name: $0.key, value: $0.value) }
            }
        }

        guard let url = urlComponents.url else {
            fatalError("Error building URL from url components!")
        }
        self.init(url: url)
        httpMethod = requestDefinition.method.rawValue
        for header in requestDefinition.headers {
            addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
