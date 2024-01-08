import Foundation

public struct RatesRequest: Decodable {
    public let date: String
    public let base: String
    public let timestamp: Int
    public let success: Bool
    public let rates: RatesValuesRequest
}

public struct HistoricalRatesRequest: Decodable {
    public let date: String
    public let base: String
    public let timestamp: Int
    public let success: Bool
    public let historical: Bool
    public let rates: RatesValuesRequest
}

public struct RatesValuesRequest: Decodable {
    public let USD, EUR, JPY, GBP, AUD, CAD, CHF, CNY, SEK, NZD: Double
    
    func toDic() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }

}

typealias ratesRequest = RatesRequest
typealias rates = RatesValuesRequest
