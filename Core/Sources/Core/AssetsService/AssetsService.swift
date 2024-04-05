import Foundation

public protocol AssetsServiceType {
    func assets() async -> Result<[Asset], NetworkError>
    func asset(id: String) async -> Result<Asset, NetworkError>
}

/// Service which fetches assets data from the CoinCap API.
public struct AssetsService: AssetsServiceType {
    private let network: Networking

    init(network: Networking) {
        self.network = network
    }

    public init() {
        self.init(network: Network())
    }

    public func assets() async -> Result<[Asset], NetworkError> {
        let result: Result<AssetsResponse, NetworkError> = await network.send(request: URLRequest(requestDefinition: .assets))

        switch result {
        case .success(let response):
            return .success(response.data)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func asset(id: String) async -> Result<Asset, NetworkError> {
        let result: Result<AssetResponse, NetworkError> = await network.send(request: URLRequest(requestDefinition: .asset(id: id)))

        switch result {
        case .success(let response):
            return .success(response.data)
        case .failure(let error):
            return .failure(error)
        }
    }
}

public class AssetsServiceMock: AssetsServiceType {
    public init() {}

    public var assetsResult: Result<[Asset], NetworkError> = .success([])
    public var receivedAssetsCall = 0
    public func assets() async -> Result<[Asset], NetworkError> {
        receivedAssetsCall += 1
        return assetsResult
    }

    public var assetByIdResult: Result<Asset, NetworkError> = .success(.fake())
    public var receivedAssetByIdParameter = [String]()
    public func asset(id: String) async -> Result<Asset, NetworkError> {
        receivedAssetByIdParameter.append(id)
        return assetByIdResult
    }
}

struct AssetsResponse: Decodable {
    let data: [Asset]
}

struct AssetResponse: Decodable {
    let data: Asset
}
