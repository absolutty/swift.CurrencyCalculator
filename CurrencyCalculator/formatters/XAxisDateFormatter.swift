import Foundation
import DGCharts

class XAxisDateFormater: NSObject, AxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        if value == 0 {
            return ""
        }
        
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "\(Int(value)). MMMM"

        return formatter.string(from: previousMonth)
    }

}
