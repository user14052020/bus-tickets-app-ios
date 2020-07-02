//
//  ViewController.swift
//  busapp
//
//  Created by Андрей on 31.08.17.
//  Copyright © 2017 Андрей. All rights reserved.
//

import UIKit
import PassKit
import Alamofire

class SearchViewController: UIViewController {
    
    @IBAction func dateButtonTap(_ sender: Any) {
        
        let urlString = "https://easyway24.ru/api/get-sale-days?from=\(fromID)&key=PoKznZwCStqCgyU7S8hUFkUPxJt6iXEloH8sNG9s"
        
        print(urlString)
        
        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                if let responseValue = response.result.value as? Int {
                    
                    self.dateMax = Calendar.current.date(byAdding: .day, value: responseValue, to: Date())!
                    self.daysAvailabilityNumber = responseValue
                    self.performSegue(withIdentifier: "segueVACalendar", sender: self)
                }else{
                    print(response.result.value!)
                    self.performSegue(withIdentifier: "segueVACalendar", sender: self)
                }
            }else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                
                self.performSegue(withIdentifier: "segueVACalendar", sender: self)
            }
        }
    }
    
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var toHeaderLabel: UILabel!
    @IBOutlet weak var fromHeaderLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBAction func fromButtonTap(_ sender: Any) {
        
        if !startPointsArray.isEmpty {
            performSegue(withIdentifier: "segueStartPointInput", sender: self)
        }
    }
    @IBAction func toButtonTap(_ sender: Any) {
        if fromID == "" {
            toButton.isEnabled = false
            spinnerGifView.isHidden = false
            toHeaderLabel.textColor = fromToUnselectedOpacityColor
            toLabel.textColor = fromToUnselectedOpacityColor
        }else{
            performSegue(withIdentifier: "segueEndPointInput", sender: nil)
        }
        
    }
    
    @IBOutlet weak var spinnerGifView: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    var startPointsArray = [pointStruct]()
    var endPointsArray = [pointStruct]()
    var daysAvailabilityNumber = 1
    var fromID = ""
    var toID = ""
    var dateString = ""
    var datePicked = Date.tomorrow
    var dateMax = Date.tomorrow
    var dateStringAPIFormat = ""
    let fromToDateHeaderColor = UIColor(red:65/255, green:65/255, blue:65/255, alpha:1.00)
    let fromToUnselectedColor = UIColor(red:179/255, green:179/255, blue:179/255, alpha:1.00)
    let searchButtonColor = UIColor(red:1, green:204/255.0, blue:0, alpha:1.00)
    let fromToButtonBorderColor = UIColor(red:217/255.0, green:217/255.0, blue:217/255.0, alpha:1.00)
    let fromToDateLabelColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:1.00)
    let fromToUnselectedOpacityColor = UIColor(red:179/255, green:179/255, blue:179/255, alpha:0.50)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getStartStations()
        //        toButton.isEnabled = false
        let spinnerGif = UIImage.gifImageWithName("spinner")
        spinnerGifView.image = spinnerGif
        fromHeaderLabel.textColor = fromToDateHeaderColor
        toHeaderLabel.textColor = fromToDateHeaderColor
        dateHeaderLabel.textColor = fromToDateHeaderColor
        fromLabel.textColor = fromToUnselectedColor
        toLabel.textColor = fromToUnselectedColor
        dateLabel.textColor = fromToDateLabelColor
        viewBackground.layer.cornerRadius = 10
        fromButton.backgroundColor = .clear
        fromButton.layer.cornerRadius = 6
        fromButton.layer.borderWidth = 1.0
        fromButton.layer.borderColor = fromToButtonBorderColor.cgColor
        
        
        toButton.layer.cornerRadius = 6
        toButton.layer.borderColor = fromToButtonBorderColor.cgColor
        toButton.layer.borderWidth = 1.0
        
        dateButton.layer.cornerRadius = 6
        dateButton.layer.borderColor = fromToButtonBorderColor.cgColor
        dateButton.layer.borderWidth = 1.0
        
        searchButton.layer.cornerRadius = 6
        searchButton.layer.backgroundColor = searchButtonColor.cgColor
        searchButton.layer.shadowRadius = 8
        searchButton.layer.shadowOffset = .zero
        searchButton.layer.shadowOpacity = 1
        searchButton.layer.shadowColor = searchButtonColor.cgColor
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"

        dateFormatter.locale = Locale.current
        dateLabel.text = "\(dateLabel.text!), \(dateFormatter.string(from: Date.tomorrow))"
        dateString = dateFormatter.string(from: Date.tomorrow)

        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateStringAPIFormat = dateFormatter.string(from: Date.tomorrow)
        
        let fromHeaderLabelAttributedText = NSMutableAttributedString(string: fromHeaderLabel.text!)
        fromHeaderLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.2), range: NSRange(location: 0, length: fromHeaderLabelAttributedText.length))
        fromHeaderLabel.attributedText = fromHeaderLabelAttributedText
        
        let toHeaderLabelAttributedText = NSMutableAttributedString(string: toHeaderLabel.text!)
        toHeaderLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.2), range: NSRange(location: 0, length: toHeaderLabelAttributedText.length))
        toHeaderLabel.attributedText = toHeaderLabelAttributedText
        
        let dateHeaderLabelAttributedText = NSMutableAttributedString(string: dateHeaderLabel.text!)
        dateHeaderLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.2), range: NSRange(location: 0, length: dateHeaderLabelAttributedText.length))
        dateHeaderLabel.attributedText = dateHeaderLabelAttributedText
        
        let searchButtonAttributedText = NSMutableAttributedString(string: searchButton.titleLabel!.text!)
        searchButtonAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2.0), range: NSRange(location: 0, length: searchButtonAttributedText.length))
        searchButton.setAttributedTitle(searchButtonAttributedText, for: .normal)
        
    }
    
    func getStartStations(){
        let urlString = "https://easyway24.ru/api/get-dispatch-stations?key=PoKznZwCStqCgyU7S8hUFkUPxJt6iXEloH8sNG9s"
        //            print(urlString)
        
        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        Alamofire.request(request).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                
                return
            }
            if let arrayOfItems = response.result.value as? [[String:AnyObject]]{
                for itm in arrayOfItems {
                    let item = pointStruct(
                        id:itm["id"] as! String,
                        name:itm["name"] as! String)
                    self.startPointsArray.append(item)
                }

            }else {
                print("Не могу перевести в массив")
                return
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueStartPointInput" {
            let vc = segue.destination as! FromViewController
            vc.listener = self
            vc.pointsArray = startPointsArray
            vc.filtered = startPointsArray
        }
        if segue.identifier == "segueEndPointInput" {
            let vc = segue.destination as! ToViewController
            vc.listener = self
            vc.fromID = self.fromID
            vc.pointsArray = endPointsArray
            vc.filtered = endPointsArray
        }
        if segue.identifier == "segueRoutes" {
            let vc = segue.destination as! RoutesViewController
            vc.listener = self
            vc.fromID = self.fromID
            vc.toID = self.toID
            vc.date = self.dateStringAPIFormat
            vc.dateLabelText = self.dateString
            vc.fromLabelText = fromLabel.text!
            vc.toLabelText = toLabel.text!
        }
        if segue.identifier == "segueVACalendar" {
            let vc = segue.destination as! VACalendarViewController
            vc.listener = self
            vc.fromID = self.fromID
            vc.date = self.datePicked
            vc.daysAvailabilityNumber = self.daysAvailabilityNumber
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func setTwoLineTitle(lineOne: String, lineTwo: String) -> UILabel {
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.black,
                               NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)] as [NSAttributedString.Key : Any]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)] as [NSAttributedString.Key : Any]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: lineOne, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: lineTwo, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        
        let width = size.width
        let height = CGFloat(44)
        
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        return titleLabel
    }
}

