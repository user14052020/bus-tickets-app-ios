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


protocol ToListener {
    func toPicked(toID: String, toName: String)
}

class ToViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let fromToDateHeaderColor = UIColor(red:65/255, green:65/255, blue:65/255, alpha:1.00)
    let fromToUnselectedColor = UIColor(red:179/255, green:179/255, blue:179/255, alpha:1.00)
    let fromToDateLabelColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:1.00)
    var fromID = ""
    @IBOutlet weak var toInputView: UIView!
    @IBAction func closeButtonTap(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var toHeaderLabel: UILabel!
    @IBOutlet weak var toTableView: UITableView!
    public var listener: ToListener?
    var pointsArray = [pointStruct]()
    var filtered = [pointStruct]()
    
    @IBOutlet weak var toInput: UITextField!
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            self.filtered = self.pointsArray
        }else{
            toInput.textColor = fromToDateLabelColor
            let searchText = textField.text?.lowercased()
            let filtered = pointsArray.filter({ $0.name.lowercased().contains(searchText!) })
            self.filtered = filtered
        }

        self.toTableView.reloadData()

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        toHeaderLabel.textColor = fromToDateHeaderColor
        toInput.textColor = fromToUnselectedColor
        toInputView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        toInputView.layer.shadowOpacity = 1
        toInputView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.08).cgColor
        
        toInput.addTarget(self, action: #selector(ToViewController.textFieldDidChange(_:)),
                                   for: .editingChanged)
        
        let toHeaderLabelAttributedText = NSMutableAttributedString(string: toHeaderLabel.text!)
        toHeaderLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: toHeaderLabelAttributedText.length))
        toHeaderLabel.attributedText = toHeaderLabelAttributedText
        
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ FromTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ FromTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FromTableView.dequeueReusableCell(withIdentifier: "fromCell", for: indexPath) as! FromTableViewCell
        
        let item = filtered[indexPath.row]
        cell.idLabel.text = item.id
        cell.nameLabel.text = item.name
        return cell
    }
    
    func tableView(_ FromTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexpath = filtered[indexPath.row]
        listener?.toPicked(toID: indexpath.id, toName: indexpath.name)
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}


