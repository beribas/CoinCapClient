import XCTest
import Core
@testable import CoinCapClient
import Combine

final class CoinsViewModelTests: XCTestCase {

    private var cancellables: [AnyCancellable] = []

    override func setUp() {
        cancellables = []
    }

    // MARK: fetchAssets

    @MainActor
    func test_WHEN_fetchAssets_THEN_sendsAssetsCall() async {
        // GIVEN
        let serviceMock = AssetsServiceMock()
        let viewModel = CoinsViewModel(assetsService: serviceMock)

        // WHEN
        await viewModel.fetchAssets()

        // THEN
        XCTAssertEqual(serviceMock.receivedAssetsCall, 1)
    }

    @MainActor
    func test_GIVEN_assetServiceReturningError_WHEN_fetchAssets_THEN_showsError() async {
        // GIVEN
        let serviceMock = AssetsServiceMock()
        serviceMock.assetsResult = .failure(.unknown)
        let viewModel = CoinsViewModel(assetsService: serviceMock)

        var publishedIsLoadingStates: [Bool] = []
        viewModel.$isLoading
            .sink {
                publishedIsLoadingStates.append($0)
            }
            .store(in: &cancellables)

        // WHEN
        await viewModel.fetchAssets()

        // THEN
        XCTAssertTrue(viewModel.showFetchError)
        XCTAssertEqual(viewModel.assets, [])
        XCTAssertEqual(publishedIsLoadingStates, [false, true, false])
    }

    @MainActor
    func test_GIVEN_assetServiceReturningAssets_WHEN_fetchAssets_THEN_hasAssets() async {
        // GIVEN
        let assets: [Asset] = [.fake(), .fake(), .fake()]
        let serviceMock = AssetsServiceMock()
        serviceMock.assetsResult = .success(assets)
        let viewModel = CoinsViewModel(assetsService: serviceMock)

        var publishedIsLoadingStates: [Bool] = []
        viewModel.$isLoading
            .sink {
                publishedIsLoadingStates.append($0)
            }
            .store(in: &cancellables)

        // WHEN
        await viewModel.fetchAssets()

        // THEN
        XCTAssertEqual(viewModel.assets, assets)
        XCTAssertFalse(viewModel.showFetchError)
        XCTAssertEqual(publishedIsLoadingStates, [false, true, false])
    }

    // MARK: updateAsset

    @MainActor
    func test_GIVEN_assetServiceReturningError_WHEN_updateAsset_THEN_showsError() async {
        // GIVEN
        let serviceMock = AssetsServiceMock()
        let assets: [Asset] = [.fake(), .fake(), .fake()]
        serviceMock.assetsResult = .success(assets)
        serviceMock.assetByIdResult = .failure(.unknown)
        let viewModel = CoinsViewModel(assetsService: serviceMock)
        await viewModel.fetchAssets()
        XCTAssertEqual(viewModel.assets, assets)

        // Since the viewModel starts a Task, we need to await an expectation which is fulfilled as soon as showUpdateError is published.
        var publishedShowUpdateErrors: [Bool] = []
        let expectation = XCTestExpectation(description: "showUpdateError was published")
        viewModel.$showUpdateError
            .dropFirst() // will be published immediately and has to be ignored
            .sink {
                publishedShowUpdateErrors.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        var publishedIsUpdatungAssetStates: [Bool] = []
        viewModel.$isUpdatingAsset
            .sink {
                publishedIsUpdatungAssetStates.append($0)
            }
            .store(in: &cancellables)

        // WHEN
        await viewModel.updateAsset(.fake(id: "ASSETID"))
        await fulfillment(of: [expectation])

        // THEN
        XCTAssertEqual(serviceMock.receivedAssetByIdParameter, ["ASSETID"])
        XCTAssertTrue(viewModel.showUpdateError)
        XCTAssertEqual(viewModel.assets, assets)
        XCTAssertEqual(publishedIsUpdatungAssetStates, [false, true, false])
    }

    @MainActor
    func test_GIVEN_assetServiceReturningUpdatedAsset_WHEN_updateAsset_THEN_updatesAsset() async {
        // GIVEN
        let serviceMock = AssetsServiceMock()
        let assetToUpdate = Asset.fake(id: "2")
        let initialAssets: [Asset] = [.fake(id: "1"), assetToUpdate, .fake(id: "3")]
        serviceMock.assetsResult = .success(initialAssets)

        let updatedAsset = Asset.fake(id: "2")
        serviceMock.assetByIdResult = .success(updatedAsset)

        let viewModel = CoinsViewModel(assetsService: serviceMock)
        await viewModel.fetchAssets()
        XCTAssertEqual(viewModel.assets, initialAssets)

        // Since the viewModel starts a Task, we need to await an expectation which is fulfilled as soon as `assets` is published.
        var publishedAssets: [[Asset]] = []
        let expectation = XCTestExpectation(description: "assets was published")
        viewModel.$assets
            .dropFirst() // will be published immediately and has to be ignored
            .sink {
                publishedAssets.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        var publishedIsUpdatungAssetStates: [Bool] = []
        viewModel.$isUpdatingAsset
            .sink {
                publishedIsUpdatungAssetStates.append($0)
            }
            .store(in: &cancellables)

        // WHEN
        await viewModel.updateAsset(.fake(id: "2"))
        await fulfillment(of: [expectation])

        // THEN
        XCTAssertEqual(serviceMock.receivedAssetByIdParameter, ["2"])
        XCTAssertFalse(viewModel.showUpdateError)
        XCTAssertEqual(publishedAssets, [[initialAssets[0], updatedAsset, initialAssets[2]]])
        XCTAssertEqual(publishedIsUpdatungAssetStates, [false, true, false])
    }

    // MARK: cancelAssetUpdate

    @MainActor
    func test_GIVEN_assetUpdateWasTriggered_WHEN_cancelAssetUpdate_THEN_noUpdateAndNoErrorIsPublished() async {
        // GIVEN
        let serviceMock = AssetsServiceMock()
        let assets: [Asset] = [.fake(), .fake(), .fake()]
        serviceMock.assetsResult = .success(assets)
        let viewModel = CoinsViewModel(assetsService: serviceMock)
        await viewModel.fetchAssets()

        viewModel.$assets
            .dropFirst() // will be published immediately and has to be ignored
            .sink { _ in
                XCTFail("Assets should not be published.")
            }
            .store(in: &cancellables)

        viewModel.$showFetchError
            .dropFirst() // will be published immediately and has to be ignored
            .sink { _ in
                XCTFail("showFetchError should not be published.")
            }
            .store(in: &cancellables)

        let expectation = XCTestExpectation(description: "isUpdatingAsset was published as expected")
        let expectedIsUpdatingStates: [Bool] = [false, true, false]
        var publishedIsUpdatungAssetStates: [Bool] = []
        viewModel.$isUpdatingAsset
            .sink {
                publishedIsUpdatungAssetStates.append($0)
                if publishedIsUpdatungAssetStates == expectedIsUpdatingStates {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await viewModel.updateAsset(.fake(id: "2"))

        // Precondition
        XCTAssertEqual(viewModel.assets, assets)

        // WHEN
        viewModel.cancelAssetUpdate()
        await fulfillment(of: [expectation])

        // THEN
        XCTAssertEqual(serviceMock.receivedAssetByIdParameter, ["2"])
        XCTAssertFalse(viewModel.showUpdateError)
    }
}
