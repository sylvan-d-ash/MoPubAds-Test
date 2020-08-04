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
        let dict: [String: Any] = [
            "tdcidx": "ckJzckJzckJuckJzcl9zckJzb0JzckJuckJzckJzckJzckJz",
            "locale": "en_US",
            "vers": "7.22.0",
            "app": "true",
            "pg": "main",
            "build": "8615",
            "size": adType.sizeString,
            "sid": "1",
            "page": "main",
            "pos": "rect_atf_01_mob",
            "tags": "horse_racing",
            "tag_id": "2474",
            "site": "Horse_Racing",
            "division": "none",
            "team": "none",
            "alert": "false",
        ]
        return dict
    }()

    private let adTypeLabel = UILabel()
    private let containerView = UIView()
    private var bannerView: DFPBannerView!
    private let loadStatusLabel = UILabel()

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

        setupAdView()
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
        bannerView.removeFromSuperview()
        setupAdView()
    }
}

extension ViewController: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        print("💚 Banner adapter class name: \(bannerView.responseInfo?.adNetworkClassName)")
    }

    public  func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("💚❌ error: \(error.localizedDescription)")
    }
}
