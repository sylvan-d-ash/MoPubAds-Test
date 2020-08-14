//
//  Views.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import GoogleMobileAds
import UIKit

protocol ViewProtocol {
    associatedtype ContentType: ContentProtocol
    func load(content: ContentType)
}

protocol HasController: AnyObject {
    // weak
    var controller: UIViewController? { get set }
}

// MARK: -

final class ContentViewCell<ViewType: UIView>: UICollectionViewCell, HasController where ViewType: ViewProtocol {
    let displayContentView = ViewType()
    weak var controller: UIViewController? {
        get {
            return (displayContentView as? HasController)?.controller
        }
        set {
            (displayContentView as? HasController)?.controller = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(displayContentView)
        displayContentView.fillParent()
    }

    func loadData(_ data: ContentProtocol) {
        guard let data = data as? ViewType.ContentType else { return }
        displayContentView.load(content: data)
    }

    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

// MARK: -

class NormalContentView: UIView, ViewProtocol {
    typealias ContentType = NormalContent

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .systemIndigo

        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.fillParent()
    }

    func load(content: NormalContent) {
        titleLabel.text = content.title
    }
}

// MARK: -

class DisplayAdContentView: UIView, ViewProtocol, HasController, GADBannerViewDelegate {
    typealias ContentType = DisplayAdContent
    weak var controller: UIViewController?

    private let containerView = UIView()
    private let adTypeLabel = UILabel()
    private let loadStatusLabel = UILabel()

    private var bannerView: DFPBannerView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .white

        adTypeLabel.textAlignment = .center
        addSubview(adTypeLabel)
        adTypeLabel.fillParentHorizontally()
        adTypeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        adTypeLabel.heightAnchor.constraint(equalToConstant: Dimensions.labelHeight).isActive = true

        loadStatusLabel.textAlignment = .center
        addSubview(loadStatusLabel)
        loadStatusLabel.fillParentHorizontally()
        loadStatusLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadStatusLabel.heightAnchor.constraint(equalToConstant: Dimensions.labelHeight).isActive = true

        containerView.backgroundColor = .systemGreen
        addSubview(containerView)
        containerView.fillParentHorizontally()
        containerView.topAnchor.constraint(equalTo: adTypeLabel.bottomAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: loadStatusLabel.topAnchor, constant: -10).isActive = true
    }

    private func loadDisplayAd(content: DisplayAdContent) {
        let size = GADAdSizeFromCGSize(content.type.size)
        bannerView = DFPBannerView(adSize: size)
        bannerView.adUnitID = AdParamsBuilder.adUnitId
        bannerView.rootViewController = controller
        bannerView.delegate = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])

        let request = DFPRequest()
        let extras = GADExtras()
        extras.additionalParameters = AdParamsBuilder.params(for: content.type, position: content.position)
        request.register(extras)

        bannerView.load(request)
    }

    // MARK: ViewProtocol

    func load(content: DisplayAdContent) {
        adTypeLabel.text = content.type.description
        loadStatusLabel.text = "Status: Loading.."
        loadDisplayAd(content: content)
    }

    // MARK: GADBannerViewDelegate

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        loadStatusLabel.text = "Status: Loaded"
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("💚❌ error: \(error.localizedDescription)")
        loadStatusLabel.text = "Status: \(error.localizedDescription)"
    }
}

// MARK: -

class NativeAdContentView: UIView, ViewProtocol, HasController, GADNativeCustomTemplateAdLoaderDelegate {
    typealias ContentType = NativeAdContent
    weak var controller: UIViewController?

    private let containerView = UIView()
    private let adTypeLabel = UILabel()
    private let loadStatusLabel = UILabel()

    private var nativeAdView: UnifiedNativeAdView!
    private var adLoader: GADAdLoader?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .white

        adTypeLabel.textAlignment = .center
        addSubview(adTypeLabel)
        adTypeLabel.fillParentHorizontally()
        adTypeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        adTypeLabel.heightAnchor.constraint(equalToConstant: Dimensions.labelHeight).isActive = true

        loadStatusLabel.textAlignment = .center
        addSubview(loadStatusLabel)
        loadStatusLabel.fillParentHorizontally()
        loadStatusLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadStatusLabel.heightAnchor.constraint(equalToConstant: Dimensions.labelHeight).isActive = true

        containerView.backgroundColor = .systemTeal
        addSubview(containerView)
        containerView.fillParentHorizontally()
        containerView.topAnchor.constraint(equalTo: adTypeLabel.bottomAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: loadStatusLabel.topAnchor, constant: -10).isActive = true
    }

    private func loadNativeAd(content: NativeAdContent) {
        nativeAdView = UnifiedNativeAdView()
        containerView.addSubview(nativeAdView)
        nativeAdView.fillParent()

        requestNativeAd(content: content)
    }

    private func requestNativeAd(content: NativeAdContent) {
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

        let params = AdParamsBuilder.params(for: content.type, position: content.position)
        let extras = GADExtras()
        extras.additionalParameters = params as [AnyHashable: Any]
        let request = DFPRequest()
        request.register(extras)
        self.adLoader = adLoader

        adLoader.load(request)
    }

    // MARK: ViewProtocol

    func load(content: NativeAdContent) {
        adTypeLabel.text = content.type.description
        loadStatusLabel.text = "Status: Loading.."
        loadNativeAd(content: content)
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
        loadStatusLabel.text = "Status: Custom Native Ad Loaded!"
    }

    // MARK: GADUnifiedNativeAdLoaderDelegate

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        loadStatusLabel.text = "Status: Unified Native Ad Loaded!"
        nativeAdView.load(content: nativeAd)
    }

    // MARK: GADAdLoaderDelegate

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("💚❌ error: \(error.localizedDescription)")
        loadStatusLabel.text = "Status: \(error.localizedDescription)"
    }
}

// MARK: -

extension UIView {
    func fillParent() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }

    func fillParentHorizontally() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
}

enum Dimensions {
    static let labelHeight: CGFloat = 25
}
