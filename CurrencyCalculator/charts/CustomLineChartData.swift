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
        
        let dayDurationInSeconds: TimeInterval = 60*60*24
        
        var values: [ChartDataEntry] = Array()
        
        let start = Date().startOfMonth()
        let end = Date().endOfMonth()
        
        var i: Int = 0
        for date in stride(from: start, to: end, by: dayDurationInSeconds) {
           let hodnota = timeSeriesData.rates[dateFormatter.string(from: date)]![to]
            values.append(ChartDataEntry(x: Double(i), y: hodnota!))
            i += 1
        }
        
        set.replaceEntries(values)
        set.label = from
        
        dataSets.append(set)
    }
}
