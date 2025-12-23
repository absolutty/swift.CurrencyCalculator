import UIKit

class CurrencyCell: UITableViewCell {
    static var classString: String { String(describing: self.self) }

    //MARK: outlets
    @IBOutlet weak var abbreviatonLabel: UILabel?
    @IBOutlet weak var valueLabel: UILabel?
    
    var actionBlock: (() -> Void)? = nil
    
  
    @IBAction func didTapButton(_ sender: Any) {
        actionBlock?()
    }
}

extension CurrencyCell {
    //MARK: setting up cell with certain values
    func setupCell(abbreviation: String, value: Double) {
        abbreviatonLabel?.text = abbreviation
        valueLabel?.text = "\(ValueFormatter.formatDouble(toBeFormatted: value))"
    }
}
