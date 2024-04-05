@testable import Core
import XCTest

final class AssetsServiceTests: XCTestCase {
    class NetworkMock: Networking {
        var receivedRequests: [URLRequest] = []
        var stubbedResult: Decodable?
        var stubbedError: NetworkError?
        func send<T: Decodable>(request: URLRequest) async -> Result<T, NetworkError> {
            receivedRequests.append(request)
            if let stubbedError {
                return .failure(stubbedError)
            } else if let result = stubbedResult as? T {
                return .success(result)
            } else {
                print("No stub provided, returning error...")
                return .failure(.unknown)
            }
        }
    }

    // MARK: assets

    func test_WHEN_assets_THEN_sendsAssetsRequest() async {
        // GIVEN
        let network = NetworkMock()
        let service = AssetsService(network: network)

        // WHEN
        _ = await service.assets()

        // THEN
        XCTAssertEqual(network.receivedRequests, [URLRequest(requestDefinition: .assets)])
    }

    func test_GIVEN_networkReturningError_WHEN_assets_returnsError() async {
        // GIVEN
        let network = NetworkMock()
        let error = NetworkError.unknown
        network.stubbedError = error
        let service = AssetsService(network: network)

        // WHEN
        let result = await service.assets()

        // THEN
        XCTAssertEqual(result, .failure(error))
    }

    func test_GIVEN_networkReturningAssets_WHEN_assets_THEN_returnsAssets() async {
        // GIVEN
        let network = NetworkMock()
        let asset = Asset.fake()
        network.stubbedResult = AssetsResponse(data: [asset])
        let service = AssetsService(network: network)

        // WHEN
        let result = await service.assets()

        // THEN
        XCTAssertEqual(result, .success([asset]))
    }

    // MARK: asset by id

    func test_WHEN_assetById_THEN_sendsAssetByIdRequest() async {
        // GIVEN
        let network = NetworkMock()
        let service = AssetsService(network: network)

        // WHEN
        _ = await service.asset(id: "ETH")

        // THEN
        XCTAssertEqual(network.receivedRequests, [URLRequest(requestDefinition: .asset(id: "ETH"))])
    }

    func test_GIVEN_networkReturningError_WHEN_assetById_returnsError() async {
        // GIVEN
        let network = NetworkMock()
        let error = NetworkError.unknown
        network.stubbedError = error
        let service = AssetsService(network: network)

        // WHEN
        let result = await service.asset(id: "ETH")

        // THEN
        XCTAssertEqual(result, .failure(error))
    }

    func test_GIVEN_networkReturningAsset_WHEN_assetById_THEN_returnsAsset() async {
        // GIVEN
        let network = NetworkMock()
        let asset = Asset.fake()
        network.stubbedResult = AssetResponse(data: asset)
        let service = AssetsService(network: network)

        // WHEN
        let result = await service.asset(id: "ETH")

        // THEN
        XCTAssertEqual(result, .success(asset))
    }
}
