//  AdamSampleProject

import UIKit


class VerticleTitleTwoSubTitleTableViewCell: TitleTwoSubTitleTableViewCell {
    static let height: CGFloat = 45
    static let normalLabelHeightTotal = 45

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getNibName() -> String {
        return NibNameValue
    }
}
