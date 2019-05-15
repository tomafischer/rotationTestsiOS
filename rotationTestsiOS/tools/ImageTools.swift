//
//  ImageTools.swift
//  rotationTestsiOS
//
//  Created by tom on 5/15/19.
//  Copyright © 2019 aft3000. All rights reserved.
//

import UIKit
//import AVFoundation
//import Vision


class ImageTools{
    static func convertCIImageToCGImage(ciImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    // -
    static func mirrorHorizontal() -> CGAffineTransform{
        let transformation = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return transformation
    }
    
    static func mirrorVertical() -> CGAffineTransform{
        return CGAffineTransform(scaleX: 1.0, y: -1.0)
    }
    
    static func rotateLeft()-> CGAffineTransform{
        let transfrom = CGAffineTransform(rotationAngle:  CGFloat.pi/2)
        return transfrom
    }
    static func rotateRight()-> CGAffineTransform{
        let transfrom = CGAffineTransform(rotationAngle:  -CGFloat.pi/2)
        return transfrom
    }
    static func rotate180()-> CGAffineTransform{
        let transfrom = CGAffineTransform(rotationAngle:  CGFloat.pi)
        return transfrom
    }
}
