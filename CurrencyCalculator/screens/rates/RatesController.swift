import UIKit

class RatesController: UIViewController{
    //MARK: attributes
    var keysArray = Array<String>() //obsahuje USPORIADANE skratky jednotlivych mien ("AUD", "USD", ...)
    var curencyRates: [String: CurrencyRate] = [:] //zoznam jednotlivych mien (kazda je ulozena na key, kt. je jej skatkou
    var filteredKeysArray = Array<String>() //skratky su VYFILTROVANE
    
    //MARK: outlets
    @IBOutlet weak var baseCurrency: UILabel?
    @IBOutlet weak var chooseDropDown: CustomDropDown?
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var ratesTableView: UITableView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    /// Funkcia sa spusta pri loadovani View-u.
    ///    - spustenie indikatora nacitavania
    ///    - nastavenie zobrazovanej base meny
    ///    - nacitanie kurzov
    ///    - didSelect (listener) zobrazenia detailu
    ///    - urcenie delegatov
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator?.startAnimating()
        
        //nastavovanie defaultnych hodnot 
        baseCurrency?.text = loadLatestRate()
        chooseDropDown?.text = curencyRates[baseCurrency?.text ?? ""]?.fullName
        
        loadRates()
        
        //listener na ZMENU zvolenej meny
        chooseDropDown?.didSelect{ (selectedText , index ,id) in
            self.baseCurrency?.text = self.chooseDropDown?.getAbbreviation(of: selectedText)
            self.loadRates()
            self.storeLatestRate()
        }
        
        //outlet delegations
        searchBar?.delegate = self
        ratesTableView?.dataSource = self
        ratesTableView?.register(
            UINib(nibName: CurrencyCell.classString, bundle: nil),
            forCellReuseIdentifier: CurrencyCell.classString
        )
    }
    
    //MARK: LOADING latest used rate
    /// Nacita z UserDefaults poslednu ulozenu menu.
    /// - Returns: skratku ako String poslednej ulozenej meny
    private func loadLatestRate() -> String {
        if let data = UserDefaults.standard.data(forKey: "keys") {
            do {
                let decoder = JSONDecoder()
                let keys = try decoder.decode([StoreRateKey].self, from: data)
                
                return keys[0].key

            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        return ""
    }
    
    //MARK: SAVING latest used rate
    /// Ulozi do UserDefaults poslednu zvolenu menu.
    private func storeLatestRate() {
        guard let baseCurrencyText = self.baseCurrency?.text else { return }
        let keyToBeSaved = StoreRateKey(key: baseCurrencyText)
        let keys = [keyToBeSaved]

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(keys)
            UserDefaults.standard.set(data, forKey: "keys")

        } catch {
            print("Unable to Encode Array of keys (\(error))")
        }
    }
    
    //MARK: LOADING and saving rates
    /// nacita a ulozi data z API (taktiez sa refreshne tableview)
    private func loadRates() {
        FrankfurterManager.shared.getCurrencies() { response in
            switch response {
            case .success(let currenciesData):
                self.keysArray = Array(currenciesData.keys)
                self.keysArray.sort()
                
                //cyklus, kt. vytvara objekty typu CurrencyRate a nastavuje im fullname
                for key in self.keysArray {
                    guard let currencyFullName = currenciesData[key] else { continue }
                    var currencyRate = CurrencyRate()
                    currencyRate.fullName = currencyFullName
                    self.curencyRates[key] = currencyRate
                }
                
                FrankfurterManager.shared.getLatest(base: self.baseCurrency?.text ?? ""){  response in
                    self.activityIndicator?.stopAnimating()
                    
                    switch response{
                    case .success(let latestData):
                        var ratesData: [String : Double] = [:]
                        ratesData = latestData.rates
                        
                        //pridelovanie hodnot k jednotlivym uz vytvorenym menam
                        for key in self.keysArray {
                            //kontrola konzistencie dat
                            if let data = ratesData[key] {
                                self.curencyRates[key]?.value = data
                            }
                        }
                        self.filteredKeysArray = self.keysArray
                        self.ratesTableView?.reloadData()
                                   
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: tableView DataSource definition
extension RatesController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredKeysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentKey = self.filteredKeysArray[indexPath.row]
        guard let ratesCell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyCell.classString,
            for: indexPath
        ) as? CurrencyCell,
              let currentRate = self.curencyRates[currentKey]
        else {
            return UITableViewCell()
        }

        ratesCell.setupCell(abbreviation: currentKey, value: currentRate.value)
        ratesCell.actionBlock = {
            self.cellOnClicked(currencyAbbreviation: self.filteredKeysArray[indexPath.row])
        }
        
        return ratesCell
    }
    
    //cell with currencyAbbreviation was clicked
    private func cellOnClicked(currencyAbbreviation: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DetailController", bundle: nil)
        guard let currencyFullName = self.curencyRates[currencyAbbreviation]?.fullName,
              let currencyAbbreviationTo = self.baseCurrency?.text,
              let detailController = storyBoard.instantiateViewController(withIdentifier: "id-detail") as? DetailController
        else {
            return
        }
        
        detailController.setupDetail(
            fullNameFrom: currencyFullName,
            abbreviationFrom: currencyAbbreviation,
            abbreviationTo: currencyAbbreviationTo
        )
        
        self.present(detailController, animated: true, completion: nil)
    }
}

//MARK: searchBar delegate
extension RatesController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            self.filteredKeysArray = Array<String>()
            
            for key in keysArray {
                if ((curencyRates[key]?.fullName.lowercased().hasPrefix(searchText.lowercased())) == true) {
                    filteredKeysArray.append(key)
                }
            }
        } else {
            self.filteredKeysArray = self.keysArray
        }
        
        self.ratesTableView?.reloadData()
    }
}
