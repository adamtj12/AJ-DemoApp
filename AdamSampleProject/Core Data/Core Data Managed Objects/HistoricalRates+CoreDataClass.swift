//  AdamSampleProject

import Foundation
import CoreData


public class HistoricalRates: NSManagedObject {
    
    static var uniqueIdentifier: String = "id"
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(entity: NSEntityDescription, context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(base: String, date: String, success: Bool, timestamp: Double, ratesvalues: NSSet,historical: Bool, entity: NSEntityDescription, context: NSManagedObjectContext?){
        super.init(entity: entity, insertInto: context)
        self.base = base
        self.date = date
        self.success = success
        self.historical = historical
        self.timestamp = timestamp
        self.ratesvalues = ratesvalues
    }
}

protocol ManagedHistoricalObjectFromCollection {
    static func mapFromDictionaryOfObjects(_ RatesJson: RatesRequest, context: NSManagedObjectContext) -> NSManagedObject
    static func updateObjects(_ ratesJson: [HistoricalRatesRequest], context: NSManagedObjectContext) -> [NSManagedObject]
}


extension HistoricalRates: ManagedHistoricalObjectFromCollection {
    static func mapFromDictionaryOfObjects(_ HistoricalRatesJson: RatesRequest, context: NSManagedObjectContext) -> NSManagedObject {
        let historicalRates: HistoricalRates = createObject(ofType: HistoricalRates.self, attributeName: uniqueIdentifier, value: "test", context: context)
        CoreDataHelper.performClosureOnContext(context, wait: true, save: true) { (context) in
            historicalRates.base = HistoricalRatesJson.base
            historicalRates.timestamp = Double(HistoricalRatesJson.timestamp)
            historicalRates.date = HistoricalRatesJson.date
            historicalRates.success = HistoricalRatesJson.success
            historicalRates.historical = HistoricalRatesJson.success
            for currencies in HistoricalRatesJson.rates.toDic() {
                let rate = RatesValues.mapFromDictionaryOfObjects([currencies.key: currencies.value], context: context)
                historicalRates.ratesvalues = historicalRates.ratesvalues?.adding(rate) as NSSet?
            }
        }
        return historicalRates
    }
    
    static func updateObjects(_ RatesJson: [HistoricalRatesRequest], context: NSManagedObjectContext) -> [NSManagedObject] {
        return [Rates].init()
    }
}
