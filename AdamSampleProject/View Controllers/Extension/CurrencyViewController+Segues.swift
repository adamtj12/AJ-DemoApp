//
//  AdamSampleProject
//

import Foundation
import UIKit

extension CurrencyViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSelection") {
            if let vc = segue.destination as? CurrencyCompareViewController {
            vc.configureOnSegue(collectionViewModel: CurrencyRatesHistoryCollectionViewModel.init())
            vc.collectionViewModel.valuesToCompare = self.currencyTableViewModel.valuesToCompare
            vc.collectionViewModel.currencyMultiplier = Double(self.currencyEntryField.text ?? "1")!
            }
        }
    }
}
