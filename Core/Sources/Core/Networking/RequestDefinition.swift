import Foundation

struct RequestDefinition {
    enum HTTPMethod: String {
        case get = "GET"
        // can be extended with further methods like post, put...
    }

    let method: HTTPMethod
    let baseURL: String
    let path: String
    let headers: [String: String]
    let queryParameters: [String: String]?
}

extension RequestDefinition {
    static var defaultHeaders: [String: String] {
        ["Accept-Encoding": "gzip"]
    }
}

extension RequestDefinition {
    static var assets: Self {
        .init(
            method: .get,
            baseURL: "https://api.coincap.io",
            path: "/v2/assets",
            headers: defaultHeaders,
            queryParameters: ["limit": "100"]
        )
    }

    static func asset(id: String) -> Self {
        .init(
            method: .get,
            baseURL: "https://api.coincap.io",
            path: "/v2/assets/\(id)",
            headers: defaultHeaders,
            queryParameters: nil
        )
    }
}
