import Foundation
import DGCharts
import SwiftUI

class CustomLineChartData : LineChartData {
    private let dateFormatter = CustomDateFormatter()
    private let set = LineChartDataSet()
    
    //MARK: formatovanie
    private func format() {
        //formatovanie ciary
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 3
        set.setColor(UIColor(Color.accentColor))
    
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        
        set.fillAlpha = 1.0
        set.drawFilledEnabled = true
    }
    
    //na základe TimeSeriesRespons-u nastaví konkrétne dáta
    func setupData(from: String, to: String, response timeSeriesData: TimeSeriesResponse) {
        format()
        
        let sortedPairs = timeSeriesData.rates.sorted { $0.key < $1.key }

        var entries: [ChartDataEntry] = []
        entries.reserveCapacity(sortedPairs.count)

        for (index, (_, dayRates)) in sortedPairs.enumerated() {
            guard let rate = dayRates[to] else { continue }
            entries.append(ChartDataEntry(x: Double(index), y: rate))
        }
        
        set.replaceEntries(entries)
        set.label = from
        dataSets.append(set)
    }
}
