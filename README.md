## Kurzová kalkulačka
Kalkulačka, bude slúžiť na prevod jednotlivých, svetovo uznávaných mien.

Ďalej umožňuje zobraziť menové kurzy jednotlivých mien (+ grafy).

Použité dáta: [https://frankfurter.dev/](https://frankfurter.dev/)

- **Frankfurter** is a free, open-source currency data API*
- *It tracks reference exchange rates published by institutional and non-commercial sources like the European Central Bank*

# **Popis implementácie**
Pri návrhu aplikácie bola použitá architektúra **MVC** ® **M**odel – **V**iew – **C**ontroller. Jedná sa o pomerne *jednoduchú* ale robustnú a užitočnú architektúru.

MVC is a software development pattern made up of three main objects:

- *The* __M*odel*__ *is where your data resides. Things like persistence, model objects, parsers, managers, and networking code live there.*
- *The* __V*iew*__ *layer is the face of your app. Its classes are often reusable as they don’t contain any domain-specific logic. For example, a UILabel is a view that presents text on the screen, and it’s reusable and extensible.*
- *The* __C*ontroller*__ *mediates between the view and the model via the delegation pattern. In an ideal scenario, the controller entity won’t know the concrete view it’s dealing with. Instead, it will communicate with an abstraction via a protocol. A classic example is the way a UITableView communicates with its data source via the UITableViewDataSource protocol.*
- ![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.013.png)

Aplikácia pozostáva z **dvoch** hlavných okien/views kt. sú oddelené (logikou) v samostatných súboroch.
## RatesController
V TabBar-e sa zobrazuje názov **Kurzy**/**Currencies.**

Zobrazuje **40** konverzných kurzov známych svetovo uznávaných mien. 

- **z** ktorej meny chceme zobraziť kurzy sa určí v *dropdown-e* 
  „**zvoľ menu**/**choose** **currency**“ 
  (pri zmene kurzu sa používajú celé názvy mien)
- pre odfiltrovanie zobrazovaných mien je možné použiť *searchbar*
  (pri filtrovaní sa používajú celé názvy mien)
- výsledné hodnoty mien sú zaokrúhľované na 2 desatinné miesta
- zoznam je usporiadaný abecedne
- pri kliknutí na ikonku grafu pri jednotlivých vypisovaných menách nám je zobrazený vývojový graf meny k zvolenej mene za posledný mesiac



![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.014.png)![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.015.png)
## ExchangeCalculatorController
V TabBar-e sa zobrazuje názov **Kalkulačka**/**Calculator**.

Slúži na prevod daných 170 mien. 

- **z**/**from** ktorej meny a **do**/**to** ktorej meny chce užívateľ konvertovať sa zvolí v jednotlivých *dropdown-och*
- aplikácia má overené zadanie chybových hodnôt (nenumerický znak, záporné hodnoty, nezadané žiadne hodnoty, ...)
![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.016.png)
- po spustení výpočtu sa nám zobrazí aj graf vývoja daných mien
  # **Reagovanie na otočenie displeja**
Pri zmene orientácie displeja mi zmení aj layout. Spravil som to tak z toho dôvodu že pri širokom zobrazení boli dropdown-y zbytočne roztiahnuté a graf nebolo ani vidieť.

![Size Classes iPhone 6 Plus and iPhone 7 Plus](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.017.png)

Dá sa to dosiahnuť tým, že definujeme zvlášť constraint-y pre landscape a portrait. 
(regular a compact)

![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.018.png)

Uchovávanie údajov rieši iOS systém sám (na rozdiel od Androidu).
# **Assets**
![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.019.png)

Jednotlivé zdroje sú uložené v súbore Assets, kde sú aj určito uchovávané (ikonky daných veľkostí, vzhľad ikoniek pre dark/light mode, ...)

# Použitie externých knižníc (komponentov)
## Alamofire
![@Alamofire](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.020.png)

Slúži na zjednodušenie práce s API.

- *Alamofire provides an elegant and composable interface to HTTP network requests. It does not implement its own HTTP networking functionality.* 
- *Instead, it builds on top of Apple's URL Loading System provided by the Foundation framework. At the core of the system is URL Session and the URLSessionTask subclasses.* 
- *Alamofire wraps these APIs, and many others, in an easier to use interface and provides a variety of functionality necessary for modern application development using HTTP networking* 

## Charts
![alt tag](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.021.png)

Vykresľovanie grafov na základe vstupných hodnôt (umožňuje meniť formátovanie).
- *An amazing feature of this library now, for Android, iOS, tvOS and macOS, is the time it saves you when developing for both platforms, as the learning curve is singleton- it happens only once, and the code stays very similar so developers don't have to go around and re-invent the app to produce the same output with a different library. (And that's not even considering the fact that there's not really another good choice out there currently...)* 

## iOSDropDown
Dropdown, kt. umožňuje zobraziť vložené hodnoty a následne vyhľadávať medzi nimi.


- *DropDown menu is really not a thing in iOS development, we are dependent on UIPickerView for that, which doesn’t look like a dropdown menu. To make it we use a third-party library or do it ourselves.*

# **Lokalizácia aplikácie**
![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.023.png)
![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.024.png)

Moja aplikácia je lokalizovaná, to zn. že je preložená do viacerých jazykov (**anglický** a **slovenský**). 
Jazyky sú zmenené automaticky, podľa lokalizácie systému. 
Určuje sa v samotných storyboard-ch.

![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.022.png)

# **Téma**
![](img/Aspose.Words.3a99cbf6-1f08-4f2f-ba74-00569de30cfa.025.png)Vzhľad aplikácie sa automaticky mení pri zmene systémového vzhľadu z light do dark módu a naopak. 
Mení sa farba *písma*, farba *ikoniek*, farba jednotlivých *buniek* v kt. zobrazujú kurzy a farba dropdown-u. 

# **Zdroje**
*API: 
[https://openexchangerates.org/*](https://openexchangerates.org/)*

*API doc: 
[https://docs.openexchangerates.org/*](https://docs.openexchangerates.org/)*

*Porovnávane apps:* 

*easy currency:* 

[*https://play.google.com/store/apps/details?id=com.easy.currency.extra.androary&hl=en&gl=US*](https://play.google.com/store/apps/details?id=com.easy.currency.extra.androary&hl=en&gl=US)

*Převodník měn Plus:*

[*https://play.google.com/store/apps/details?id=com.digitalchemy.currencyconverter&hl=sk&gl=US*](https://play.google.com/store/apps/details?id=com.digitalchemy.currencyconverter&hl=sk&gl=US)

*MVC:*

[*https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach*](https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach)

*orientation of device:* 

[*https://useyourloaf.com/blog/size-classes/*](https://useyourloaf.com/blog/size-classes/)

*Použité knižnice:*

[*https://github.com/Alamofire/Alamofire*](https://github.com/Alamofire/Alamofire)

[*https://github.com/danielgindi/Charts*](https://github.com/danielgindi/Charts)

[*https://github.com/jriosdev/iOSDropDown*](https://github.com/jriosdev/iOSDropDown)



