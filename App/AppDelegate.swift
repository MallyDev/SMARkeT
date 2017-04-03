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



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    var beaconManager: ESTBeaconManager!
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    var regSupermarket: CLBeaconRegion!
    
    var productsInList: [Product]!
    
    var favourites: [Product]!
    
    
    
    
    
    
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
         //Now the User is with is Device in the Supermarket
        
        let content = UNMutableNotificationContent()
        content.title = "Welcome"
        content.body = "Dear custumer,all the staff is happy for your visit."
        content.sound = UNNotificationSound.default()
        
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1.0,
            repeats: false)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: "SupermarketEnter",
            content: content,
            trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
    }
    
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        //Now the User is with is Device out of the Supermarket
        
        let content = UNMutableNotificationContent()
        content.title = "Goodbye"
        content.body = "Hope to see you soon."
        content.sound = UNNotificationSound.default()
        
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
        
        let nearestRegion = beacons[0]
        
        var listaFiltrata = [Product]()
        
        
        switch nearestRegion.major{
        case 21413 : //Food
            listaFiltrata = filterList(search: "Food")
            if(listaFiltrata.count != 0){
                var nameProduct: String = ""
                for product in listaFiltrata{
                    nameProduct += "\n" + product.name!
                }
                
                let content = UNMutableNotificationContent()
                content.title = "Hey! You're in the Food's Area. Remind to buy: "
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
            
            
        case 35887: //Fruit
            listaFiltrata = filterList(search: "Fruit")
            if(listaFiltrata.count != 0){
                var nameProduct: String = ""
                for product in listaFiltrata{
                    nameProduct += "\n" + product.name!
                }
                
                let content = UNMutableNotificationContent()
                content.title = "Hey! You're in the Fruit's Area. Remind to buy: "
                content.body = nameProduct
                content.sound = UNNotificationSound.default()
                
                //Set the trigger of the notification -- here a timer.
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 1.0,
                    repeats: false)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(
                    identifier: "FruitArea",
                    content: content,
                    trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        
        case 27161: //Item
            listaFiltrata = filterList(search: "Item")
            if(listaFiltrata.count != 0){
                var nameProduct: String = ""
                for product in listaFiltrata{
                    nameProduct += "\n" + product.name!
                }
                
                let content = UNMutableNotificationContent()
                content.title = "Hey! You're in the Item's Area. Remind to buy: "
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
    
        func filterList(search: String) -> [Product]{
            var filterList = [Product]()
            
            for x in productsInList {
                
                if( x.department == search){
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

  
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Creation of the lists
        
        productsInList = PersistenceManager.fetchList()
        
        
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
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        
        beaconManager.startMonitoring(for: regSupermarket)
        beaconManager.startRangingBeacons(in: regSupermarket)
        
        return true
    }

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

