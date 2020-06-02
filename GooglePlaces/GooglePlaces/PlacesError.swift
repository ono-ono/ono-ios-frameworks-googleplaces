//
//  PlacesError.swift
//  GooglePlaces
//
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

/**
Declaration of errors that GooglePlaces service and throw/return.

Since this module uses networking, it should pass-through any URLErrors that happen.
*/
public enum PlacesError: Error {
	case generalError(Swift.Error)
	case urlError(URLError)
	case invalidResponseType //	when it's not HTTPURLResponse
	case unexpectedResponse(HTTPURLResponse, String?)	//	when JSON conversion fails
	case noResponseData

	case unavailable //	when network conditions are so bad a max number of network retries fails

	case decodingError(Swift.Error)
	case placesError(statusCode: StatusCode, message: String?)
}

extension PlacesError: Loggable {}

extension PlacesError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .generalError(let error):
			return error.localizedDescription

		case .urlError(let urlError):
			return urlError.localizedDescription

		case .decodingError(let error):
			return (error as NSError).localizedDescription

		case .placesError(let statusCode, _):
			return statusCode.localizedDescription

		case .invalidResponseType, .unexpectedResponse, .noResponseData:
			return nil

		case .unavailable:
			return "Bad network conditions"
		}
	}

	public var failureReason: String? {
		switch self {
		case .generalError(let error):
			return (error as NSError).localizedFailureReason

		case .urlError(let urlError):
			return (urlError as NSError).localizedFailureReason

		case .decodingError(let error):
			return (error as NSError).localizedFailureReason

		case .placesError(_, let message):
			return message

		case .invalidResponseType:
			return "Response is not HTTP response."

		case .unexpectedResponse:
			return "Unexpected response contents."

		case .noResponseData:
			return "Empty response body."

		case .unavailable:
			return "Multiple repeated failures to execute network request."
		}
	}
}

extension PlacesError {
	var shouldRetry: Bool {
		switch self {
		case .urlError(let urlError):
			//	if temporary network issues, retry
			switch urlError.code {
			case URLError.timedOut,
				 URLError.cannotFindHost,
				 URLError.cannotConnectToHost,
				 URLError.networkConnectionLost,
				 URLError.dnsLookupFailed:
				return true
			default:
				break
			}

		default:
			break
		}

		return false
	}
}


extension PlacesError {
	init(httpURLResponse: HTTPURLResponse, data: Data?) {
		self = .unexpectedResponse(httpURLResponse, data?.utf8StringRepresentation)
	}
}

private extension Data {
	var utf8StringRepresentation: String? {
		guard
			let str = String(data: self, encoding: .utf8)
			else { return nil }

		return str
	}
}
