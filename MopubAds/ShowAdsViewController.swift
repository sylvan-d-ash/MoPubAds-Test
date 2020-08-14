//
//  ShowAdsViewController.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class ShowAdsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var content: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        registerCells(for: collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func registerCells(for collectionView: UICollectionView) {
        let cellMappings: [String: AnyClass] = [
            ContentViewCell<NormalContentView>.reuseIdentifier(): ContentViewCell<NormalContentView>.self,
            ContentViewCell<DisplayAdContentView>.reuseIdentifier(): ContentViewCell<DisplayAdContentView>.self,
            ContentViewCell<NativeAdContentView>.reuseIdentifier(): ContentViewCell<NativeAdContentView>.self,
        ]
        cellMappings.forEach { reuseIdentifier, type in
            collectionView.register(type, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
}

extension ShowAdsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ForecastCollectionCell.self)", for: indexPath) as? ForecastCollectionCell else {
            return UICollectionViewCell()
//        }
//        cell.load(content: forecasts[indexPath.row])
//        return cell
    }
}
