//
//  VACalendarViewController.swift
//  busapp
//
//  Created by Vadim Maharram on 02.04.2020.
//  Copyright © 2020 Андрей. All rights reserved.
//

import Foundation
import VACalendar

protocol VACalendarListener {
    func dateVAPicked(dateButtonTitle: String,dateStringAPIFormat: String,datePicked: Date, dateString: String)
}

final class VACalendarViewController: UIViewController {
    public var listener: VACalendarListener?
    var fromID = ""
    var date = Date()
    var dateMax = Date()
    var daysAvailabilityNumber = 1
    let fromToDateHeaderColor = UIColor(red:65/255, green:65/255, blue:65/255, alpha:1.00)
    @IBAction func closeButtonTap(_ sender: Any) {
        cutDateForResponse(date: date)
        dismiss(animated: true)
    }
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var weekDaysView: VAWeekDaysView!{
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .short, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.locale = Locale.current.languageCode! != "ru" ? Locale(identifier: "en_US"): Locale(identifier: "ru_RU")
        return calendar
    }()
    
    var calendarView: VACalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateHeaderLabelAttributedText = NSMutableAttributedString(string: dateHeaderLabel.text!)
        dateHeaderLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: dateHeaderLabelAttributedText.length))
        dateHeaderLabel.attributedText = dateHeaderLabelAttributedText
        dateHeaderLabel.textColor = fromToDateHeaderColor
        weekDaysView.layer.borderColor = UIColor.white.cgColor
        weekDaysView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        weekDaysView.layer.shadowOpacity = 1
        weekDaysView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.08).cgColor
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy"
        print(daysAvailabilityNumber)
        var maxDate = Calendar.current.date(byAdding: .day, value: daysAvailabilityNumber, to: Date())!
        
        let maxDateMonth = Calendar.current.component(.month,  from: maxDate)
        var currentDateMonth = Calendar.current.component(.month,  from: Date())
        print(currentDateMonth)
        print(maxDateMonth)
        var numbersBetweenStartEnd = 31
        if   currentDateMonth != maxDateMonth {
            while currentDateMonth < maxDateMonth {
                currentDateMonth = currentDateMonth + 1
                numbersBetweenStartEnd = numbersBetweenStartEnd + 31
            }
        }
        print(numbersBetweenStartEnd)
        if numbersBetweenStartEnd != 0{
            maxDate = Calendar.current.date(byAdding: .day, value: numbersBetweenStartEnd, to: Date())!
        }
        
        let calendar = VACalendar(
            startDate: Date(),
            endDate: maxDate,
            calendar: defaultCalendar
        )
        
        
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = false
        calendarView.selectionStyle = .single
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .vertical
        
        var daysAvailability: [Date] = [Date()]
        var a = 1
        while a <= daysAvailabilityNumber {
            let dayAvailability = Calendar.current.date(byAdding: .day, value: a, to: Date())!
            
            daysAvailability.append(dayAvailability)
            a = a + 1
        }
        
        calendarView.setAvailableDates(DaysAvailability.some(daysAvailability))
        
        calendarView.selectDates([date])
        view.addSubview(calendarView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY + 18,
                width: view.frame.width,
                height: view.frame.height - weekDaysView.frame.maxY
            )
            calendarView.setup()
        }
    }
    
}



extension VACalendarViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return UIColor(red:40/255, green:40/255.0, blue:40/255, alpha:1.00)
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return UIColor(red:40/255, green:40/255.0, blue:40/255, alpha:1.00)
    }
    
    func verticalMonthDateFormater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current.languageCode! != "ru" ? Locale(identifier: "en_US"): Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter
    }
    
}

extension VACalendarViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red:216/255, green:216/255.0, blue:216/255, alpha:1.00)
        case .selected:
            return UIColor(red:40/255, green:40/255.0, blue:40/255, alpha:1.00)
        case .unavailable:
            return UIColor(red:216/255, green:216/255.0, blue:216/255, alpha:1.00)
        default:
            return UIColor(red:40/255, green:40/255.0, blue:40/255, alpha:1.00)
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return UIColor(red:1, green:204/255.0, blue:0, alpha:1.00)
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension VACalendarViewController: VACalendarViewDelegate {
    
    func selectedDate(_ date: Date) {
        print(date)
        cutDateForResponse(date: date)
        dismiss(animated: true)
    }
    func cutDateForResponse(date: Date){
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateStringAPIFormat = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd MMMM"
        let dateString = dateFormatter.string(from: date)
        var dateButtonTitle = dateString
        var today = "Сегодня"
        var tomorrow = "Завтра"
        if Locale.current.languageCode! != "ru"{
            today = "Today"
            tomorrow = "Tomorrow"
        }
        
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date.tomorrow) {
            dateButtonTitle = "\(tomorrow), \(dateButtonTitle)"
        }
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            dateButtonTitle = "\(today), \(dateButtonTitle)"
        }
        
        listener?.dateVAPicked(dateButtonTitle: dateButtonTitle,dateStringAPIFormat: dateStringAPIFormat,datePicked: date, dateString: dateString)
        
    }
    
}
