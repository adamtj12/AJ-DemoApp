//  AdamSampleProject

import UIKit
import CoreData

class CurrencyRatesHistoryCollectionViewModel: CollectionViewModel {    
    var cellIdentifier: String = NibNameValue
    var containingVC: UIViewController!
    var rowSelectedAction: TableViewRowSelectedAction?
    var title: String = ""
    var valuesToCompare = [Dictionary<String,RatesValues>].init()
    var valuesToCompareSorted = [[Dictionary<String, RatesValues>.Element]].init()
    var currencyMultiplier = Double.init()
    
    func titleForSection(_ section: Int) -> String {
        return ""
    }

    func configureCellForObject(_ cell: UICollectionViewCell, object: NSManagedObject, indexPath: IndexPath, editingMode: Bool) -> UICollectionViewCell {
        if let cellUnwrapped = cell as? FieldCollectionViewCell {
            if indexPath.section == 0 {
                if let rateValue = object as? RatesValues {
                    cellUnwrapped.label.text = rateValue.currency
                    cellUnwrapped.label.font = UIFont.boldSystemFont(ofSize: 13)
                }
            } else {
                if let rateValue = object as? RatesValues {
                    let getRawExchange = (currencyMultiplier) * rateValue.value
                    let roundedValue = (Double(round(1000*(getRawExchange))/1000))
                    cellUnwrapped.label.text = String(roundedValue)
                }
            }
        }

        return cell
    }
    
    func configureCellForCollectionStaticCell(_ cell: UICollectionViewCell, value: String, indexPath: IndexPath, editingMode: Bool) -> UICollectionViewCell {
        if let cellUnwrapped = cell as? FieldCollectionViewCell {
            if value.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = originalDateFormat
            let date = dateFormatter.date(from: value)
            dateFormatter.dateFormat = newDateFormat
            let resultString = dateFormatter.string(from: date!)
            print(resultString)
            cellUnwrapped.label.text = resultString
            } else {
                cellUnwrapped.label.text = value
            }
            cellUnwrapped.label.font = UIFont.boldSystemFont(ofSize: 13)
        }
        return cell
    }

    func getCellHeight() -> CGSize {
        let width  = (containingVC.view.frame.width-20)/3
        return CGSize(width: width, height: 60)
    }
    
    func getCellNibs() -> [(nib: UINib, identifier: String)]? {
        let nib = UINib(nibName: FieldCollectionViewCell.getNibName(), bundle: nil)
        return [(nib, cellIdentifier)]
    }

    
}
