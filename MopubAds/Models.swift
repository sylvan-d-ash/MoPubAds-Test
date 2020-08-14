//
//  Models.swift
//  MopubAds
//
//  Created by Sylvan Ash on 14/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

protocol ContentProtocol: AnyObject {
    func reuseIdentifier() -> String
}

// MARK: -

class NormalContent: NSObject, ContentProtocol {
    let title: String

    init(title: String) {
        self.title = title
        super.init()
    }

    func reuseIdentifier() -> String {
        return ContentViewCell<NormalContentView>.reuseIdentifier()
    }
}

// MARK: -

class DisplayAdContent: NSObject, ContentProtocol {
    let type: AdType
    let position: String

    init(type: AdType, position: String) {
        self.type = type
        self.position = position
        super.init()
    }

    func reuseIdentifier() -> String {
        return ContentViewCell<DisplayAdContentView>.reuseIdentifier()
    }
}

// MARK: -

class NativeAdContent: NSObject, ContentProtocol {
    let type: AdType = .native
    let position: String

    init(position: String) {
        self.position = position
        super.init()
    }

    func reuseIdentifier() -> String {
        return ContentViewCell<NativeAdContentView>.reuseIdentifier()
    }
}

// MARK: -

class AdParamsBuilder {
    static let adUnitId = "/8663477/BR/Horse_Racing/main/mob/horse-racing"

    static func params(for type: AdType, position: String) -> [String: Any] {
        var dict: [String: Any] = [
            "tdcidx": "ckJzckJzckJuckJzcl9zckJzb0JzckJuckJzckJzckJzckJz",
            "locale": "en_US",
            "vers": "7.22.0",
            "app": "true",
            "build": "8615",
            "sid": "1",
            "pg": type == .native ? "section" : "main",
            "size": type.sizeString,
            "pos": type == .native ? "nat_lar_\(position)_mob" : "rect_atf_\(position)_mob",
            "tags": "horse_racing",
            "tag_id": "2474",
            "site": "Horse_Racing",
            "division": "none",
            "team": "none",
            "alert": "false",
        ]

        if type != .native {
            dict["page"] = "main"
        }

        return dict
    }
}
