import Foundation

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void

public class APIClient {
    let apiDeclarations = APIDeclarations.init()
	private let session = URLSession(configuration: .default)
	private let publicKey: String
	private let privateKey: String

	public init(publicKey: String, privateKey: String) {
		self.publicKey = publicKey
		self.privateKey = privateKey
	}

 	public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<RatesRequest>) {
		let endpoint = self.endpoint(for: request)
		let task = session.dataTask(with: URLRequest(url: endpoint)) { data, response, error in
			if let data = data {
				do {
					let currencyResponse = try JSONDecoder().decode(RatesRequest.self, from: data)
                    print(currencyResponse)
                    completion(.success(currencyResponse))
				} catch {
					completion(.failure(error))
                    print(error)
				}
			} else if let error = error {
				completion(.failure(error))
                print(error)
			}
		}
		task.resume()
	}
    
	/// Encodes a URL based on the given request
	private func endpoint<T: APIRequest>(for request: T) -> URL {
        guard let baseUrl = URL(string: request.resourceName, relativeTo: apiDeclarations.baseEndpointUrl) else {
			fatalError("Bad resourceName: \(request.resourceName)")
		}
        let components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
		return components.url!
	}
}
