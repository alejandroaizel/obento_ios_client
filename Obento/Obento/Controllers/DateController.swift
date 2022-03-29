//
//  DateController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 19/3/22.
//

import Foundation

class DateController {
    let calendar: Calendar;
    
    struct FormattedDate: Equatable {
        let numberDay: Int
        let numberMonth: Int
        let numberYear: Int
        let nameDay: String
        let nameMonth: String
        let nameYear: String
        
        static func == (lhs: FormattedDate, rhs: FormattedDate) -> Bool {
            return lhs.numberDay == rhs.numberDay && lhs.numberMonth == rhs.numberMonth && lhs.numberYear == rhs.numberYear
        }
    }
    
    init() {
        calendar = Calendar.current
    }
    
    private func currentDate() -> Date {
        return Date() + 60 * 60
    }
    
    public func currentDate() -> FormattedDate {
        return formatDay(currentDate())
    }

    private func getWeek(forDay date: Date = (Date() + 60 * 60)) -> [Date] {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: date)!
        var days = (weekdays.lowerBound ..< weekdays.upperBound + 1)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: date) }
        days.remove(at: 0)
        
        return days
    }

    private func getDay(inWeek weekDiference: Int = 0, from day: Date) -> Date {
        return calendar.date(byAdding: .day, value: 7 * weekDiference, to: day)!
    }
    
    public func getWeek(for week: Int = 0) -> [FormattedDate] {
        return formatWeek(getWeek(forDay: getDay(inWeek: week, from: currentDate())))
    }
    
    private func formatDay(_ day: Date) -> FormattedDate {
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "EEEE"
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.dateFormat = "LLLL"
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.dateFormat = "yyyy"
        
        let dayInt = calendar.dateComponents([.day], from: day).day!
        let dayString = dateFormatterDay.string(from: day)
        let monthInt = calendar.dateComponents([.month], from: day).month!
        let monthString = dateFormatterMonth.string(from: day)
        let yearInt = calendar.dateComponents([.year], from: day).year!
        let yearString = dateFormatterYear.string(from: day)
        
        return .init(numberDay: dayInt, numberMonth: monthInt, numberYear: yearInt, nameDay: dayString, nameMonth: monthString, nameYear: yearString)
    }
    
    private func formatWeek(_ week: [Date]) -> [FormattedDate] {
        var formattedWeek: [FormattedDate] = []
        
        for day in week {
            formattedWeek.append(formatDay(day))
        }
        
        return formattedWeek
    }
    
    public func winnerMonth(from week: [FormattedDate]) -> String {
        var firstMonthOccurences = 0;
        let firstMonth = week[0].nameMonth
        
        for day in week {
            if day.nameMonth == firstMonth {
                firstMonthOccurences += 1
            }
        }
        
        if firstMonthOccurences > 3 {
            return firstMonth
        }
        
        return week[week.count - 1].nameMonth
    }
    
    public func formatDay(_ day: Date) -> CustomDay {
        let auxDate: FormattedDate = formatDay(day)
        
        return .init(day: auxDate.numberDay, month: auxDate.numberMonth, monthString: auxDate.nameMonth, year: auxDate.numberYear)
    }
    
    public func currentDay() -> CustomDay {
        return formatDay(currentDate())
    }
}
