//
//  PentagonView.swift
//  busapp
//
//  Created by Vadim Maharram on 26.03.2020.
//  Copyright © 2020 Андрей. All rights reserved.
//

import Foundation
import SwiftUI

class PentagonView : UIView {
    let searchButtonColor = UIColor(red:1, green:204/255.0, blue:0, alpha:1.00)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let h = 10 
        let p1 = self.bounds.origin

        let p2 = CGPoint(x:p1.x + size.width - CGFloat(h), y:p1.y)
        let p4 = CGPoint(x:p2.x, y:p2.y + size.height)
        let p3 = CGPoint(x:p2.x + CGFloat(h), y:size.height/2)
        let p5 = CGPoint(x:p1.x, y:p4.y)

        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.addLine(to: p5)
        path.close()

        // fill the path
        searchButtonColor.set()
        path.fill()
    }
}