extension SearchViewController: VACalendarListener {
    
    
    func dateVAPicked(dateButtonTitle: String,dateStringAPIFormat: String,datePicked: Date, dateString: String) {
        self.dateString = dateString
        self.datePicked = datePicked
        self.dateStringAPIFormat = dateStringAPIFormat
        dateLabel.text = dateButtonTitle
    }
}
extension SearchViewController: FromListener {
    
    func fromPicked(fromID: String, fromName: String) {
        self.fromID = fromID
        fromLabel.text = fromName
        fromLabel.textColor = fromToDateLabelColor
        endPointsArray.removeAll()
        
        let urlString = "https://easyway24.ru/api/get-arrive-stations?from=\(fromID)&key=PoKznZwCStqCgyU7S8hUFkUPxJt6iXEloH8sNG9s"
        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        Alamofire.request(request).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                
                return
            }
            if let arrayOfItems = response.result.value as? [[String:AnyObject]]{
                for itm in arrayOfItems {
                    let item = pointStruct(
                        id:itm["id"] as! String,
                        name:itm["name"] as! String)
                    self.endPointsArray.append(item)
                }
                self.toButton.isEnabled = true
                self.toLabel.text = "Пункт прибытия"
                self.toLabel.textColor = self.fromToUnselectedColor
            }else {
                print("Не могу перевести в массив")
                return
            }
        }
    }
}

extension SearchViewController: ToListener {
    
    
    func toPicked(toID: String, toName: String) {
        self.toID = toID
        toLabel.text = toName
        toLabel.textColor = fromToDateLabelColor
        toHeaderLabel.textColor = fromToDateHeaderColor
        spinnerGifView.isHidden = true
        
    }
}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    static var tomorrow:  Date { return Date().dayAfter }
    static var yestoday:  Date { return Date().dayBefore }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var dayMaximum: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

