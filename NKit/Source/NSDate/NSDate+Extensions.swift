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

public extension Date {
  
  public func nk_components(_ component: Calendar.Component) -> Int {
    let calendar = Calendar.current
    
    return calendar.component(component, from: self)
  }
  
  public var nk_second: Int {
    return nk_components(.second)
  }
  
  public var nk_minute: Int {
    return nk_components(.minute)
  }
  
  public var nk_hour: Int {
    return nk_components(.hour)
  }
  
  public var nk_day: Int {
    return nk_components(.day)
  }
  
  public var nk_month: Int {
    return nk_components(.month)
  }
  
  public var nk_year: Int {
    return nk_components(.year)
  }
  
  public var nk_weekday: Int {
    return nk_components(.weekday)
  }
}
