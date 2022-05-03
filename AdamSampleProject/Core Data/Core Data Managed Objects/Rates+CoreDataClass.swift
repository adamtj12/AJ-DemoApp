//  AdamSampleProject

import Foundation
import CoreData


public class Rates: NSManagedObject {
    
    static var uniqueIdentifier: String = "id"
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(entity: NSEntityDescription, context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(base: String, date: String, success: Bool, timestamp: Double, ratesvalues: NSSet, entity: NSEntityDescription, context: NSManagedObjectContext?){
        super.init(entity: entity, insertInto: context)
        self.base = base
        self.date = date
        self.success = success
        self.timestamp = timestamp
        self.ratesvalues = ratesvalues
    }
}

protocol ManagedObjectFromCollection {
    static func mapFromDictionaryOfObjects(_ RatesJson: RatesRequest, context: NSManagedObjectContext) -> NSManagedObject
    static func updateObjects(_ ratesJson: [RatesRequest], context: NSManagedObjectContext) -> [NSManagedObject]
}


extension Rates: ManagedObjectFromCollection {
    static func mapFromDictionaryOfObjects(_ RatesJson: RatesRequest, context: NSManagedObjectContext) -> NSManagedObject {
        let rates: Rates = createObject(ofType: Rates.self, attributeName: uniqueIdentifier, value: "test", context: context)
        CoreDataHelper.performClosureOnContext(context, wait: true, save: true) { (context) in
            rates.base = RatesJson.base
            rates.timestamp = Double(RatesJson.timestamp)
            rates.date = RatesJson.date
            rates.success = RatesJson.success
            for currencies in RatesJson.rates.toDic() {
                let rate = RatesValues.mapFromDictionaryOfObjects([currencies.key: currencies.value], context: context)
                rates.ratesvalues = rates.ratesvalues?.adding(rate) as NSSet?
            }
        }
        return rates
    }
    
    static func updateObjects(_ RatesJson: [RatesRequest], context: NSManagedObjectContext) -> [NSManagedObject] {
        return [Rates].init()
    }
}
