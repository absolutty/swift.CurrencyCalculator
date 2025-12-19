import Foundation
import DGCharts

class CustomLineChartView : LineChartView {
    //MARK: chart apperance setup
    func setChartAppearance() {
        rightAxis.enabled = false
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = XAxisDateFormater()
        xAxis.labelRotationAngle = -45.0
        
        noDataText = NSLocalizedString("chart-waiting", comment: "čakanie na zvolenie meny do Chart-u")
    }
    
    //MARK: loading chart data using API
    func loadChart(from: String, to: String) {
        RequestManager.shared.getTimeSeries(from: from, to: to) { response in
            switch response{
            case .success(let timeSeriesData):
                let data = CustomLineChartData()
                data.setupData(from: from, to: to, response: timeSeriesData)
                
                self.data = data
                self.animate(xAxisDuration: 1.0)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
