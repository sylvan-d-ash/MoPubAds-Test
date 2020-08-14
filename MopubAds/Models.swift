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

class NormalContent: NSObject, ContentProtocol {
    let title: String

    init(title: String) {
        self.title = title
        super.init()
    }

    func reuseIdentifier() -> String {
        return ""
    }
}

class DisplayAdContent: NSObject, ContentProtocol {
    let type: AdType
    let position: String

    init(type: AdType, position: String) {
        self.type = type
        self.position = position
        super.init()
    }

    func reuseIdentifier() -> String {
        return ""
    }
}

class NativeAdContent: NSObject, ContentProtocol {
    let type: AdType = .native

    func reuseIdentifier() -> String {
        return ""
    }
}

class AdParamsBuilder {
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
}
