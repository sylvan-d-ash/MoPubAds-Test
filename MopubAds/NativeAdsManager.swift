//
//  NativeAdsManager.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import GoogleMobileAds

class NativeAdRequest: CustomStringConvertible {
    let ad: NativeAdContent
    let adLoader: GADAdLoader
    var description: String {
        "\(ad)"
    }

    init(ad: NativeAdContent, adLoader: GADAdLoader) {
        self.ad = ad
        self.adLoader = adLoader
    }
}

protocol NativeAdManagerDelegate: class {
    func adRequestCompleted(request: NativeAdRequest)
}

class NativeAdsManager: NSObject, GADNativeCustomTemplateAdLoaderDelegate, GADUnifiedNativeAdLoaderDelegate, GADAdLoaderDelegate {
    weak var delegate: NativeAdManagerDelegate?
    weak var controller: UIViewController?
    private var ads: [NativeAdContent] = []
    private(set) var adRequests = [NativeAdRequest]()

    func loadNativeAds(_ ads: [NativeAdContent]) {
        guard let controller = controller else { return }

        for ad in ads where ad.status == .unitiliazed {
            load(ad, controller: controller)
            ad.status = .loading
        }
        self.ads = ads
    }

    private func load(_ ad: NativeAdContent, controller: UIViewController) {
        let imageLoaderOptions = GADNativeAdImageAdLoaderOptions()
        imageLoaderOptions.disableImageLoading = false
        let mediaLoaderOptions = GADNativeAdMediaAdLoaderOptions()
        mediaLoaderOptions.mediaAspectRatio = .landscape
        let videoOptions = GADVideoOptions()
        videoOptions.customControlsRequested = true
        videoOptions.clickToExpandRequested = false

        let adTypes: [GADAdLoaderAdType] = [.nativeCustomTemplate, .unifiedNative]
        let adLoader = GADAdLoader(adUnitID: AdParamsBuilder.adUnitId, rootViewController: controller, adTypes: adTypes, options: [imageLoaderOptions, mediaLoaderOptions, videoOptions])
        adLoader.delegate = self

        let params = AdParamsBuilder.params(for: ad.type, position: ad.position)
        let extras = GADExtras()
        extras.additionalParameters = params as [AnyHashable: Any]
        let request = DFPRequest()
        request.register(extras)

        adRequests.append(NativeAdRequest(ad: ad, adLoader: adLoader))
        adLoader.load(request)
    }

    func request(for adLoader: GADAdLoader, shouldRemove: Bool = true) -> NativeAdRequest? {
        guard let index = adRequests.firstIndex(where: { $0.adLoader == adLoader }) else { return nil }
        let request = adRequests[index]

        if shouldRemove {
            adRequests.remove(at: index)
        }

        return request
    }

    // MARK: GADNativeCustomTemplateAdLoaderDelegate

    private enum NativeAdTemplateId: String {
        case content = "10100197"
        case appInstall = "10099357"
        case video = "10100077"
        case carousel = "11806947"
    }

    func nativeCustomTemplateIDs(for adLoader: GADAdLoader) -> [String] {
        return [
            NativeAdTemplateId.content.rawValue,
            NativeAdTemplateId.appInstall.rawValue,
            NativeAdTemplateId.video.rawValue,
            NativeAdTemplateId.carousel.rawValue,
        ]
    }

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeCustomTemplateAd: GADNativeCustomTemplateAd) {
        print("💚 [NativeAdManager] GADNativeCustomTemplateAd 💠")
        guard let request = request(for: adLoader) else {
            print("💚❌ [NativeAdManager] couldn't find request for loader: \(adLoader)")
            return
        }
        request.ad.status = .loaded
        delegate?.adRequestCompleted(request: request)
    }

    // MARK: GADUnifiedNativeAdLoaderDelegate

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("💚 [NativeAdManager] GADUnifiedNativeAd ⚛️")
        guard let request = request(for: adLoader) else {
            print("💚❌ [NativeAdManager] couldn't find request for loader: \(adLoader)")
            return
        }
        request.ad.gad = nativeAd
        request.ad.status = .loaded
        delegate?.adRequestCompleted(request: request)
    }

    // MARK: GADAdLoaderDelegate

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("💚❌ error: \(error.localizedDescription)")
        guard let request = request(for: adLoader) else {
            print("💚❌ [NativeAdManager] couldn't find request for loader: \(adLoader)")
            return
        }
        request.ad.status = .failed
        delegate?.adRequestCompleted(request: request)
    }
}
