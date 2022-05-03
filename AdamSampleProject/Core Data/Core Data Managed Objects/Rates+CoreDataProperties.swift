//  AdamSampleProject

import Foundation
import CoreData


extension Rates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rates> {
        return NSFetchRequest<Rates>(entityName: "Rates")
    }

    @NSManaged public var base: String?
    @NSManaged public var date: String?
    @NSManaged public var success: Bool
    @NSManaged public var timestamp: Double
    @NSManaged public var ratesvalues: NSSet?
}

extension Rates: Identifiable {

}
