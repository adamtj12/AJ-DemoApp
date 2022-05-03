//  AdamSampleProject

import UIKit

class CurrencyCompareViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var tableViewModel: CollectionViewModel!
    var collectionViewModel: CurrencyRatesHistoryCollectionViewModel!
    @IBOutlet weak var cell: UICollectionViewCell!
    @IBOutlet weak var label: UILabel!
        
    @IBOutlet weak var ratesCollectionView: UICollectionView? {
        didSet {
            ratesCollectionView?.dataSource = self
            ratesCollectionView?.delegate = self
        }
    }
    
    var viewModel: ViewModel! {
        didSet {
            self.tableViewModel = (viewModel as! CollectionViewModel)
        }
    }
    
    override func updateViewConstraints() {
           self.view.frame.size.height = UIScreen.main.bounds.height - 200
           self.view.frame.origin.y =  150
           self.view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
           super.updateViewConstraints()
    }
    
    func configureOnSegue(collectionViewModel: CurrencyRatesHistoryCollectionViewModel) {
        self.collectionViewModel = collectionViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ratesCollectionView?.register(UINib(nibName: "FieldCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FieldCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCollection()
    }
    
    func setUpCollection() {
        ratesCollectionView?.register(UINib(nibName: fieldCollectionViewCellString, bundle: nil), forCellWithReuseIdentifier: fieldCellString)
        for (_, element) in collectionViewModel.valuesToCompare.enumerated() {
            collectionViewModel.valuesToCompareSorted.append(contentsOf: [element.sorted( by: { $1.0 < $0.0 })])
        }
        self.collectionViewModel.containingVC = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionViewModel.getCellHeight()
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewModel.valuesToCompareSorted.first!.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewModel.valuesToCompareSorted.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FieldCell", for: indexPath)
        if indexPath.section == 0 {
            let object = ((collectionViewModel.valuesToCompareSorted[indexPath.row == 0 ? 0 : indexPath.row-1] ).first?.value)
            return indexPath.row == 0 ? collectionViewModel.configureCellForCollectionStaticCell(cell, value: "", indexPath: indexPath, editingMode: true) : collectionViewModel.configureCellForObject(cell, object: object!, indexPath: indexPath, editingMode: true)
        }
        if indexPath.section > 0 && indexPath.section <=
            collectionViewModel.valuesToCompareSorted.first!.count  {
            let object = (collectionViewModel.valuesToCompareSorted[indexPath.row == 0 ? 0 : indexPath.row-1])[indexPath.section-1].value
            let key = (collectionViewModel.valuesToCompareSorted[indexPath.row == 0 ? 0 : indexPath.row-1])[indexPath.section-1].key
            return indexPath.row == 0 ? collectionViewModel.configureCellForCollectionStaticCell(cell, value: key, indexPath: indexPath, editingMode: true) : collectionViewModel.configureCellForObject(cell, object: object, indexPath: indexPath, editingMode: true)
        }
        return cell
    }
}

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       layer.mask = mask
   }
}
