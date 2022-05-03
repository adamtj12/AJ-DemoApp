//  AdamSampleProject

import UIKit
import CoreData

class CurrencyTableViewModel: TableViewModel {
    var title: String = ""
    var cellIdentifier: String = NibNameValue
    weak var containingVC: UIViewController!
    var rowSelectedAction: TableViewRowSelectedAction?
    var rates: NSManagedObject = NSManagedObject()
    var ratesSorted = [RatesValues].init()
    var valuesToCompare = [Dictionary<String,RatesValues>].init()
    var historicalData: [NSManagedObject] = []
    let apiClient = APIClient(publicKey: "", privateKey: "")
    
    init() {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
            
    func leftBarButtonItems() -> [UIBarButtonItem] {
        return [UIBarButtonItem.init()]
    }
    
    func rightBarButtonItems() -> [UIBarButtonItem] {
        return []
    }
    
    func getCellNibs() -> [(nib: UINib, identifier: String)]? {
        let nib = UINib(nibName: FieldCollectionViewCell.getNibName(), bundle: nil)
        return [(nib, cellIdentifier)]
    }
    
    func titleForSection(_ section: Int) -> String {
        return "Currency"
    }
    
    func setUpPersistentStorage(isFavorites: Bool) {
        if readAllObjects(ofType: Rates.self, context: CoreDataHelper.mainContext()).count == 0 {
            performDataGetterAndSetter()
        } else {
            try! rates = CoreDataHelper.mainContext().fetch(Rates.fetchRequest()).first!
            try! historicalData = CoreDataHelper.mainContext().fetch(HistoricalRates.fetchRequest())
            if let rateVales = (rates as? Rates)?.ratesvalues?.allObjects as? [RatesValues] {
                ratesSorted = rateVales.sorted(by: {$0.currency < $1.currency})
                ratesSorted.removeAll(where: {$0.currency == currencyStrings.EUR})
            }
        }
    }
    
    func performDataGetterAndSetter() {
        apiClient.send(GetExchangeRates()) { [self] response in
            _ = response.map { dataContainer in
                rates = Rates.mapFromDictionaryOfObjects(dataContainer, context: CoreDataHelper.mainContext())
                syncMainThread {
                    if let vc = self.containingVC as? CurrencyViewController {
                        vc.currencyTableViewModel.rates = rates
                        if let rateVales = (rates as? Rates)?.ratesvalues?.allObjects as? [RatesValues] {
                            ratesSorted = rateVales.sorted(by: {$0.currency < $1.currency})
                            ratesSorted.removeAll(where: {$0.currency == currencyStrings.EUR})
                            vc.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
            for date in self.returnLastDates(date: Date()) {
                apiClient.send(GetHistoricalExchangeRates(dateString: date)) { [self] response in
                    _ = response.map { dataContainer in
                        historicalData.append(HistoricalRates.mapFromDictionaryOfObjects(dataContainer, context: CoreDataHelper.mainContext()))
                        print(historicalData)
                        syncMainThread {
                            if let vc = self.containingVC as? CurrencyViewController {
                                vc.tableView.reloadData()
                            }
                        }
                    }
                }
            }
    }
    
    func refreshValues() {
        historicalData.removeAll()
        ratesSorted.removeAll()
        valuesToCompare.removeAll()
        performDataGetterAndSetter()
    }
    
    func returnLastDates(date: Date) -> [String] {
        var previousDays = [String].init()
        var startDate = Calendar.current.date(byAdding: .day, value: -5, to:date)! // first date
        let endDate = date // last date
        
        let formatter = DateFormatter()
        formatter.dateFormat = originalDateFormat
        
        while startDate <= endDate {
            previousDays.append(formatter.string(from: startDate))
            print(formatter.string(from: startDate))
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
        
        return previousDays
        
    }
    
    func configureCellForRate(_ cell: DefaultTableViewCell, object: [RatesValues], indexPath: IndexPath) -> DefaultTableViewCell {
        guard let currencyCell = cell as? TitleTwoSubTitleTableViewCell else {
            return cell
        }
        
        if indexPath.row <= object.count {
            let ratesValues = object[indexPath.row]
            currencyCell.titleLabel.text = ratesValues.currency
            currencyCell.firstSubtitleLabel.text = String(ratesValues.value)
            
            if let masterVC = self.containingVC as? MasterViewController {
                let currencyEntryFieldNumerical = Double(masterVC.currencyEntryField.text ?? "1")
                let getRawExchange = (currencyEntryFieldNumerical ?? 0) * ratesValues.value
                let roundedValue = (Double(round(1000*(getRawExchange))/1000))
                currencyCell.firstSubtitleLabel.text = String(roundedValue)
            }
            
            return currencyCell
        }
        
        return currencyCell
    }
    
    func handleDidSelectOnTable(indexPath: IndexPath) {
        if valuesToCompare.count < 2 {
            var historicalValuesForCurrency = [String:RatesValues].init()
            let historicalRates = (historicalData as? [HistoricalRates])
            var currencyToShow: RatesValues
            let selectedCurrency = ratesSorted[indexPath.row]
            
            for rate in historicalRates! {
                let currencies = ratesSorted
                
                currencyToShow = currencies.first(where: {$0.currency == selectedCurrency.currency})!
                print(currencyToShow)
                historicalValuesForCurrency.updateValue((rate.ratesvalues?.allObjects as! [RatesValues]).first(where: {$0.currency == selectedCurrency.currency})!, forKey: rate.date!)
            }
            
            if let currencyVC = containingVC as? CurrencyViewController {
                if indexPath.row >= (currencyVC.tableView.indexPathsForSelectedRows?.first!.row)! {
                    valuesToCompare.append((historicalValuesForCurrency))
                } else {
                    valuesToCompare.insert(historicalValuesForCurrency, at: 0)
                }
                
                if valuesToCompare.count == 2 {
                    currencyVC.performSegue(withIdentifier: "showSelection", sender: nil)
                }
            }
        }
    }
    
    func handleDidDeSelectOnTable(indexPath: IndexPath) {
        if let currencyVC = containingVC as? CurrencyViewController {
            if currencyVC.tableView.indexPathsForSelectedRows != nil {
                if indexPath.row < (currencyVC.tableView.indexPathsForSelectedRows?.last!.row)! {
                    valuesToCompare.remove(at: 0)
                } else {
                    valuesToCompare.remove(at: 1)
                }
            } else {
                valuesToCompare.remove(at: 0)
            }
        }
    }
    
    func getHeight(_ indexPath: IndexPath, object: NSManagedObject?) -> CGFloat {
        return 70
    }
}
