//
//  AppDelegate.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import BRYXBanner




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    var beaconManager: ESTBeaconManager!
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    var regSupermarket: CLBeaconRegion!
    
    var productsInList: [Product]!
    
    var favourites: [Product]!
    
   
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        
        //configuring database
        FIRApp.configure()
        
        DatabaseManager.loadDatabase()
        //Creation of the lists
        productsInList = PersistenceManager.fetchList()
        
        //Creation of the favourites's list
        favourites = PersistenceManager.fetchFavourites()
        
        //Init the value of the beaconManager
        beaconManager = ESTBeaconManager()
        
        //Definition of the object that implement the beacon manager's protocol
        self.beaconManager.delegate = self
        
        //Definition of the region
        
        self.regSupermarket = CLBeaconRegion(
            proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,identifier : "SUPERMARKET")
        
        //Request the permission to use location and notification
        beaconManager.requestAlwaysAuthorization()
        
        /*for product in PersistenceManager.fetchAll(){
            PersistenceManager.deleteProduct(product: product)
        }
        PersistenceManager.saveContext()*/
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        beaconManager.startMonitoring(for: regSupermarket)
        beaconManager.startRangingBeacons(in: regSupermarket)
        
        return true
    }
    
  
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
         //Now the User is with is Device in the Supermarket
        
        let title1 = NSLocalizedString("Welcome to BaconTeam SuperMarket", comment: "")
        let subtitle1 = NSLocalizedString("Dear custumer,all the staff is glad for your visit.", comment:"")
        let banner = Banner(title: title1, subtitle: subtitle1, image: UIImage(named: "AppIcon"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                banner.dismissesOnSwipe=true
                banner.dismissesOnTap = true
                banner.show(duration: 3.0)
            
       }
        
        
    
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        //Now the User is with is Device out of the Supermarket
        
        let content = UNMutableNotificationContent()
        var reminder = "\n"
        
        if productsInList.count > 0 {
            
            for el in productsInList{
                reminder += el.name! + "\n"
            }
          
            
            content.title = "Hey"
            content.subtitle = NSLocalizedString("You have other items in List:",comment: "")
            content.body = reminder
            content.sound = UNNotificationSound.default()
            
            }
        
            else {
        
        
        content.title = NSLocalizedString("Goodbye",comment: "")
        content.body = NSLocalizedString("Hope to see you soon.", comment: "")
        content.sound = UNNotificationSound.default()
        }
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1.0,
            repeats: false)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "SupermarketExit",
            content: content,
            trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
    }
    
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let nearestRegion = beacons.first{
        
        var listaFiltrata = [Product]()
         
        switch nearestRegion.major{
        
        
        case 21413 : //Food-
            listaFiltrata = filterList(search: "Food")
            if listaFiltrata.count > 0 {
                var nameProduct: String = ""
                for product in listaFiltrata{
                    nameProduct += "\n" + product.name!
                }
                
                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("Hey! You're in the Food's Area.",comment: "")
                content.subtitle = NSLocalizedString("Remind to buy:",comment: "")
                content.body = nameProduct
                content.sound = UNNotificationSound.default()
                
                
                
                //Set the trigger of the notification -- here a timer.
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 1.0,
                    repeats: false)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(
                    identifier: "FoodArea",
                    content: content,
                    trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
            
            
        case 35887: //Drink
            listaFiltrata = filterList(search: "Drink")
            if listaFiltrata.count > 0 {
                var nameProduct: String = ""
                for product in listaFiltrata{
                    nameProduct += "\n" + product.name!
                }
                let content = UNMutableNotificationContent()
                    content.title = NSLocalizedString("Hey! You're in the Drink's Area.",comment:"")
                    content.subtitle = NSLocalizedString("Remind to buy: ",comment: "")
                    content.body = nameProduct
                    content.sound = UNNotificationSound.default()
                
                
                //Set the trigger of the notification -- here a timer.
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 1.0,
                    repeats: false)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(
                    identifier: "DrinkArea",
                    content: content,
                    trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        
        case 27161: //Item
            listaFiltrata = filterList(search: "Item")
            if listaFiltrata.count > 0 {
                var nameProduct: String = ""
                for product in listaFiltrata{
                    nameProduct += "\n" + product.name!
                }
                
                let content = UNMutableNotificationContent()
                    content.title = NSLocalizedString("Hey! You're in the generic Item's Area.",comment: "")
                    content.subtitle = NSLocalizedString("Remind to buy:",comment: "")
                    content.body = nameProduct
                    content.sound = UNNotificationSound.default()
                
                
                //Set the trigger of the notification -- here a timer.
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 1.0,
                    repeats: false)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(
                    identifier: "ItemArea",
                    content: content,
                    trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        default:
            break
        }

        }
    
    }
    
    
    func filterList(search: String) -> [Product]{
            var filterList = [Product]()
            
            for x in productsInList {
                
                if( x.department == search && !x.bought){
                    filterList.append(x)
                    }
                }
            
            return filterList
       }
        
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "product")
        container.loadPersistentStores(completionHandler: { (storeDescription,error) in
            if let error = error as NSError?{
                fatalError("Unresolved error in loading the container. \(error)")
            }
        })
        return container
    }()

  
        


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
        beaconManager.stopMonitoring(for: regSupermarket)
        beaconManager.stopRangingBeacons(in: regSupermarket)
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func savingContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch  {
                let nserror = error as NSError
                fatalError("Fatal error in saving context. \(nserror)")
            }
        }
    }


}

