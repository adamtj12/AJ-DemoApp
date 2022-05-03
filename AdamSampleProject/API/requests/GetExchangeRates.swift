import Foundation

let apiDeclarations = APIDeclarations.init()

public struct GetExchangeRates: APIRequest {
	public typealias Response = [RatesRequest]

	public var resourceName: String {
		return String(format: "latest?access_key=%@&format=1", apiDeclarations.accessKey)
	}

}

public struct GetHistoricalExchangeRates: APIRequest {
    public typealias Response = [RatesRequest]
    public var dateString: String

    public var resourceName: String {
        return String(format: "%@?access_key=%@&base=EUR&symbols=USD,EUR,JPY,GBP,AUD,CAD,CHF,CNY,SEK,NZD", dateString, apiDeclarations.accessKey)
    }

}
