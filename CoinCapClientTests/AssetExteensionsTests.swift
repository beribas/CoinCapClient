import XCTest
import Core
@testable import CoinCapClient

final class AssetExteensionsTests: XCTestCase {

    func test_GIVEN_priceLessThenThousand_WHEN_price_THEN_returnsExpectedPrice() {
        // GIVEN
        let priceUsd = "6.9823147841833210"
        let asset = Asset.fake(priceUsd: priceUsd)

        // WHEN
        let price = asset.price

        // THEN
        XCTAssertEqual(price, "$6.98")
    }

    func test_GIVEN_priceGreaterThenThousand_WHEN_price_THEN_returnsExpectedPrice() {
        // GIVEN
        let priceUsd = "6000.9823147841833210"
        let asset = Asset.fake(priceUsd: priceUsd)

        // WHEN
        let price = asset.price

        // THEN
        XCTAssertEqual(price, "$6.00K")
    }

    func test_GIVEN_priceGreaterThenMillion_WHEN_price_THEN_returnsExpectedPrice() {
        // GIVEN
        let priceUsd = "6000000.9823147841833210"
        let asset = Asset.fake(priceUsd: priceUsd)

        // WHEN
        let price = asset.price

        // THEN
        XCTAssertEqual(price, "$6.00M")
    }

    func test_WHEN_percentage_THEN_returnsExpectedPercentage() {
        // GIVEN
        let changePercent24Hr = "-1.9823147841833210"
        let asset = Asset.fake(changePercent24Hr: changePercent24Hr)

        // WHEN
        let percentage = asset.percentage

        // THEN
        XCTAssertEqual(percentage, "-1.98%")
    }

    func test_GIVEN_percentageNegative_WHEN_isPercentageChangePositive_THEN_returnsFalse() {
        // GIVEN
        let changePercent24Hr = "-1.9823147841833210"
        let asset = Asset.fake(changePercent24Hr: changePercent24Hr)

        // WHEN
        let isPercentageChangePositive = asset.isPercentageChangePositive

        // THEN
        XCTAssertFalse(isPercentageChangePositive)
    }

    func test_GIVEN_percentagePositive_WHEN_isPercentageChangePositive_THEN_returnsTrue() {
        // GIVEN
        let changePercent24Hr = "12.9823147841833210"
        let asset = Asset.fake(changePercent24Hr: changePercent24Hr)

        // WHEN
        let isPercentageChangePositive = asset.isPercentageChangePositive

        // THEN
        XCTAssertTrue(isPercentageChangePositive)
    }

    func test_WHEN_symbolURL_THEN_returnsExpectedURL() {
        // WHEN
        let symbolURL = Asset.fake(symbol: "ETH").symbolURL

        // THEN
        XCTAssertEqual(symbolURL, URL(string: "https://assets.coincap.io/assets/icons/eth@2x.png"))
    }

    func test_WHEN_marketCap_THEN_returnsFormattedValue() {
        // WHEN
        let marketCap = Asset.fake(marketCapUsd: "12345.6789").marketCap

        // THEN
        XCTAssertEqual(marketCap, "$12.35K")
    }

    func test_WHEN_volume_THEN_returnsFormattedValue() {
        // WHEN
        let volume = Asset.fake(volumeUsd24Hr: "12345.6789").volume

        // THEN
        XCTAssertEqual(volume, "$12.35K")
    }

    func test_WHEN_readableSupply_THEN_returnsFormattedValue() {
        // WHEN
        let readableSupply = Asset.fake(supply: "12345.6789").readableSupply

        // THEN
        XCTAssertEqual(readableSupply, "12.35K")
    }
}
