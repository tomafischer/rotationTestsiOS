//
//  CameraController.swift
//  rotationTestsiOS
//
//  Created by tom on 5/15/19.
//  Copyright © 2019 aft3000. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

class CameraController : NSObject{
    var cameraView = UIView()
    var previewView = UIView()
    var previewLayer : CALayer!
    //root Layer is on the cameraView Layer to add items
    var rootLayer: CALayer! = nil
    
    var showVideoFeedInPreview = false
    //settings for camara Positions and Video quality
    private var cameraPosition = AVCaptureDevice.Position.back
    public var sessionVideoQuality = AVCaptureSession.Preset.hd1280x720
    
    //session variables
    private let session = AVCaptureSession()
    private var cameraLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var bufferSize: CGSize = .zero
    
    
    
    func setCameraViewSize(frame: CGRect){
        cameraView.frame = frame
    }
    func setSize(parentView: UIView){
        let frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height)
        //1) set size of CameraView
       setCameraViewSize(frame: frame)
        // 2) set size of rootlayer
        if (rootLayer != nil) {
            rootLayer.frame = frame
        }
        // 3) set AVCapture previewLayer
        if (cameraLayer != nil){
            cameraLayer.frame = frame
        
        }
    }
    
    func startCamera(cameraPosition: AVCaptureDevice.Position){
        self.cameraPosition = cameraPosition
        //1. check if camerea is running and shut it down
        
        //2. start camera with new settings
        setupAVCapture()
        session.startRunning()
    }
    
    func setupAVCapture(){
        // 1. Define the capture device we want to use
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) else {
            fatalError("No front video camera available")
        }
        
        session.beginConfiguration()
        session.sessionPreset = sessionVideoQuality// .vga640x480 // Model image size is smaller.
        
        //2. connect camera to capture input session
        do{
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            session.addInput(deviceInput)
        }catch{
            fatalError(error.localizedDescription)
        }
        
        //3. Adding output
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        //captureConnection?.videoOrientation = .portrait //// !!!!! Video Orientation set here!!!!!!!
        
        //4. Getting Buffer dimensions
        do {
            try  videoDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(videoDevice.activeFormat.formatDescription)
            bufferSize.width = CGFloat(dimensions.width)    ////BUFER SIZE set here!!!!
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        session.commitConfiguration()
        cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = cameraView.layer
        cameraLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(cameraLayer)
        
        previewLayer = previewView.layer
        previewLayer.contentsGravity = .resizeAspect
        
    }
    
    func showInPreview(image: CGImage){
        if (previewLayer != nil){
            previewLayer.sublayers = nil
            let layer = CALayer()
            layer.bounds = CGRect(x:0,y:0, width:  previewLayer.frame.width, height: previewLayer.frame.height)
            //layer.position = CGPoint(x:layer.bounds.midX,y: layer.bounds.midY)
            layer.contents = image
            layer.contentsGravity = .resizeAspect
            previewLayer.addSublayer(layer)
        }
    }
}
// MARK: - Capturing video output and feeding the Vision pipline
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    //Caputre out put from video stream
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
//        if frameCount % skippedFrames == 0{
//            frameCount = 1
//            return
//        }
        //frameCount += 1
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { //CMSSampleBuffer
            return
        }
        let ciBuffer = CIImage(cvImageBuffer: pixelBuffer)
        let bufferHeight = CVPixelBufferGetWidth(pixelBuffer)
        let bufferWidth = CVPixelBufferGetHeight(pixelBuffer)
        print("bixelBufer WxH: ", bufferWidth, bufferHeight," bufferSize WxH: ")//, bufferSize.width, bufferSize.height)
        
        if (showVideoFeedInPreview){
            showInPreview(image: ImageTools.convertCIImageToCGImage(ciImage: ciBuffer)!)
        }
//        //let exifOrientation = exifOrientationFromDeviceOrientation()
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientationVNImageRequestHandler(), options: [:])
//
//        do {
//            let detectFaceRequest = VNDetectFaceRectanglesRequest{ request, error in
//                //using a closure to access the pixelBuffer
//                self.faceDetectedCompleteionHandler(request: request, error: error, from: pixelBuffer)
//
//            }
//
//            // try imageRequestHandler.perform(self.requests)
//            try imageRequestHandler.perform([detectFaceRequest])
//        } catch {
//            print(error)
      }
}


