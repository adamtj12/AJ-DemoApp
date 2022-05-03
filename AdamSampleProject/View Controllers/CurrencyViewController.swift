//  AdamSampleProject

import UIKit
import CoreData

class CurrencyViewController: MasterViewController {
    
    @IBOutlet weak var compareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Jenkins webhook test 2")
    }
    
    @IBAction func toggleSelection(_ sender: Any) {
        if tableView.allowsMultipleSelection == true {
            tableView.allowsMultipleSelection = false
            compareButton.title = enableCompareString
            tableView.deselectAllRows(animated: true)
            currencyTableViewModel.valuesToCompare.removeAll()
            tableView.reloadData()
            compareLabel.isHidden = true
        } else {
            tableView.allowsMultipleSelection = true
            compareLabel.isHidden = false
            compareButton.title = finishString
        }
    }
    
    override func configureView() {
        self.setUpTable()
    }
}
