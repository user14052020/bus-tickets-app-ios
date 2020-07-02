//
//  FromViewController.swift
//  busapp
//
//  Created by Vadim Maharram on 18.03.2020.
//  Copyright © 2020 Андрей. All rights reserved.
//



import UIKit
import PassKit



protocol FromListener {
    func fromPicked(fromID: String, fromName: String)
}

class FromViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let fromToDateHeaderColor = UIColor(red:65/255, green:65/255, blue:65/255, alpha:1.00)
    let fromToUnselectedColor = UIColor(red:179/255, green:179/255, blue:179/255, alpha:1.00)
    let fromToDateLabelColor = UIColor(red:40/255, green:40/255, blue:40/255, alpha:1.00)
    @IBOutlet weak var fromHeaderLabel: UILabel!
    @IBOutlet weak var fromInput: UITextField!
    @IBOutlet weak var fromInputView: UIView!
    @IBAction func closeButtonTap(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var fromTableView: UITableView!
    public var listener: FromListener?
    var pointsArray = [pointStruct]()
    var filtered = [pointStruct]()
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            self.filtered = self.pointsArray
        }else{
            fromInput.textColor = fromToDateLabelColor
            let searchText = textField.text?.lowercased()
            let filtered = pointsArray.filter({ $0.name.lowercased().contains(searchText!) })
            self.filtered = filtered
        }
        
        self.fromTableView.reloadData()
        
    }
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
        
        fromInputView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        fromInputView.layer.shadowOpacity = 1
        fromInputView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.08).cgColor
        fromHeaderLabel.textColor = fromToDateHeaderColor
        fromInput.textColor = fromToUnselectedColor
        fromInput.addTarget(self, action: #selector(FromViewController.textFieldDidChange(_:)),
                                   for: .editingChanged)
        let fromHeaderLabelAttributedText = NSMutableAttributedString(string: fromHeaderLabel.text!)
        fromHeaderLabelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: fromHeaderLabelAttributedText.length))
        fromHeaderLabel.attributedText = fromHeaderLabelAttributedText
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ TableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "fromCell", for: indexPath) as! FromTableViewCell
        
        let item = filtered[indexPath.row]
        
        cell.idLabel.text = item.id
        cell.nameLabel.text = item.name
        
        return cell
        
    }
    
    func tableView(_ TableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexpath = filtered[indexPath.row]
        listener?.fromPicked(fromID: indexpath.id, fromName: indexpath.name)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
//структура для вывода на ячейки
struct pointStruct {
    let id: String
    let name: String
    
}



