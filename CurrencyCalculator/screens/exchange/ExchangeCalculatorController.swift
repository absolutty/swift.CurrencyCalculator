import UIKit
import iOSDropDown
import DGCharts

class ExchangeCalculatorController: UIViewController, ChartViewDelegate {
//MARK: outlets
    //MARK: fromCurrency
    @IBOutlet weak var dropDownFrom: CustomDropDown!
    @IBOutlet weak var txtFieldAbbreviationFrom: UITextField!
    
    //MARK: toCurrency
    @IBOutlet weak var dropDownTo: CustomDropDown!
    @IBOutlet weak var txtFieldAbbreviationTo: UITextField!
    
    //MARK: calculate
    @IBOutlet weak var txtFieldInput: UITextField!
    @IBOutlet weak var txtFieldOutput: UITextField!
    @IBOutlet weak var btnCalculate: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: chart view
    @IBOutlet weak var chartView: CustomLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //vytvaranie tapGesture pre vypocet kurzu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ExchangeCalculatorController.convertTappedButton(gesture:)))
        btnCalculate.addGestureRecognizer(tapGesture)
        btnCalculate.isUserInteractionEnabled = true
        
        self.txtFieldInput.addTarget(self, action: #selector(ExchangeCalculatorController.inputDidChange(_:)), for: .editingChanged)

        dropDownFrom.didSelect{ (selectedText , index ,id) in
            self.txtFieldAbbreviationFrom.text = self.dropDownFrom.getAbbreviation(of: selectedText)
            self.txtFieldOutput.text = ""
        }
        
        dropDownTo.didSelect{ (selectedText , index ,id) in
            self.txtFieldAbbreviationTo.text = self.dropDownTo.getAbbreviation(of: selectedText)
            self.txtFieldOutput.text = ""
        }
        
        chartView.setChartAppearance()
    }

    
    //MARK: convertTappedButton
    @objc func convertTappedButton(gesture: UIGestureRecognizer) {
        do {
            try testInput()
            self.activityIndicator.startAnimating()
            
            RequestManager.shared.getConversion(from: txtFieldAbbreviationFrom.text!, to: txtFieldAbbreviationTo.text!, value: Double(txtFieldInput.text!)!){  response in
                self.activityIndicator.stopAnimating()
                switch response{
                case .success(let conversionData):
                    self.txtFieldOutput.text = "\(ValueFormatter.formatDouble(toBeFormatted: conversionData.response))"
                    self.chartView.loadChart(from: self.txtFieldAbbreviationFrom.text!, to: self.txtFieldAbbreviationTo.text!)
                    
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
            //kedze error obsahuje string 'prazdnyInput("Nezadal si hodnotu na konverziu!")',
            //ja potrebujem z neho dostat iba error message tak string splitnem na zaklade znaku "
            let errMessage = "\(error)".components(separatedBy: "\"")
            
            let alert = UIAlertController(title: "Chyba vstupu.", message: errMessage[1], preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dobre", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: overenie správnosti zadania vstupu
    private func testInput() throws {
        guard let notEmpty = txtFieldInput.text, !notEmpty.isEmpty else {
            throw InputErrorTypes.prazdnyInput("Nezadal si hodnotu na konverziu!")
        }
        guard let isNumber = txtFieldInput.text, Double(isNumber) != nil else {
            throw InputErrorTypes.nieJeNumber("Nezadal si cislo na konverziu!")
        }
        guard let greaterThanZero = txtFieldInput.text, Double(greaterThanZero)! >= 0 else {
            throw InputErrorTypes.zaporneCislo("Nemozes konvertovat zaporne cisla!")
        }
        guard let fromNezadane = txtFieldAbbreviationFrom.text, !fromNezadane.isEmpty else {
            throw InputErrorTypes.nezadaneFromAleboTo("Nezadal si menu Z ktorej chces konvertovat!")
        }
        guard let toNezadane = txtFieldAbbreviationTo.text, !toNezadane.isEmpty else {
            throw InputErrorTypes.nezadaneFromAleboTo("Nezadal si menu DO ktorej chces konvertovat!")
        }
    }
    
    //MARK: listener zmeny input textu
    @objc func inputDidChange(_ textField: UITextField) {
        txtFieldOutput.text = ""
    }
}
