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
    private var contents: [ContentProtocol] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()

        DispatchQueue.main.async { [weak self] in
            self?.loadData()
        }
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
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

    private func loadData() {
        contents = [
            NormalContent(title: "First item"),
            DisplayAdContent(type: .banner, position: "01"),

            NormalContent(title: "First item"),
            NormalContent(title: "First item"),
            NativeAdContent(position: "01"),

            NormalContent(title: "First item"),
            NormalContent(title: "First item"),
            DisplayAdContent(type: .rectangle, position: "02"),

            NormalContent(title: "First item"),
            NormalContent(title: "First item"),
            NativeAdContent(position: "02"),
            NormalContent(title: "First item"),
        ]
        collectionView.reloadData()
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
        return contents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = contents[indexPath.row]
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: content.reuseIdentifier(), for: indexPath)
        if type(of: content) == NormalContent.self, let cell = _cell as? ContentViewCell<NormalContentView> {
            cell.controller = self
            cell.loadData(content)
        } else if type(of: content) == DisplayAdContent.self, let cell = _cell as? ContentViewCell<DisplayAdContentView> {
            cell.controller = self
            cell.loadData(content)
        } else if type(of: content) == NativeAdContent.self, let cell = _cell as? ContentViewCell<NativeAdContentView> {
            cell.controller = self
            cell.loadData(content)
        }

        return _cell
    }
}

extension ShowAdsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (Dimensions.labelHeight * 2) + (10 * 2) + AdType.rectangle.size.height
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
