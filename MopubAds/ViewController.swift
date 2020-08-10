//
//  ViewController.swift
//  MopubAds
//
//  Created by Sylvan Ash on 04/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import GoogleMobileAds
import UIKit

class ViewController: UIViewController {
    private let adType = AppDelegate.adType
    private let adUnitId = "/8663477/BR/Horse_Racing/main/mob/horse-racing"
    private lazy var params: [String: Any] = {
        var dict: [String: Any] = [
            "tdcidx": "ckJzckJzckJuckJzcl9zckJzb0JzckJuckJzckJzckJzckJz",
            "locale": "en_US",
            "vers": "7.22.0",
            "app": "true",
            "build": "8615",
            "sid": "1",
            "pg": adType == .native ? "section" : "main",
            "size": adType.sizeString,
            "pos": adType == .native ? "nat_lar_01_mob" : "rect_atf_01_mob",
            "tags": "horse_racing",
            "tag_id": "2474",
            "site": "Horse_Racing",
            "division": "none",
            "team": "none",
            "alert": "false",
        ]

        if adType != .native {
            dict["page"] = "main"
        }

        return dict
    }()
    private var adLoader: GADAdLoader?

    private let adTypeLabel = UILabel()
    private let containerView = UIView()
    private var bannerView: DFPBannerView!
    private let loadStatusLabel = UILabel()

    private var nativeAdView: UnifiedNativeAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupNavigationBar()
    }
}

private extension ViewController {
    func setupSubviews() {
        view.backgroundColor = .white

        adTypeLabel.text = adType.description
        adTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adTypeLabel)
        NSLayoutConstraint.activate([
            adTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        loadStatusLabel.text = ""
        loadStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadStatusLabel)
        NSLayoutConstraint.activate([
            loadStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadStatusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        containerView.backgroundColor = .orange
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: adTypeLabel.bottomAnchor, constant: 20),
        ])

        if adType == .native {
            loadNativeAd()
        } else {
            setupAdView()
        }
    }

    func setupAdView() {
        let size = GADAdSizeFromCGSize(adType.size)
        bannerView = DFPBannerView(adSize: size)
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300),
        ])

        let request = DFPRequest()
        let extras = GADExtras()
        extras.additionalParameters = params
        request.register(extras)

        loadStatusLabel.text = "Loading.."
        bannerView.load(request)
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAd))
    }

    @objc func refreshAd() {
        if adType == .native {
            nativeAdView.removeFromSuperview()
            loadNativeAd()
        } else {
            bannerView.removeFromSuperview()
            setupAdView()
        }
    }
}

private extension ViewController {
    func loadNativeAd() {
        nativeAdView = UnifiedNativeAdView()
        containerView.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nativeAdView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nativeAdView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nativeAdView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nativeAdView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            containerView.heightAnchor.constraint(equalToConstant: 300),
        ])

        requestNativeAd()
        loadStatusLabel.text = "Ad Status: Native Ad Loading.."
    }

    func requestNativeAd() {
        let imageLoaderOptions = GADNativeAdImageAdLoaderOptions()
        imageLoaderOptions.disableImageLoading = false
        let mediaLoaderOptions = GADNativeAdMediaAdLoaderOptions()
        mediaLoaderOptions.mediaAspectRatio = .landscape
        let videoOptions = GADVideoOptions()
        videoOptions.customControlsRequested = true
        videoOptions.clickToExpandRequested = false

        let adTypes: [GADAdLoaderAdType] = [.nativeCustomTemplate, .unifiedNative]
        let adLoader = GADAdLoader(adUnitID: adUnitId, rootViewController: self, adTypes: adTypes, options: [imageLoaderOptions, mediaLoaderOptions, videoOptions])
        adLoader.delegate = self

        let extras = GADExtras()
        extras.additionalParameters = params as [AnyHashable: Any]
        let request = DFPRequest()
        request.register(extras)
        self.adLoader = adLoader

        adLoader.load(request)
    }
}

extension ViewController: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        loadStatusLabel.text = "Ad Status: Loaded"
    }

    public  func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("💚❌ error: \(error.localizedDescription)")
        loadStatusLabel.text = "Ad Status: Failed"
    }
}

extension ViewController: GADNativeCustomTemplateAdLoaderDelegate {
    func nativeCustomTemplateIDs(for adLoader: GADAdLoader) -> [String] {
        return [
            NativeAdTemplateId.content.rawValue,
            NativeAdTemplateId.appInstall.rawValue,
            NativeAdTemplateId.video.rawValue,
            NativeAdTemplateId.carousel.rawValue,
        ]
    }

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeCustomTemplateAd: GADNativeCustomTemplateAd) {
        loadStatusLabel.text = "Ad Status: Native Custom Ad Loaded!"
    }
}

extension ViewController: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        loadStatusLabel.text = "Ad Status: Native Unified Ad Loaded!"
        nativeAdView.load(content: nativeAd)
    }
}

extension ViewController: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("💚❌ error: \(error.localizedDescription)")
        loadStatusLabel.text = "Ad Status: Native Ad Failed"
    }
}

private enum NativeAdTemplateId: String {
    case content = "10100197"
    case appInstall = "10099357"
    case video = "10100077"
    case carousel = "11806947"
}

class UnifiedNativeAdView: GADUnifiedNativeAdView {
    private let headline = UILabel()
    private let advertiser = UILabel()
    private let logo = UIImageView()
    private let ctaLabel = UILabel()
    private let media = GADMediaView()

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {

        headlineView = headline
        addSubview(headline)
        headline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            headline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            headline.topAnchor.constraint(equalTo: topAnchor),
            headline.heightAnchor.constraint(equalToConstant: 24),
        ])

        mediaView = media
        addSubview(media)
        media.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            media.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            media.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            media.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 10),
            media.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
        ])

        iconView = logo
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo: bottomAnchor),
            logo.widthAnchor.constraint(equalToConstant: 24),
            logo.heightAnchor.constraint(equalToConstant: 24),
        ])

        callToActionView = ctaLabel
        addSubview(ctaLabel)
        ctaLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ctaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ctaLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ctaLabel.widthAnchor.constraint(equalToConstant: 130),
            ctaLabel.heightAnchor.constraint(equalToConstant: 24),
        ])

        advertiserView = advertiser
        addSubview(advertiser)
    }

    func load(content: GADUnifiedNativeAd) {
        nativeAd = content
        advertiser.text = content.advertiser

        if let logoImage = content.icon?.image {
            logo.image = logoImage
        }

        if let cta = content.callToAction {
            ctaLabel.text = cta
        }

        media.mediaContent = content.mediaContent
    }
}
