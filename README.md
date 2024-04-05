# CoinCapClient

A lightweight client for [CoinCap API](https://docs.coincap.io) written in SwiftUI for demo purpose.

## Project overview

The project contains
* **Core** package which holds the model data and a thin network layer.
* **CoinCapClient** containing the SwiftUI App.

This kind of separation can help to showcase different approaches for UI architectures like [TCA](https://github.com/pointfreeco/swift-composable-architecture/tree/main) or [Observation](https://developer.apple.com/documentation/observation) by adding new targets.

## How to build and run

Open the CoinCapClient.xcodeproj with Xcode 15.3. Build and run!

## How to execute tests

The project contains the CoinCapClient.xctestplan which executes tests from both Core package and the main target. The related scheme triggers the test plan. So, basically, just execute Unit Tests with CMD+U.

The test plan Localization is configured for English language and USA area to avoid flakiness of tests which involve number or currency formatting.