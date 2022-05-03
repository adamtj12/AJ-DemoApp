//  AdamSampleProjectTests.swift
//  AdamSampleProjectTests

import XCTest
@testable import AdamSampleProject
import CoreData

class AdamSampleProjectTests: XCTestCase {
    var rates: Rates?
    var valuesToCompare = [Dictionary<String,RatesValues>].init()
    let uniqueIdentifier: String = "id"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExcludingEuroFromListData() throws {
        var ratesSorted = [RatesValues].init()
        
        let request = RatesRequest.init(date: "28-04-2022", base: currencyStrings.EUR, timestamp: 1990099009, success: true, rates: RatesValuesRequest.init(USD: 1.30, EUR: 1.0, JPY: 10000, GBP: 0.84, AUD: 1.65, CAD: 1.55, CHF: 190, CNY: 1.49, SEK: 100.00, NZD: 1.45))
        
        let sampleRate = Rates.mapFromDictionaryOfObjects(request, context: CoreDataHelper.mainContext())
        rates = sampleRate as? Rates

        var orginalCount: Int = 0
        if let rateVales = (rates)?.ratesvalues?.allObjects as? [RatesValues] {
            ratesSorted = rateVales.sorted(by: {$0.currency < $1.currency})
            orginalCount = ratesSorted.count
            ratesSorted.removeAll(where: {$0.currency == currencyStrings.EUR})
        }
        XCTAssert(ratesSorted.count < orginalCount && !ratesSorted.contains(where: {$0.currency == currencyStrings.EUR}))
    }
    
    func testSelectingMultipleObjectsIntoComparison() throws {
        let historicalData: [NSManagedObject] = [createObject(ofType: HistoricalRates.self, attributeName: "", value: "", context: CoreDataHelper.mainContext())]
        valuesToCompare.append(createObjectToInsert(historicalData: historicalData, date: "27-04-2022", base: currencyStrings.EUR, historical: true, success: true, timeStamp: 122222929292, currency: currencyStrings.AUD, value: 1.65555555))
        valuesToCompare.append(createObjectToInsert(historicalData: historicalData, date: "28-04-2022", base: currencyStrings.EUR, historical: true, success: true, timeStamp: 122222929292, currency: currencyStrings.AUD, value: 1.65555555))
        XCTAssert(valuesToCompare.count == 2)
    }
    
    func createObjectToInsert(historicalData: [NSManagedObject], date: String, base: String, historical: Bool, success: Bool, timeStamp: Double, currency: String, value:Double) -> [String:RatesValues] {
        var historicalValuesForCurrency = [String:RatesValues].init()
        (historicalData.first as! HistoricalRates).date = date
        (historicalData.first as! HistoricalRates).base = base
        (historicalData.first as! HistoricalRates).historical = historical
        (historicalData.first as! HistoricalRates).success = success
        (historicalData.first as! HistoricalRates).timestamp = timeStamp
        let ratesSorted = [createObject(ofType: RatesValues.self, attributeName: "", value: "", context: CoreDataHelper.mainContext())]
        (ratesSorted.first!).currency = currency
        (ratesSorted.first!).value = value
        
        let historicalRates = (historicalData as? [HistoricalRates])
        let sampleRateValue: Dictionary<String, Any> = ["id": ratesSorted]
        let rate = RatesValues.mapFromDictionaryOfObjectsTest(sampleRateValue, context: CoreDataHelper.mainContext())
        historicalRates?.first!.ratesvalues = NSSet(objects: rate)
        
        var currencyToShow: RatesValues
        let selectedCurrency = ratesSorted[0]
        
        for rate in historicalRates! {
            let currencies = ratesSorted
            currencyToShow = currencies.first(where: {$0.currency == selectedCurrency.currency})!
            print(currencyToShow)
            historicalValuesForCurrency.updateValue((rate.ratesvalues?.allObjects as! [RatesValues]).first!, forKey: rate.date!)
        }

        return historicalValuesForCurrency
    }
}

extension RatesValues {
    static func mapFromDictionaryOfObjectsTest(_ RatesValuesJson: [String:Any], context: NSManagedObjectContext) -> NSManagedObject {
        let ratesValues: RatesValues = createObject(ofType: RatesValues.self, attributeName: uniqueIdentifier, value: "test", context: context)
        CoreDataHelper.performClosureOnContext(context, wait: true, save: true) { (context) in
            if let ratesValuesArray = RatesValuesJson.first?.value as? [RatesValues] {
                ratesValues.value = ratesValuesArray.first?.value ?? 0.0
                ratesValues.currency = ratesValuesArray.first?.currency ?? currencyStrings.GBP
            }
        }
        return ratesValues
    }
}
