import SwiftUI

@main
struct CoinCapObservableApp: App {
    var body: some Scene {
        WindowGroup {
            CoinsOverviewView()
                .environment(CoinsViewModel())
        }
    }
}
