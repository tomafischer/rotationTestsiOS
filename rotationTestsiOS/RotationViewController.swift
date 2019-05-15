//
//  ViewController.swift
//  rotationTestsiOS
//
//  Created by Fischer, Thomas Alfons on 5/14/19.
//  Copyright © 2019 aft3000. All rights reserved.
//

import UIKit
import CoreGraphics

class RotationViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Rotation Tests"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mirrorX(_ sender: Any)  {
        let transform = ImageTools.mirrorHorizontal()
        applyTransformation(transformation: transform)
    }
    @IBAction func mirrorY(_ sender: Any) {
        var transform = ImageTools.mirrorVertical()
        //transform = transform.rotated(by: -CGFloat.pi/2)
        applyTransformation(transformation: transform)
    
    }
    
    @IBAction func rotate180(_ sender: Any) {
        applyTransformation(transformation: ImageTools.rotate180())
    }
    @IBAction func rotateRight(_ sender: Any) {
        applyTransformation(transformation: ImageTools.rotateRight())
    }
    @IBAction func rotateLeft(_ sender: Any) {
        //        if imgView.transform {
        //            imgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        //        }else{
        //
        //        }
        let transfrom = ImageTools.rotateLeft()
        applyTransformation(transformation: transfrom)
        //imgView.transform = imgView.transform.rotated(by: -CGFloat.pi/2)
        print(imgView.transform)
        
    }
    
    func applyTransformation(transformation: CGAffineTransform){
        let img = CIImage(image: imgView.image!)
        
        let startTS = DispatchTime.now()
        let finalImg = ImageTools.convertCIImageToCGImage(ciImage: img!.transformed(by: transformation))
        let endTS = DispatchTime.now()
        let diff = TimeTools.diff(start: startTS, end: endTS)
        print("Elapsed: \(diff)")
        
        
        imgView.image = UIImage(cgImage: finalImg!)
        //imgView.transform = imgView.transform.rotated(by: -CGFloat.pi/2)
    }
    
    
}

