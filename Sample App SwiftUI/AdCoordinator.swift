//
//  AdCoordinator.swift
//  Sample App SwiftUI
//
//  See https://developers.google.com/admob/ios/swiftui

import GoogleMobileAds

class AdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var ad: GADInterstitialAd?
    
    /**
     * Will reset / preload Ad after each consent change
     * Consent allows Ads: the ad cache will be prepared (ad is displayed on first click after reject -> accept)
     * Consent rejects Ads: the ad chache will be purged (no ad on first click after reject)
     */
    func loadAd() {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()
        ) { ad, error in
            if let error = error {
                self.ad = nil // will reset the cached ad (when error is `No ad to show`)
                return print("Didomi Sample App - Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
            
            self.ad = ad
            self.ad?.fullScreenContentDelegate = self
        }
    }
    
    func presentAd(from viewController: UIViewController) {
        guard let fullScreenAd = ad else {
            return print("Ad wasn't ready")
        }
        
        fullScreenAd.present(fromRootViewController: viewController)
    }
    
    // MARK: - GADFullScreenContentDelegate methods
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Didomi Sample App - Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Didomi Sample App - Ad will present full screen content.")
        self.ad = nil
        loadAd()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Didomi Sample App - Ad did dismiss full screen content.")
    }
}
