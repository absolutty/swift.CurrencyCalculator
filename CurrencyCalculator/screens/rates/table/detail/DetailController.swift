import Foundation
import UIKit
import SwiftUI

class DetailController : UIViewController {

    @IBOutlet weak var labelFullName: UILabel?
    @IBOutlet weak var chartView: CustomLineChartView?
    
    private var fullNameFrom: String?
    private var abbreviationFrom: String?
    private var abbreviationTo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let abbreviationFrom, let abbreviationTo else { return }
        
        labelFullName?.text = fullNameFrom
        chartView?.loadChart(from: abbreviationFrom, to: abbreviationTo)
    }
    
    func setupDetail(fullNameFrom: String, abbreviationFrom: String, abbreviationTo: String) {
        self.fullNameFrom = fullNameFrom
        self.abbreviationFrom = abbreviationFrom
        self.abbreviationTo = abbreviationTo
    }
}
