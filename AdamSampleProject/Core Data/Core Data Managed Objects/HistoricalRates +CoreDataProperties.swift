//  AdamSampleProject

import Foundation
import CoreData


extension HistoricalRates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalRates> {
        return NSFetchRequest<HistoricalRates>(entityName: "HistoricalRates")
    }

    @NSManaged public var base: String?
    @NSManaged public var date: String?
    @NSManaged public var success: Bool
    @NSManaged public var historical: Bool
    @NSManaged public var timestamp: Double
    @NSManaged public var ratesvalues: NSSet?
}

extension HistoricalRates: Identifiable {

}
