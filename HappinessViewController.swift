//
//  HappinessViewController.swift
//  iHappiness
//
//  Created by Nick Scott on 29/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
        }
    }
    
    var happiness: Int = 100 { // 0= very sad, 100- ecstatic
        didSet{
            happiness = min( max( happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    private func updateUI(){
        faceView.setNeedsDisplay()
    }
    // implement protocol (interpret model for the view)
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
}
