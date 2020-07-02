//
//  FromTableViewCell.swift
//  busapp
//
//  Created by Vadim Maharram on 18.03.2020.
//  Copyright © 2020 Андрей. All rights reserved.
//

import Foundation
import UIKit

class RoutesTableViewCell: UITableViewCell {
    let gradient = CAGradientLayer()
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var buyTicketLabel: UILabel!
    @IBOutlet weak var busPng: UIImageView!
    @IBOutlet weak var buyBackground: UILabel!
    @IBOutlet weak var timeRoad: UILabel!
    @IBOutlet weak var dispatchTime: UILabel!
    @IBOutlet weak var startName: UILabel!
    
    @IBOutlet weak var endName: UILabel!
    @IBOutlet weak var arriveTime: UILabel!
    @IBOutlet weak var busModel: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var ticketIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.cellBackgroundView.layer.cornerRadius = 8
        self.cellBackgroundView.layer.borderWidth = 1.0
        self.cellBackgroundView.layer.borderColor = UIColor.white.cgColor
        
        self.cellBackgroundView.layer.shadowOpacity = 1 // opacity, 20%
        self.cellBackgroundView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.08).cgColor
        self.cellBackgroundView.layer.shadowRadius = 2 // HALF of blur
        self.cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2) // Spread x, y
        self.cellBackgroundView.layer.masksToBounds = false
        self.buyBackground.layer.cornerRadius = 6
        self.buyBackground.layer.masksToBounds = true
        
        let capacityAttributedText = NSMutableAttributedString(string: self.capacity.text!)
        capacityAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.17), range: NSRange(location: 0, length: capacityAttributedText.length))
        self.capacity.attributedText = capacityAttributedText
        
        let busModelAttributedText = NSMutableAttributedString(string: self.busModel.text!)
        busModelAttributedText.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.17), range: NSRange(location: 0, length: busModelAttributedText.length))
        self.busModel.attributedText = busModelAttributedText
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func configure(isShimmer: Bool) {
        
        if isShimmer{
            let bgImageView =  UIView()
            bgImageView.tag = 100
            bgImageView.backgroundColor = .white
            bgImageView.layer.cornerRadius = 8
            bgImageView.contentMode = .scaleAspectFill
            bgImageView.frame = CGRect(x:0, y:0, width:self.bounds.size.width-20, height:self.cellBackgroundView.bounds.size.height)
            self.cellBackgroundView.addSubview(bgImageView)
            self.gradient.cornerRadius = 8
            self.gradient.frame = CGRect(x:0, y:0, width:self.bounds.size.width-20, height:self.cellBackgroundView.bounds.size.height)
            self.gradient.colors = [UIColor.white.cgColor,
                                    UIColor(red:232/255, green:232/255, blue:232/255, alpha:1).cgColor,
                                    UIColor.white.cgColor]
            self.gradient.startPoint = CGPoint(x: 0, y: 0)
            self.gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            self.gradient.locations = [0,1]
            bgImageView.layer.insertSublayer(self.gradient, at: 0)
            animationOfView()
        }else{
            self.gradient.removeFromSuperlayer ()
            if let viewWithTag = self.cellBackgroundView.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    func animationOfView(){
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-0.5,-0.25,0]
        gradientAnimation.toValue = [1.0,1.25,1.5]
        gradientAnimation.duration = 5.0
        gradientAnimation.speed = 5
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.repeatCount = Float.infinity
        self.gradient.add(gradientAnimation, forKey: "shimmerKey")
    }
}
