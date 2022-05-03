//  AdamSampleProject

import CoreData
import UIKit

typealias TableViewRowSelectedAction = (_ indexPath: IndexPath, _ object: NSManagedObject) -> ()

protocol TableViewModel: ViewModel {
    var cellIdentifier: String { get set }
    var containingVC: UIViewController! { get set }
    var rowSelectedAction: TableViewRowSelectedAction? { get }
    
    func viewDidLoadActions()
    
    func leftBarButtonItems() -> [UIBarButtonItem]
    
    func rightBarButtonItems() -> [UIBarButtonItem]
    
    func getCellNibs() -> [(nib: UINib, identifier: String)]?
    
    func titleForSection(_ section: Int) -> String
    
    func getCellId(_ object: NSManagedObject) -> String
        
    func configureCellForRate(_ cell: DefaultTableViewCell, object: [RatesValues], indexPath: IndexPath) -> DefaultTableViewCell

    func handleDidSelectOnTable(indexPath: IndexPath)
    
    func handleDidDeSelectOnTable(indexPath: IndexPath)

    func getHeight(_ indexPath: IndexPath, object: NSManagedObject?) -> CGFloat
                
    func viewWillAppear()
    
    func viewWillDisappear()
}

extension TableViewModel {
    
    func viewDidLoadActions() {
        // Do Nothing
    }
    
    func leftBarButtonItems() -> [UIBarButtonItem] {
        return []
    }
    
    func rightBarButtonItems() -> [UIBarButtonItem] {
        return []
    }
    
    func getCellId(_ object: NSManagedObject) -> String {
        return cellIdentifier
    }
    
    func viewWillAppear() {
        // Do Nothing
    }
    
    func viewWillDisappear() {
        // Do Nothing
    }
}
