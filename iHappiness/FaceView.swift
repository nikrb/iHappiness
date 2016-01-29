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
    
    private enum Eye { case Left, Right }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private func bezierPathForEye( whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCentre = faceCentre
        eyeCentre.y -= eyeVerticalOffset
        switch whichEye{
        case .Left: eyeCentre.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCentre.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCentre, radius: eyeRadius, startAngle: 0, endAngle: CGFloat( 2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile( fractionOfMaxSmile: Double) -> UIBezierPath{
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat( max( min( fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint( x: faceCentre.x - mouthWidth / 2, y: faceCentre.y + mouthVerticalOffset)
        let end = CGPoint( x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint( x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint( x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCentre, radius: faceRadius, startAngle: 0, endAngle: CGFloat( 2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        colour.set() // sets fill and stroke
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness = -0.5
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
}
