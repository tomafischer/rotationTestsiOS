//
//  CamerViewController.swift
//  rotationTestsiOS
//
//  Created by tom on 5/15/19.
//  Copyright © 2019 aft3000. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class CameraViewController: UIViewController {
    let cameraController = CameraController()
   
    
   
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    var boundsObservation: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Camera Tests"
        cameraController.cameraView = cameraView
        cameraController.previewView = previewView
        cameraController.showVideoFeedInPreview = true
        
        cameraController.setSize(parentView: view)
        cameraController.startCamera(cameraPosition: .back)
   
        
    }
    override func viewLayoutMarginsDidChange() {
        print("layout changed")
        cameraController.setSize(parentView: view)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
   
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        print("safeAreaInsets: \(view.safeAreaInsets)")
        //additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -34, right: 0)
       // cameraView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
}
