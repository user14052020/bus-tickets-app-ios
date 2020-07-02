//
//  StartPointInputViewController.swift
//  busapp
//
//  Created by Vadim Maharram on 18.03.2020.
//  Copyright © 2020 Андрей. All rights reserved.
//



import UIKit
import PassKit
import Alamofire
import SafariServices
import QuartzCore

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    let gradient = CAGradientLayer()
    var fromID = ""
    var toID = ""
    var date = ""
    var fromLabelText = ""
    var toLabelText = ""
    var dateLabelText = ""
    var isShimmer = true
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var firstPointPentagonView: UIView!
    
    @IBOutlet weak var fourthPointLabel: UILabel!
    @IBOutlet weak var fourthPointFooterLabel: UILabel!
    @IBOutlet weak var firstPointLabel: UILabel!
    @IBOutlet weak var firstPointFooterLabel: UILabel!
    @IBAction func backButtonTap(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }
    @IBOutlet weak var routesTableView: UITableView!
    public var listener: ToListener?
    var routesArray = [routeStruct]()
    var routesArrayTemp = [routeStruct]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.gradient.frame = CGRect(x:0, y:0, width:loaderView.bounds.size.width, height:loaderView.bounds.size.height)
        self.gradient.colors = [UIColor.white.cgColor,
                                UIColor(red:255/255, green:204/255, blue:0, alpha:1).cgColor,
                                UIColor.white.cgColor]
        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.gradient.locations = [0,1]
        
        loaderView.layer.insertSublayer(self.gradient, at: 0)
        animationOfView()
        
        
        var a = 0
        while a < 6 {
            let item = routeStruct(
                onSale: false,
                buyUrl:"" ,
                bus:"" ,
                freePlaces:0,
                places:0,
                price:0,
                dispatchTime:"",
                arriveTime:"" ,
                minutesInRoad:0)
            self.routesArray.append(item)
            a = a + 1
        }
        routesTableView.reloadData()
        
        fromLabel.text = fromLabelText
        toLabel.text = toLabelText
        dateLabel.text = dateLabelText
        
        setupHeaderPoints()
        makePostRequest()
        
        
        
        
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            
        self.dismiss(animated: true, completion: nil)
       }
       else if gesture.direction == .left {
            print("Swipe Left")
       }
       else if gesture.direction == .up {
            print("Swipe Up")
       }
       else if gesture.direction == .down {
            print("Swipe Down")
       }
    }
    
    func animationOfView(){
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-0.5,-0.25,0]
        gradientAnimation.toValue = [1.0,1.25,1.5]
        gradientAnimation.duration = 5.0
        gradientAnimation.speed = 5
        //        gradientAnimation.autoreverses = true
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.repeatCount = Float.infinity
        self.gradient.add(gradientAnimation, forKey: "shimmerKey")
    }
    
    
    fileprivate func makePostRequest() {
        let urlString = "https://easyway24.ru/api/get-routes?from=\(fromID)&to=\(toID)&date=\(date)&key=PoKznZwCStqCgyU7S8hUFkUPxJt6iXEloH8sNG9s"
        print(urlString)
        
        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
//        urlString, method: .get,encoding: URLEncoding.httpBody
        Alamofire.request(request).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                
                return
            }
            if let arrayOfItems = response.result.value as? [[String:AnyObject]]{
                self.routesArray.removeAll()
                for itm in arrayOfItems {
//                    print(itm["onSale"])
                    let item = routeStruct(
                        onSale:itm["onSale"] as? Bool ?? false,
                        buyUrl:itm["buyUrl"] as? String ?? "",
                        bus:itm["bus"] as? String ?? "",
                        freePlaces:itm["freePlaces"] as? Int ?? 0,
                        places:itm["places"] as? Int ?? 0,
                        price:itm["price"] as? Int ?? 0,
                        dispatchTime:itm["dispatchTime"] as? String ?? "",
                        arriveTime:itm["arriveTime"] as? String ?? "",
                        minutesInRoad:itm["minutesInRoad"] as? Int ?? 0)
                    self.routesArray.append(item)
                }
                self.isShimmer = false
                self.gradient.removeFromSuperlayer()
                self.loaderView.isHidden = true
                self.routesTableView.reloadData()
            }else {
                print("Не могу перевести в массив")
                return
            }
        }
    }
    
    func setupHeaderPoints() {
        let secondHeaderLabelTextColor = UIColor(red:115/255, green:115/255, blue:115/255, alpha:0.40)
        let thrirdHeaderLabelTextColor = UIColor(red:115/255, green:115/255, blue:115/255, alpha:0.30)
        let fourthHeaderLabelTextColor = UIColor(red:115/255, green:115/255, blue:115/255, alpha:0.20)
        let backgroundColor = UIColor(red:249/255, green:249/255, blue:249/255, alpha:0.20)
        let pg = PentagonView(frame:CGRect(x:0, y:0, width:80, height:50))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = pointsView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, backgroundColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        pointsView.layer.insertSublayer(gradientLayer, at: 0)
        
        firstPointPentagonView.addSubview(pg)
        
        firstPointLabel.layer.cornerRadius = 0.5 * firstPointLabel.bounds.size.width
        firstPointLabel.layer.borderWidth = 1.0
        firstPointLabel.layer.borderColor = UIColor.black.cgColor
        
        let firstPointLabelFrame: CGRect = firstPointLabel.frame
        let spaceFree = view.frame.size.width/3.8
        let secondPointLabel = UILabel()
        secondPointLabel.frame = CGRect(x: firstPointLabelFrame.origin.x  + spaceFree, y: firstPointLabel.bounds.origin.y + 7,width: firstPointLabel.bounds.size.width,height: firstPointLabel.bounds.size.height)
        secondPointLabel.text = "2"
        secondPointLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
        secondPointLabel.textColor = secondHeaderLabelTextColor
        secondPointLabel.textAlignment = .center
        secondPointLabel.layer.cornerRadius = 0.5 * firstPointLabel.bounds.size.width
        secondPointLabel.layer.borderWidth = 1.0
        secondPointLabel.layer.borderColor = secondHeaderLabelTextColor.cgColor
        
        let secondPointFooterLabel = UILabel()
        secondPointFooterLabel.font = UIFont(name:"HelveticaNeue", size: 11.0)
        secondPointFooterLabel.text = Locale.current.languageCode! != "ru" ? "passengers" : "пассажиры"
        secondPointFooterLabel.textColor = secondHeaderLabelTextColor
        secondPointFooterLabel.textAlignment = .center
        secondPointFooterLabel.frame = CGRect(x: firstPointLabelFrame.origin.x  + spaceFree - secondPointFooterLabel.intrinsicContentSize.width/3, y: firstPointLabel.bounds.origin.y + 33,width: 61,height: 12)
        
        pointsView.addSubview(secondPointLabel)
        pointsView.addSubview(secondPointFooterLabel)
        
        let thirdPointLabel = UILabel()
        thirdPointLabel.frame = CGRect(x: firstPointLabelFrame.origin.x  + spaceFree + spaceFree, y: firstPointLabel.bounds.origin.y + 7,width: firstPointLabel.bounds.size.width,height: firstPointLabel.bounds.size.height)
        thirdPointLabel.text = "3"
        thirdPointLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
        thirdPointLabel.textColor = thrirdHeaderLabelTextColor
        thirdPointLabel.textAlignment = .center
        thirdPointLabel.layer.cornerRadius = 0.5 * firstPointLabel.bounds.size.width
        thirdPointLabel.layer.borderWidth = 1.0
        thirdPointLabel.layer.borderColor = thrirdHeaderLabelTextColor.cgColor
        
        let thirdPointFooterLabel = UILabel()
        
        thirdPointFooterLabel.font = UIFont(name:"HelveticaNeue", size: 11.0)
        thirdPointFooterLabel.text = Locale.current.languageCode! != "ru" ? "charge" : "оплата"
        thirdPointFooterLabel.textColor = thrirdHeaderLabelTextColor
        thirdPointFooterLabel.textAlignment = .center
        thirdPointFooterLabel.frame = CGRect(x: firstPointLabelFrame.origin.x + spaceFree + spaceFree - thirdPointFooterLabel.intrinsicContentSize.width/5.5, y: firstPointLabel.bounds.origin.y + 33,width:37,height: 12)
        
        pointsView.addSubview(thirdPointLabel)
        pointsView.addSubview(thirdPointFooterLabel)
        
        let firstPointFooterLabelAttributedText = NSMutableAttributedString(string: firstPointFooterLabel.text!)
        firstPointFooterLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.15), range: NSRange(location: 0, length: firstPointFooterLabelAttributedText.length))
        firstPointFooterLabel.attributedText = firstPointFooterLabelAttributedText
        
        let secondPointFooterLabelAttributedText = NSMutableAttributedString(string: secondPointFooterLabel.text!)
        secondPointFooterLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.15), range: NSRange(location: 0, length: secondPointFooterLabelAttributedText.length))
        secondPointFooterLabel.attributedText = secondPointFooterLabelAttributedText
        
        let thirdPointFooterLabelAttributedText = NSMutableAttributedString(string: thirdPointFooterLabel.text!)
        thirdPointFooterLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.15), range: NSRange(location: 0, length: thirdPointFooterLabelAttributedText.length))
        thirdPointFooterLabel.attributedText = thirdPointFooterLabelAttributedText
        
        let fourthPointFooterLabelAttributedText = NSMutableAttributedString(string: fourthPointFooterLabel.text!)
        fourthPointFooterLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.15), range: NSRange(location: 0, length: fourthPointFooterLabelAttributedText.length))
        fourthPointFooterLabel.attributedText = fourthPointFooterLabelAttributedText
        
        fourthPointLabel.layer.cornerRadius = 0.5 * firstPointLabel.bounds.size.width
        fourthPointLabel.layer.borderWidth = 1.0
        fourthPointLabel.layer.borderColor = fourthHeaderLabelTextColor.cgColor
        fourthPointLabel.textColor = fourthHeaderLabelTextColor
        fourthPointFooterLabel.textColor = fourthHeaderLabelTextColor
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as! RoutesTableViewCell
        cell.configure(isShimmer: isShimmer)
        var item = routesArray[indexPath.row]
        
        if isShimmer {
            item = routesArray[indexPath.row]
        }
        if item.price != 0 {
            cell.price.text = "\(String(item.price)) ₽"
        }else{
            cell.price.text = ""
        }
        
        cell.busModel.text = item.bus
        cell.startName.text = fromLabelText
        cell.endName.text = toLabelText
        cell.dispatchTime.text = item.dispatchTime
        cell.arriveTime.text = item.arriveTime
        if item.arriveTime == "–"{
            cell.arriveTime.text = "..."
        }
        else{
            cell.arriveTime.text = item.arriveTime
            
        }
        if item.minutesInRoad != 0 {
            let tuple = minutesToHoursMinutes(minutes: item.minutesInRoad)
            
            cell.timeRoad.text = "\(String(tuple.hours)) ч \(String(tuple.leftMinutes)) м"
        }else{
            cell.timeRoad.text = ""
        }
        
        if item.places != 0 {
           cell.capacity.text = Locale.current.languageCode! != "ru" ? "\(String(item.freePlaces)) out of \(String(item.places)) places left" : "Осталось \(String(item.freePlaces)) из \(String(item.places)) мест"
        }else{
            cell.capacity.text = ""
        }
        if !item.onSale{
            cell.buyBackground.backgroundColor = UIColor(red:207/255, green:207/255, blue:207/255, alpha:0.30)
            cell.buyTicketLabel.textColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:0.30)
            cell.price.textColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:0.30)
            cell.ticketIcon.image = UIImage(named: "ticket-disable-icon")
        }else{
           cell.buyBackground.backgroundColor = UIColor(red:255/255, green:204/255, blue:0, alpha:1.00)
            cell.price.textColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:1.00)
            cell.ticketIcon.image = UIImage(named: "ticket-icon")
            cell.buyTicketLabel.textColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:1.00)
        }
        if item.bus == ""{
            cell.busPng.isHidden = true
        } else{
            cell.busPng.isHidden = false
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexpath = routesArray[indexPath.row]
        if indexpath.onSale {
            
            let safariVC = SFSafariViewController(url: NSURL(string:indexpath.buyUrl)! as URL)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }else{
            return
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

struct routeStruct {
    let onSale: Bool
    let buyUrl: String
    let bus: String
    let freePlaces: Int
    let places: Int
    let price: Int
    let dispatchTime: String
    let arriveTime: String
    let minutesInRoad: Int
}


