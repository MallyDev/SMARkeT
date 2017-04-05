//
//  ItemDetailViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailViewController: UIViewController {
    
    var item : Product?
    var favouriteButton : UIBarButtonItem?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 10
        if (item?.favourite)! {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector (addFavourite))
        } else {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star-2.png"), style: .plain, target: self, action: #selector (addFavourite))
        }
        
        self.navigationItem.rightBarButtonItem = favouriteButton
        // Do any additional setup after loading the view.
        self.title=item?.name
        self.quantityLabel.text = "\(item!.quantity)"
        self.descript.text = item!.descr
        self.departmentLabel.text = item!.department!
        if item!.newPrice <= 0{
            self.priceLabel.text = "\(item!.price) €"
        }else{
            self.priceLabel.text = "\(item!.price) €"
            self.priceLabel.textColor = UIColor.red
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  self.priceLabel.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
             self.priceLabel.attributedText = attributeString
            
            self.newPriceLabel.text = "\(item!.newPrice) €"
            
        }
        
        if (item?.inTheList)! {
            
            addButton.setTitle(NSLocalizedString("Remove from List",comment:""), for: .normal)
            addButton.backgroundColor = UIColor.init(red: 255/255, green: 192/255, blue: 19/255, alpha: 1.0)
        } else {
            addButton.setTitle( NSLocalizedString("Add to List",comment:""), for: .normal)
            addButton.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
        stepper.value = Double((item?.quantity)!)
        
        //carico l'immagine
        let u: String? = item?.imageUrl
        let url = URL(string: u!)
        print(url!)
        let request = URLRequest(url: url! as URL)
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        /*
         if cell.departmentLabel.text == "Reparto"{
         cell.imgView.image = #imageLiteral(resourceName: "fruit-default.png")
         cell.imgView.backgroundColor = UIColor.white
         }*/
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error as NSError?)
            
            if case var .success(image) = result {
                self.imgView.backgroundColor = UIColor.white
                image = self.resizeImage(image: image, targetSize: CGSize(width:250,height:250))
                self.imgView.image = image
            }
        })
        task.resume()
        
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descript.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func addFavourite () {
        item?.favourite = !(item?.favourite)!
        if (item?.favourite)! {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector (addFavourite))
        } else {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star-2.png"), style: .plain, target: self, action: #selector (addFavourite))
        }
        self.navigationItem.rightBarButtonItem = favouriteButton
        PersistenceManager.saveContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertIntoList(_ sender: UIButton) {
        item?.inTheList = !(item?.inTheList)!
        if (item?.inTheList)! {
            sender.setTitle(NSLocalizedString("Remove from List",comment:""), for: .normal)
            item?.quantity = 1
            sender.backgroundColor = UIColor.init(red: 255/255, green: 192/255, blue: 19/255, alpha: 1.0)
        } else {
            sender.setTitle(NSLocalizedString("Add to List",comment:""), for: .normal)
            item?.quantity = 0
            sender.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
        quantityLabel.text = "\(item!.quantity)"
        PersistenceManager.saveContext()
    }
    
    @IBAction func modifyQuantity(_ sender: UIStepper) {
        item?.quantity = Int32(sender.value)
        quantityLabel.text = "\(Int32(sender.value))"
        PersistenceManager.saveContext()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func processImageRequest(data: Data?, error: NSError?) -> ImageResult {
        
        guard let
            imageData = data,
            let image2 = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image2)
    }
    
}
