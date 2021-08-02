import Foundation

typealias JSON = [String: Any]

public enum Endpoint {
	case autocomplete(term: String, countryCodes: [String], placeType: PlaceType, sessionToken: String)
	case details(placeId: String, sessionToken: String)
}

extension Endpoint: Loggable {}

extension Endpoint {
	var urlRequest: URLRequest {
		guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			fatalError("Invalid path-based URL")
		}
		comps.queryItems = queryItems(params: queryParams)

		guard let finalURL = comps.url else {
			fatalError("Invalid query items...(probably)")
		}

		var req = URLRequest(url: finalURL)
		req.httpMethod = httpMethod.rawValue
		req.allHTTPHeaderFields = headers

		return req
	}
}

private extension Endpoint {
	enum HTTPMethod: String {
		case GET, POST, PUT, DELETE, HEAD, CHUNK
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .autocomplete, .details:
			return .GET
		}
	}

	///	Custom headers, that may be needed for some specific endpoints.
	///	AnnanowService will add common headers (shared by all endpoints), then it executes the request.
	var headers: [String: String] {
		var h: [String: String] = [:]

		h["Accept"] = "application/json"
        h["Accept-Language"] = Locale.current.languageCode ?? "en"

		return h
	}

	var baseURL : URL {
		return PlacesService.baseURL
	}

	var url: URL {
		let url = baseURL

		switch self {
		// Authentication
		case .autocomplete:
			return url.appendingPathComponent("autocomplete/json")

		case .details:
			return url.appendingPathComponent("details/json")
		}
	}


	//	Request building

	///	Builds JSON object of parameters that will be sent as query-string. (Used by `queryItems`).
	var queryParams: JSON {
		var p: JSON = [:]

		switch self {
		case .autocomplete(let term, let countryCodes, let placeType, let sessionToken):
			p["input"] = term
			p["sessiontoken"] = sessionToken
			p["types"] = placeType.rawValue
			if countryCodes.count > 0 {
				p["components"] = buildComponentsValue(using: countryCodes)
			}

		case .details(let placeId, let sessionToken):
			p["placeid"] = placeId
			p["sessiontoken"] = sessionToken

		}

		p["key"] = PlacesService.apiKey
		return p
	}

	///	Builds proper, RFC-compliant query-string pairs.
	func queryItems(params: JSON) -> [URLQueryItem]? {
		if params.count == 0 { return nil }

		var arr: [URLQueryItem] = []
		for (key, value) in params {
			let v = String(describing: value)
			let qi = URLQueryItem(name: key, value: v)
			arr.append( qi )
		}
		return arr
	}
}

private extension Endpoint {
	/**
	`components` — A grouping of places to which you would like to restrict your results.

	Currently, you can use components to filter by up to 5 countries.
	Countries must be passed as a two character, ISO 3166-1 Alpha-2 compatible country code.
	For example: `components=country:fr` would restrict your results to places within France.

	Multiple countries must be passed as multiple country:XX filters, with the pipe character (|) as a separator.
	For example: `components=country:us|country:pr|country:vi|country:gu|country:mp` would restrict your results to places within the United States and its unincorporated organized territories.
	*/
	func buildComponentsValue(using countryCodes: [String]) -> String {
		let arr = countryCodes.map{ "country:\( $0)" }.prefix(5)
		return arr.joined(separator: "|")
	}
}
