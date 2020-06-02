//
//  StatusCode.swift
//  GooglePlaces
//
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

///	Possible status codes for Places endpoints
public enum StatusCode: String, Decodable {
    case ok = "OK"
    case zeroResults = "ZERO_RESULTS"
    case overQueryLimit = "OVER_QUERY_LIMIT"
    case requestDenied = "REQUEST_DENIED"
    case invalidRequest = "INVALID_REQUEST"
    case unknownError = "UNKNOWN_ERROR"

    public var localizedDescription: String {
        switch self {
        case .ok:
            return Localized.StatusCode.ok
        case .zeroResults:
            return Localized.StatusCode.zeroResults
        case .overQueryLimit:
            return Localized.StatusCode.overQueryLimit
        case .requestDenied:
            return Localized.StatusCode.requestDenied
        case .invalidRequest:
            return Localized.StatusCode.invalidRequest
        case .unknownError:
            return Localized.StatusCode.unknownError
        }
    }
}
