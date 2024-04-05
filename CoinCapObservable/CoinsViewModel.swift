import Core
import SwiftUI

@MainActor
@Observable
class CoinsViewModel {
    private let assetsService: AssetsServiceType
    private var updatingTask: Task<Void, Never>?

    private(set) var assets: [Asset] = []
    var isLoading = false
    var isUpdatingAsset = false
    var showFetchError = false
    var showUpdateError = false

    init(assetsService: AssetsServiceType = AssetsService()) {
        self.assetsService = assetsService
    }

    func fetchAssets() async {
        isLoading = true
        let assetsResult = await assetsService.assets()

        switch assetsResult {
        case let .success(assets):
            self.assets = assets
        case .failure:
            showFetchError = true
        }
        isLoading = false
    }

    func updateAsset(_ asset: Asset) async {
        updatingTask = Task {
            isUpdatingAsset = true
            let assetsResult = await assetsService.asset(id: asset.id)

            guard !Task.isCancelled else {
                isUpdatingAsset = false
                return
            }
            switch assetsResult {
            case let .success(asset):
                if let index = assets.firstIndex(where: { $0.id == asset.id }) {
                    self.assets[index] = asset
                }
            case .failure:
                showUpdateError = true
            }
            isUpdatingAsset = false
        }
    }

    func cancelAssetUpdate() {
        updatingTask?.cancel()
    }
}
