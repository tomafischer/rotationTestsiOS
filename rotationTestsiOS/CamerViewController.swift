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
    public var cameraController = CameraController()
   
    //https://stackoverflow.com/questions/25666269/how-to-detect-orientation-change/36512415
//    var didRotate: (Notification) -> Void = { notification in
//
//        //        switch UIDevice.current.orientation {
//        //        case .landscapeLeft, .landscapeRight:
//        //            print("landscape")
//        //        case .portrait, .portraitUpsideDown:
//        //            print("Portrait")
//        //        default:
//        //            print("other")
//        //        }
//    }
    func rotated(_ notification: Notification ){
        print("rotating now")
        UIView.animate(withDuration: 0.3) {
           // self.cameraController.rotateViewBasedOnDeviceOrientation(view: self.previewView)
        }
        
    }
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
   
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                               object: nil,
                                               queue: .main,
                                               using: rotated)
    }
    override func viewLayoutMarginsDidChange() {
        print("layout changed")
        cameraController.setSize(parentView: view)
        cameraController.stopCamera()
        cameraController.startCamera(cameraPosition: .back)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    override open var shouldAutorotate: Bool {
        return false
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        print("safeAreaInsets: \(view.safeAreaInsets)")
        //additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -34, right: 0)
       // cameraView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            if UIDevice.current.orientation.isFlat {
//                print("Flat")
//            } else {
//                print("Portrait")
//            }
//        }
//    }
}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }}
