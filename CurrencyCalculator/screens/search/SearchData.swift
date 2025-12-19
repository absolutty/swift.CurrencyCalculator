import Foundation

class SearchData{
    static let shared: SearchData = SearchData()
    
    var valuesArray = Array<String>() //obsahuje VSETKY values
    var filteredValuesArray = Array<String>() //obsahuje FILTROVANE values, menia sa pocas vyhladavania
    var currenciesFullNames: [String: String] = [:]
    
    private func loadSearchData()  {
        OpenExchangeRatesManager.shared.getCurrencies() { response in
            switch response {
            case .success(let currenciesData):
                self.valuesArray = Array(currenciesData.values)
                self.valuesArray.sort()
                
                self.filteredValuesArray = self.valuesArray
                
                //keys a values sa swapnu, rychlejsi pristup k nazvu jednotlivych currencies
                self.currenciesFullNames = currenciesData.swapKeyValues()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func getSearchData() -> Array<String> {
        if (valuesArray.isEmpty) { //prve nacitanie dat
            loadSearchData()
        }
        return valuesArray
    }
}

//MARK: vymena keys za values
extension Dictionary where Value: Hashable {
    func swapKeyValues() -> [Value : Key] {
        return Dictionary<Value, Key>(uniqueKeysWithValues: lazy.map { ($0.value, $0.key) })
    }
}
