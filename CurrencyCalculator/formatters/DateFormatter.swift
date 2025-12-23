import Foundation

class CustomDateFormatter: DateFormatter {
    override init() {
        super.init()
        dateFormat = "yyyy-MM-dd" //preddefinovany format zobrazovaneho datumu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) if needed, implement plz.")
    }
}

//MARK: iterovanie cez datumy
extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

//MARK: prvy a posledny den predchadzajuceho mesiaca
extension Date {
    func startOfMonth() -> Date {
        var components = DateComponents()
                components.month = -1
                components.day = 1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: endOfMonth()) ?? self
    }
    
    func endOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components) ?? self
    }
}
