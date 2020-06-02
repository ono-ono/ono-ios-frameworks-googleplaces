//
//  Service-AppLocale.swift
//  GooglePlaces
//
//  Created by Aleksandar Vacić on 12/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

public extension PlacesService {
    static func enforceLanguage(_ code: String, scriptCode: String? = nil) {
        Bundle.enforceLanguage(code, scriptCode: scriptCode)
    }
}
