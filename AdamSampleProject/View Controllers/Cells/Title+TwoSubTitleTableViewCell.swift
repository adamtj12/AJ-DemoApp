//  AdamSampleProject


import UIKit

typealias SwitchToggledClosure = (_ isEnabled: Bool) -> ()
typealias MapPressedClosure = (_ coordinates: RatesValues) -> ()

class TitleTwoSubTitleTableViewCell: DefaultTableViewCell {
    static let CellIdentifier = "Title+TwoSubTitleTableViewCell"
    static let NibName = "Title+TwoSubTitleTableViewCell"
    static let CellHeight: CGFloat = 100
    var switchToggledClosure: SwitchToggledClosure = {(isEnabled: Bool) -> () in }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var firstSubtitleLabel: UILabel! {
        didSet {
            firstSubtitleLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var secondSubtitleLabel: UILabel! {
        didSet {
            firstSubtitleLabel.textColor = UIColor.white
        }
    }

    @IBOutlet weak var favouriteToggle: UISwitch!
    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var contentBackgroundView: UIView! {
        didSet {
            contentBackgroundView.layer.cornerRadius = 2.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        firstSubtitleLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    deinit {
        titleLabel.removeObserver(self, forKeyPath: "text")
        firstSubtitleLabel.removeObserver(self, forKeyPath: "text")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }

}
