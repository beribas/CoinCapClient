import Core
import SwiftUI

@main
struct CoinCapClientApp: App {
    var body: some Scene {
        WindowGroup {
            CoinsOverviewView()
                .environmentObject(CoinsViewModel(assetsService: AssetsService()))
        }
    }
}
