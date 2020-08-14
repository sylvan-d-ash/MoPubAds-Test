//
//  Views.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

protocol ViewProtocol {
    associatedtype ContentType: ContentProtocol
    func load(content: ContentType)
}

final class ContentViewCell<ViewType: UIView>: UICollectionViewCell where ViewType: ViewProtocol {
    let displayContentView = ViewType()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContentViewCell {
    func setupSubviews() {
        contentView.addSubview(displayContentView)
        displayContentView.fillParent()
    }
}

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
}
