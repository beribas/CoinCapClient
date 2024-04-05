@testable import Core
import XCTest

final class URLRequestExtensionsTests: XCTestCase {
    func test_GIVEN_requestDefinition_WHEN_init_THEN_createsExpectedURLRequest() throws {
        // GIVEN
        let requestDefinition = RequestDefinition(
            method: .get,
            baseURL: "https://example.com",
            path: "/path/to/resource",
            headers: ["X-EXAMPLE": "HeaderValue"],
            queryParameters: ["q1": "q1Value"]
        )

        let expectedURL = try XCTUnwrap(URL(string: "https://example.com/path/to/resource?q1=q1Value"))
        var expectedRequest = URLRequest(url: expectedURL)
        expectedRequest.httpMethod = "GET"
        expectedRequest.setValue("HeaderValue", forHTTPHeaderField: "X-EXAMPLE")

        // WHEN
        let request = URLRequest(requestDefinition: requestDefinition)

        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
}
