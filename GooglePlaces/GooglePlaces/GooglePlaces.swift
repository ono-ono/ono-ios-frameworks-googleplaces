import Foundation

public final class PlacesService {
	private let urlSession: URLSession

	public init(apiKey: String) {
		PlacesService.apiKey = apiKey

		let urlSessionConfiguration: URLSessionConfiguration = {
			let c = URLSessionConfiguration.default
			c.allowsCellularAccess = true
			c.httpCookieAcceptPolicy = .never
			c.httpShouldSetCookies = false
			c.httpAdditionalHeaders = PlacesService.commonHeaders
			c.requestCachePolicy = .reloadRevalidatingCacheData
			return c
		}()
		urlSession = URLSession(configuration: urlSessionConfiguration)

		log(level: .all, "Init")
	}
}

extension PlacesService: Loggable {}

extension PlacesService {
    static var apiKey: String = ""
    static var baseURL: URL = URL(string: "https://maps.googleapis.com/maps/api/place")!

	///	Output types
	public typealias DataResult = Result<Data, PlacesError>
	public typealias Callback = (DataResult) -> Void

	///	Private type which combines input and output point + number of retries
	fileprivate typealias Request = (endpoint: Endpoint, callback: Callback, retriesCount: Int)

	///	Supply fully configured GooglePlacesEndpoint and `Callback` instance to receive the results.
	public func call(_ endpoint: Endpoint, callback: @escaping Callback) {
		let request = (endpoint, callback, 0)

		process(request)
	}
}

private extension PlacesService {
	//	MARK: - Regular API calls

	func process(_ request: Request) {
		let urlRequest = request.endpoint.urlRequest

		//	execute then process result, repeating if needed & possible
		execute(urlRequest) {
			[unowned self] result, retryCounter in
			self.validate(result, for: request)
		}
	}

	func validate(_ result: DataResult, for request: Request) {
		let callback = request.callback

		switch result {
		case .success:
			break

		case .failure(let error):
			switch error {
			case .unavailable:	//	too many failed network calls
				break

			default:
				if error.shouldRetry {
					//	update retries count and try again
					var newRequest = request
					newRequest.retriesCount += 1
					self.process(newRequest)
					return
				}
			}
		}

		callback(result)
	}


	///	Actual URLSession execution
	func execute(_ urlRequest: URLRequest,
				 retryCounter: Int = 0,
				 maxNumberOfRetries: Int = 10,
				 callback: @escaping (DataResult, Int) -> Void)
	{
		if retryCounter >= maxNumberOfRetries {
			self.log(level: .warning, "Too many unsuccessful attemps: \( retryCounter )")
			callback( .failure( PlacesError.unavailable ), retryCounter )
		}

		let task = urlSession.dataTask(with: urlRequest) {
			[unowned self] data, urlResponse, error in

			if let urlError = error as? URLError {
				self.log(level: .error, urlError)
				callback( .failure( PlacesError.urlError(urlError) ), retryCounter )
				return
			} else if let otherError = error {
				self.log(level: .error, otherError)
				callback( .failure( PlacesError.generalError(otherError) ), retryCounter )
				return
			}

			guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
				if let urlResponse = urlResponse {
					self.log(level: .warning, "Non-HTTP response:\n\( urlResponse )")
				} else {
					self.log(level: .error, "No URLResponse received")
				}
				callback( .failure( PlacesError.invalidResponseType ), retryCounter )
				return
			}

			if !(200...299).contains(httpURLResponse.statusCode) {
				self.log(level: .warning, "HTTP status code: \( httpURLResponse.statusCode )\n\( httpURLResponse )")

				let localError = PlacesError(httpURLResponse: httpURLResponse, data: data)
				callback( .failure(localError), retryCounter )
				return
			}

			guard let data = data, data.count > 0 else {
				self.log(level: .warning, "No response body.")
				callback( .failure(PlacesError.noResponseData), retryCounter )
				return
			}

			callback( .success(data), retryCounter )
		}

		task.resume()
	}
}

private extension PlacesService {
	///	Headers, added by URLSession, to each URLRequest instance
	static let commonHeaders: [String: String] = {
		return [
			"User-Agent": userAgent,
			"Accept-Charset": "utf-8",
			"Accept-Encoding": "gzip, deflate"
		]
	}()

	static var userAgent: String = {
		let locale = Locale.current.identifier
		return "\( Bundle.appName ) \( Bundle.appVersion ) (\( Bundle.appBuild )); \( locale )"
	}()
}
