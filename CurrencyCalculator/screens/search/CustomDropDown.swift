import Foundation
import iOSDropDown
import SwiftUI

class CustomDropDown: DropDown {
    //MARK: attributes
    private var currencies: [String: String] = [:] //v tvare ["American dolar":"USD", "Euro": "EUR", ...]
    
    //MARK: constructor
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //nastavanie SPOLOCNYCH vlasnosti pre pouzivané dropdowni
        rowHeight = 30
        isSearchEnable = true
        listHeight = 300
        arrowColor = UIColor(Color.accentColor)
        backgroundColor = UIColor(named: "AppBlue")
        selectedRowColor = UIColor.systemBlue
        
        loadSearchData()
    }
    
    //MARK: nacitanie dat
    private func loadSearchData()  {
        FrankfurterManager.shared.getCurrencies() { response in
            switch response {
            case .success(let currenciesData):
                //option array tu vystupuje ako pole KEYS ("American dolar", "Euro", ...)
                self.optionArray = Array(currenciesData.values)
                self.optionArray.sort()
                
                //keys a values sa swapnu, rychlejsi pristup k nazvu jednotlivych currencies
                self.currencies = currenciesData.swapKeyValues()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: get skratku meny na zaklade jej nazvu
    public func getAbbreviation(of fullName: String) -> String {
        return currencies[fullName]!
    }
}
