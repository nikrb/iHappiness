//
//  FaceView.swift
//  iHappiness
//
//  Created by Nick Scott on 29/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class FaceView: UIView {
    // by default rotating the view "scale to fill" will draw an ellipse :(
    // to stop the scale to fill, select view then change view attribute view mode to "redraw" from "scale to fill"
    // observe change to spark redraw
    var lineWidth: CGFloat = 3 { didSet{ setNeedsDisplay()}}
    var colour: UIColor = UIColor.blueColor() {didSet{ setNeedsDisplay()}}
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay()}}
    
    var faceCentre : CGPoint{
        // for a read only prop we don't need the get {}, just return 'only' get {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCentre, radius: faceRadius, startAngle: 0, endAngle: CGFloat( 2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        colour.set() // sets fill and stroke
        facePath.stroke()
    }
}
