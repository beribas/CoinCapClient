@testable import Core
import XCTest

final class NetworkTests: XCTestCase {
    struct DecodableResult: Decodable, Equatable {
        let id: Int
    }

    struct FakeError: Error {}

    var mockURLSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    func test_GIVEN_URLProtocolThrowingError_WHEN_sendRequest_THEN_returnsUnknownError() async throws {
        // GIVEN
        let network = Network(session: mockURLSession)
        let url = try XCTUnwrap(URL(string: "https://www.coincap.com"))
        let request = URLRequest(url: url)

        MockURLProtocol.requestHandler = { _ in
            throw FakeError()
        }

        // WHEN
        let result: Result<DecodableResult, NetworkError> = await network.send(request: request)

        // THEN
        XCTAssertEqual(result, .failure(.unknown))
    }

    func test_GIVEN_URLProtocolReturningBadStatusCode_WHEN_sendRequest_THEN_returnsBadResponseCodeError() async throws {
        // GIVEN
        let network = Network(session: mockURLSession)
        let url = URL(string: "https://www.coincap.com")!
        let request = URLRequest(url: url)

        let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil))
        MockURLProtocol.requestHandler = { _ in
            (response, Data())
        }

        // WHEN
        let result: Result<DecodableResult, NetworkError> = await network.send(request: request)

        // THEN
        XCTAssertEqual(result, .failure(.badResponseCode(500)))
    }

    func test_GIVEN_retrievedTypeCanNotBeDecoded_WHEN_sendRequest_THEN_returnsDecodingError() async throws {
        // GIVEN
        let network = Network(session: mockURLSession)
        let url = URL(string: "https://www.coincap.com")!
        let request = URLRequest(url: url)

        let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
        let data = try XCTUnwrap("BADFORMEDRESPONSE".data(using: .utf8))

        MockURLProtocol.requestHandler = { _ in
            (response, data)
        }

        // WHEN
        let result: Result<DecodableResult, NetworkError> = await network.send(request: request)

        // THEN
        XCTAssertEqual(result, .failure(.decodingError))
    }

    func test_GIVEN_retrievedTypeWellFormed_WHEN_sendRequest_THEN_returnsDecodedType() async throws {
        // GIVEN
        let network = Network(session: mockURLSession)
        let url = URL(string: "https://www.coincap.com")!
        let request = URLRequest(url: url)

        let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
        let data = try XCTUnwrap("{\"id\":42}".data(using: .utf8))

        MockURLProtocol.requestHandler = { _ in
            (response, data)
        }

        // WHEN
        let result: Result<DecodableResult, NetworkError> = await network.send(request: request)

        // THEN
        XCTAssertEqual(result, .success(.init(id: 42)))
    }
}
