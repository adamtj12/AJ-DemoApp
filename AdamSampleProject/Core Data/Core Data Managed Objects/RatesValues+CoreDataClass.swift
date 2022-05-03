//  AdamSampleProject

import Foundation
import CoreData

@objc(RatesValues)
public class RatesValues: NSManagedObject {
    
    static var uniqueIdentifier: String = "id"

    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(entity: NSEntityDescription, context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(value: Double, currency: String, entity: NSEntityDescription, context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.value = value
        self.currency = currency
    }
}

protocol ManagedRateValuesFromCollection {
    static func mapFromDictionaryOfObjects(_ RatesValuesJson: Dictionary<String, Any>, context: NSManagedObjectContext) -> NSManagedObject
}

extension RatesValues: ManagedRateValuesFromCollection {
    static func mapFromDictionaryOfObjects(_ RatesValuesJson: [String:Any], context: NSManagedObjectContext) -> NSManagedObject {
        let ratesValues: RatesValues = createObject(ofType: RatesValues.self, attributeName: uniqueIdentifier, value: "test", context: context)
        CoreDataHelper.performClosureOnContext(context, wait: true, save: true) { (context) in
            if let doubleValue = RatesValuesJson.first?.value as? Double {
                ratesValues.value = doubleValue
                ratesValues.currency = RatesValuesJson.first?.key ?? ""
            }
        }
        return ratesValues
    }
}
