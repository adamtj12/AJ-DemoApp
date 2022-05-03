//  AdamSampleProject

import Foundation
import CoreData

extension RatesValues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RatesValues> {
        return NSFetchRequest<RatesValues>(entityName: "RatesValues")
    }

    @NSManaged public var value: Double
    @NSManaged public var currency: String
}
