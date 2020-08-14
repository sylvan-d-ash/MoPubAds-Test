//
//  Views.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

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

class DisplayAdContentView: UIView, ViewProtocol {
    typealias ContentType = DisplayAdContent

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

    func load(content: DisplayAdContent) {
        //
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
