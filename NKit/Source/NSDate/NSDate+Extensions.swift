import Foundation

extension NSDate : Comparable {}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}

public func <= (lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}

public func >= (lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}

public func > (lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}


// MARK: - Components

public extension NSDate {
  
  public func nk_components(unit: NSCalendarUnit, retrieval: NSDateComponents -> Int) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(unit, fromDate: self)
    return retrieval(components)
  }
  
  public var nk_second: Int {
    return nk_components(.Second) {
      return $0.second
    }
  }
  
  public var nk_minute: Int {
    return nk_components(.Minute) {
      return $0.minute
    }
  }
  
  public var nk_hour: Int {
    return nk_components(.Hour) {
      return $0.hour
    }
  }
  
  public var nk_day: Int {
    return nk_components(.Day) {
      return $0.day
    }
  }
  
  public var nk_month: Int {
    return nk_components(.Month) {
      return $0.month
    }
  }
  
  public var nk_year: Int {
    return nk_components(.Year) {
      return $0.year
    }
  }
  
  public var nk_weekday: Int {
    return nk_components(.Weekday) {
      return $0.weekday
    }
  }
}
