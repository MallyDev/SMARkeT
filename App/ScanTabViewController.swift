//
//  ScanTabViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import FirebaseDatabase
import Firebase

struct AppUtility {
    
    // This method will force you to use base on how you configure.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    // This method done pretty well where we can use this for best user experience.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

class ScanTabViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var prod : [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: NSLocalizedString("Scanning not supported",comment: ""), message: NSLocalizedString("Your device does not support scanning a code from an item.",comment: ""), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue);
            find(barCode: readableObject.stringValue)
        }
        
        //dismiss(animated: true)   deve stare commentata, altrimenti scompare il popUp
    }
    
    func found(code: String) {
        print("Codice trovato: ",code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //funzione per cercare il prodotto in Firebase
    func find(barCode: String){
        /*let ref = FIRDatabase.database().reference()
        let item = ref.child("Prodotti")
        
        item.child(barCode).observeSingleEvent(of: .value, with: {(snap) in
            print(snap)
            let product_read = snap.value as! NSDictionary?
            
            if(product_read != nil){
            self.prod = PersistenceManager.newEmptyProd()
            self.prod.barCode = barCode
            self.prod.name = product_read!.value(forKey: "name") as! String?
            self.prod.department = product_read!.value(forKey: "department") as! String?
            self.prod.descr = product_read!.value(forKey: "descr") as! String?
            self.prod.price = product_read!.value(forKey: "price") as! Float
            self.prod.imageUrl = product_read!.value(forKey: "url") as! String?
            print(self.prod)
            }else{
                
            }
        })*/
        
        let result = PersistenceManager.searchProduct(barcode: barCode)
        
        if  result.1 {
            prod = result.0
            showPopup(product: prod[0])
        } else {
            showAlert()
        }
    }
    
    func showPopup(product: Product){
        
        let popUp = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.present(popUp, animated: true, completion: nil)
        
        popUp.addAction(UIAlertAction(title: "Shopping List", style: UIAlertActionStyle.default, handler:{(paramAction: UIAlertAction!) in
            //aggiungere il prodotto nell'array di shopping list
            product.inTheList = true
            product.quantity = 1
            PersistenceManager.saveContext()
            //far comparire la view di shopping list
            self.tabBarController?.selectedIndex = 0
            self.performSegue(withIdentifier: "ScanToShopp", sender: self)
            //far scomparire la view di scanner
            self.dismiss(animated: true, completion: nil)
        }))
        
        popUp.addAction(UIAlertAction(title: NSLocalizedString("Favourite",comment: ""), style: UIAlertActionStyle.default, handler:
            {(paramAction: UIAlertAction!) in
                product.favourite = true
                PersistenceManager.saveContext()
                //far comparire la view dei Favourites
                self.tabBarController?.selectedIndex = 3
                self.performSegue(withIdentifier: "ScanToFav", sender: self)
                //far scomparire la ScannerView
                self.dismiss(animated: true, completion: nil)
        }))
        
        popUp.addAction(UIAlertAction(title: "View Item", style: UIAlertActionStyle.default, handler:
            {(paramAction: UIAlertAction!) in
                PersistenceManager.saveContext()
                //far comparire la view dei Favourites
                self.performSegue(withIdentifier: "ScanToDetail", sender: self)
                //far scomparire la ScannerView
                self.dismiss(animated: true, completion: nil)
        }))

        
        popUp.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler:
            {(paramAction: UIAlertAction!) in
                self.viewDidLoad()
        }))
    }
    
    func showAlert() {
        let popUp = UIAlertController(title: "ERROR", message: "Product not in database", preferredStyle: .alert)
        self.present(popUp,animated: true,completion: nil)
        popUp.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment: ""), style: UIAlertActionStyle.default, handler:
            {(paramAction: UIAlertAction!) in
                self.viewDidLoad()
        }))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   
        if segue.identifier == "ScanToDetail" {
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title = prod[0].name!
            dstView.item = prod[0]
            }
    }
}
