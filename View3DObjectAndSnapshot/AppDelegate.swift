//
//  AppDelegate.swift
//  View3DObjectAndSnapshot
//
//  Created by Hassan on 19.9.2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK:- Variables
    var window: UIWindow?
    var managerObject = NSManagedObjectModel()
    var arrImages = [ImagesData]()

    lazy var persistant : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImagesData")
        container.loadPersistentStores { (storeData, error) in
            if let error = error{
                fatalError("no data found")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        getData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    //MARK:- Functions
    func getData() {
        arrImages.removeAll()
        let managedObjectContex =  (UIApplication.shared.delegate as! AppDelegate).persistant.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImagesDataInfo")
        request.returnsObjectsAsFaults = false
        do{
            let results = try managedObjectContex.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                            
                            if let imageData = result.value(forKey: "image") as? Data {
                                if let xCamera = result.value(forKey: "x_camera") as? Float{
                                    if let yCamera = result.value(forKey: "y_camera") as? Float{
                                        if let zCamera = result.value(forKey: "z_camera") as? Float{
                                            
                                            if let xObject = result.value(forKey: "x_object") as? Float{
                                                
                                                if let yObject = result.value(forKey: "y_object") as? Float{
                                                    
                                                    if let zObject = result.value(forKey: "z_object") as? Float{
                                                        self.arrImages.append(ImagesData(image: UIImage(data: imageData)!, xCamera: xCamera, yCamera: yCamera, zCamera: zCamera, xObject: xObject, yObject: yObject, zObject: zObject))
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                    }
                }
            }
        }catch{
            print("Data Fetching Error")
        }
    }
}
