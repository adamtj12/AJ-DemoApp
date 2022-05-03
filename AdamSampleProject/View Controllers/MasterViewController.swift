//  AdamSampleProject

import UIKit
import CoreData

class MasterViewController: UIViewController, ViewWithViewModel, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //MARK: General Variable Declarations
    var tableViewModel: TableViewModel!
    let apiClient = APIClient(publicKey: "", privateKey: "")
    var numberOfSelectionsOnTable: Int = 0
    var valuesToCompare = [Dictionary<String,RatesValues>].init()
    private var tapOutsideRecognizer: UITapGestureRecognizer!
    
    var currencyTableViewModel: CurrencyTableViewModel!
    var viewModel: ViewModel! {
        didSet {
            self.tableViewModel = (viewModel as! TableViewModel)
        }
    }

    @IBOutlet weak var currencyEntryField: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor.black
        }
    }
    
    @IBOutlet weak var compareLabel: UILabel!
    

    //MARK: General Lifecycle Handling and View Load Operations
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewModel = CurrencyTableViewModel.init()
        
        assert(self.tableViewModel != nil)
        self.tableViewModel.viewWillAppear()
        self.tableViewModel.viewDidLoadActions()
        self.configureView()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyTableViewModel = self.tableViewModel as? CurrencyTableViewModel
        
        if let tableModel = tableViewModel as? CurrencyTableViewModel {
            tableModel.setUpPersistentStorage(isFavorites: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableViewModel.viewAppeared()
        currencyTableViewModel = self.tableViewModel as? CurrencyTableViewModel
        tableView.reloadData()
    }
    
    //MARK: UI Component Setup
     func configureView() {
         setUpTable()
         setUpTapGesture()
    }
    
    
    func setUpTable() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsMultipleSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = true
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 1))
        self.title = tableViewModel.title
        self.tableViewModel.containingVC = self

        let nibInfoArray = self.tableViewModel.getCellNibs()
        if let unwrappedNibInfoArray = nibInfoArray {
            for nibInfo in unwrappedNibInfoArray {
                self.tableView.register(nibInfo.nib, forCellReuseIdentifier: nibInfo.identifier)
            }
        }
        
        self.navigationItem.leftBarButtonItems = tableViewModel.leftBarButtonItems()
        self.navigationItem.rightBarButtonItems = tableViewModel.rightBarButtonItems()
    }
    
    func setUpTapGesture() {
        if (self.tapOutsideRecognizer == nil) {
            self.tapOutsideRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBehind))
            self.tapOutsideRecognizer.numberOfTapsRequired = 1
            self.tapOutsideRecognizer.cancelsTouchesInView = false
            self.tapOutsideRecognizer.delegate = self
            self.view.window?.addGestureRecognizer(self.tapOutsideRecognizer)
        }

    }
    
    // MARK: - Gesture methods to dismiss this with tap outside
    @objc func handleTapBehind(sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            let location: CGPoint = sender.location(in: self.view)

            if (!self.view.point(inside: location, with: nil)) {
                self.view.window?.removeGestureRecognizer(sender)
                self.close(sender: sender)
            }
        }
    }
    
    func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    //MARK: Navigation Bar Button Operations
    @IBAction func began(_ sender: Any) {
        valuesToCompare.removeAll()
        if currencyEntryField.text?.count == 0 {
            currencyEntryField.text = "1"
        }
        self.tableView.reloadData()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        currencyTableViewModel.refreshValues()
        asyncMainThread { [self] in
            tableView.reloadData()
        }
    }

    //MARK: TableViewLogic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyTableViewModel.ratesSorted.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewModel.cellIdentifier, for: indexPath) as? DefaultTableViewCell else {
            return UITableViewCell()
        }
        
        return tableViewModel.configureCellForRate(cell, object: currencyTableViewModel.ratesSorted, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRows = tableView.indexPathsForSelectedRows?.filter({ $0.section == indexPath.section }) {
            if selectedRows.count == 2 {
                return nil
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewModel.handleDidSelectOnTable(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableViewModel.handleDidDeSelectOnTable(indexPath: indexPath)
    }
}

extension UITableView {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { deselectRow(at: indexPath, animated: animated) }
    }
}
