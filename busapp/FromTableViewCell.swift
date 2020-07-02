//
//  FromTableViewCell.swift
//  busapp
//
//  Created by Vadim Maharram on 18.03.2020.
//  Copyright © 2020 Андрей. All rights reserved.
//

import Foundation
import UIKit

class FromTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
