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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
    var beaconManager = ESTBeaconManager()
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    //Icy Marshmallow,that define the Food's zone
    let regFood = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,major:27161,identifier : "ranged zone")
    
    //Blueberry Pie,that define the item's zone
    let regItem = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,major:35887,identifier : "ranged zone")
    
    
    //Mint,that define the Fruit's zone
    let regFruit = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,major: 21413,identifier : "ranged zone")
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        switch region.major! {
        // I break sono temporanei
        case regFood.major!:
            //Crea notifica che ti trovi nella zona del cibo
            break
        case regItem.major!:
            //crea notifica che ti trovi nella zona degli oggetti
            break
        case regFruit.major!:
            //crea notifica che ti trovi nella zone della frutta
            break
        default:
            break
        }
    }

    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "products")
        container.loadPersistentStores(completionHandler: { (storeDescription,error) in
            if let error = error as NSError?{
                fatalError("Unresolved error in loading the container. \(error)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
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

