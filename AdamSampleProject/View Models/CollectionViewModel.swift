//  AdamSampleProject

import UIKit
import CoreData


protocol CollectionViewModel: ViewModel {
    var cellIdentifier: String { get set }
    var containingVC: UIViewController! { get set }
    
    func viewDidLoadActions()
    
    func leftBarButtonItems() -> [UIBarButtonItem]
    
    func rightBarButtonItems() -> [UIBarButtonItem]
    
    func getCellNibs() -> [(nib: UINib, identifier: String)]?
    
    func titleForSection(_ section: Int) -> String
    
    func configureCellForCollectionStaticCell(_ cell: UICollectionViewCell, value: String, indexPath: IndexPath, editingMode: Bool) -> UICollectionViewCell

    func configureCellForObject(_ cell: UICollectionViewCell, object: NSManagedObject, indexPath: IndexPath, editingMode: Bool) -> UICollectionViewCell
                            
    func viewWillAppear()
    
    func viewWillDisappear()
    
    func getCellHeight() -> CGSize

}

extension CollectionViewModel {
    
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
    
    func getCellNibs() -> [(nib: UINib, identifier: String)]? {
        // If using standard table view cell, dont need to return custom nib
        return nil
    }
    
    func getCellHeight() -> CGSize {
        return CGSize.init()
    }
                
    func viewWillAppear() {
        // Do Nothing
    }
    
    func viewWillDisappear() {
        // Do Nothing
    }
}
