import Foundation

public struct Asset: Decodable, Equatable, Identifiable, Hashable {
    public let id: String
    public let symbol: String
    public let name: String
    public let priceUsd: String
    public let changePercent24Hr: String
    public let marketCapUsd: String
    public let volumeUsd24Hr: String
    public let supply: String

    public static func fake(
        id: String = .random(),
        symbol: String = ["ETH", "BTC", "SOL"].randomElement()!,
        name: String = .random(),
        priceUsd: String = .randomPositiveNumber(),
        changePercent24Hr: String = .randomPercentage(),
        marketCapUsd: String = .randomPositiveNumber(),
        volumeUsd24Hr: String = .randomPositiveNumber(),
        supply: String = .randomPositiveNumber()
    ) -> Self {
        self.init(
            id: id,
            symbol: symbol,
            name: name,
            priceUsd: priceUsd,
            changePercent24Hr: changePercent24Hr,
            marketCapUsd: marketCapUsd,
            volumeUsd24Hr: volumeUsd24Hr,
            supply: supply
        )
    }
}

public extension String {
    static func random() -> String {
        return (0..<10).reduce(
            into: "", { string, _ in
                return string.append(Character.random())
            }
        )
    }

    static func randomPositiveNumber() -> String {
        String(Double.random(in: 0...1_000_000))
    }

    static func randomPercentage() -> String {
        String(Double.random(in: -100...100))
    }
}

public extension Character {
    static func random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".randomElement() ?? "R"
    }
}
