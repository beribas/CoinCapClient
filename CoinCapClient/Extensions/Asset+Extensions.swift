import Foundation
import Core

extension Asset {
    var price: String {
        "$" + priceUsd.asFormattedDecimal()
    }

    var percentage: String {
        changePercent24Hr.asFormattedDecimal() + "%"
    }

    var isPercentageChangePositive: Bool {
        Decimal(string: changePercent24Hr) ?? 0 > 0
    }

    var symbolURL: URL? {
        URL(string: "https://assets.coincap.io/assets/icons/\(symbol.lowercased())@2x.png")
    }

    var marketCap: String {
        "$" + marketCapUsd.asFormattedDecimal()
    }

    var volume: String {
        "$" + volumeUsd24Hr.asFormattedDecimal()
    }

    var readableSupply: String {
        supply.asFormattedDecimal()
    }
}

private extension String {
    func asFormattedDecimal() -> String {
        guard let decimal = Decimal(string: self) else {
            // In production, we would probably want to either filter out such values during parsing or provide a meaningful user feedback
            return "🤷‍♂️"
        }

        return decimal.formatted(.number.notation(.compactName).precision(.fractionLength(2)))
    }
}
