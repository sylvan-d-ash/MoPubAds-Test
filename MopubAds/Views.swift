//
//  Views.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import GoogleMobileAds
import UIKit

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

// MARK: -

protocol ViewProtocol {
    associatedtype ContentType: ContentProtocol
    func load(content: ContentType)
}

// MARK: -

final class ContentViewCell<ViewType: UIView>: UICollectionViewCell where ViewType: ViewProtocol {
    let displayContentView = ViewType()

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
        backgroundColor = .white

        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.fillParent()
    }

    func load(content: NormalContent) {
        titleLabel.text = content.title
    }
}

// MARK: -

class DisplayAdContentView: UIView, ViewProtocol, GADBannerViewDelegate {
    typealias ContentType = DisplayAdContent

    private let containerView = UIView()
    private var bannerView: DFPBannerView!
    private let adTypeLabel = UILabel()
    private let loadStatusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .white

        let labelHeight: CGFloat = 35

        adTypeLabel.textAlignment = .center
        addSubview(adTypeLabel)
        adTypeLabel.fillParentHorizontally()
        adTypeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        adTypeLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true

        loadStatusLabel.textAlignment = .center
        addSubview(loadStatusLabel)
        loadStatusLabel.fillParentHorizontally()
        loadStatusLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadStatusLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true

        containerView.backgroundColor = .green
        addSubview(containerView)
        containerView.fillParentHorizontally()
        containerView.topAnchor.constraint(equalTo: adTypeLabel.bottomAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: loadStatusLabel.topAnchor, constant: 10).isActive = true
    }

    private func setupAdView(content: DisplayAdContent) {
        let size = GADAdSizeFromCGSize(content.type.size)
        bannerView = DFPBannerView(adSize: size)
        bannerView.adUnitID = AdParamsBuilder.adUnitId
        //bannerView.rootViewController = self
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
        extras.additionalParameters = AdParamsBuilder.params(for: content.type, position: content.position)
        request.register(extras)

        bannerView.load(request)
    }

    // MARK: ViewProtocol

    func load(content: DisplayAdContent) {
        adTypeLabel.text = content.type.description
        loadStatusLabel.text = "Status: Loading.."
        setupAdView(content: content)
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

class NativeAdContentView: UIView, ViewProtocol {
    typealias ContentType = NativeAdContent

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        //
    }

    func load(content: NativeAdContent) {
        //
    }
}
