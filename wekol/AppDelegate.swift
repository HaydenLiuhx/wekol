//
//  AppDelegate.swift
//  wekol
//
//  Created by 刘皇逊 on 11/11/19.
//  Copyright © 2019 Eidetika. All rights reserved.
//

import UIKit
import CoreData
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WXApi.registerApp("wxa42e11f2c1bc528b",universalLink: "https://www.wekol.com.au/")
        // Override point for customization after application launch.
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlKey: String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
         
        if urlKey == "com.tencent.xin" {
                  // 微信 的回调
                  return  WXApi.handleOpen(url, delegate: self)
              }
              
              return true
    }
    func onReq(_ req: BaseReq!) {
        
    }
    func onResp(_ resp: BaseResp!) {
        let sendRes: SendAuthResp? = resp as? SendAuthResp
        let queue = DispatchQueue(label: "wechatLoginQueue")
        queue.async {
            
            print("async: \(Thread.current)")
            if let sd = sendRes {
                if sd.errCode == 0 {
                    
                    guard (sd.code) != nil else {
                        return
                    }
                    // 第一步: 获取到code, 根据code去请求accessToken
                    self.requestAccessToken((sd.code)!)
                } else {
                    
                    DispatchQueue.main.async {
                        // 授权失败
                    }
                }
            } else {
                
                DispatchQueue.main.async {
                   // 异常
                }
            }
        }
    }
    private func requestAccessToken(_ code: String) {
        // 第二步: 请求accessToken
       let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\("wxa42e11f2c1bc528b")&secret=\("49cc72b6f68a58655455244f1cbde412")&code=\(code)&grant_type=authorization_code"
               
        let url = URL(string: urlStr)
        
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            
            guard dic != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                }
                return
            }
            
            guard dic!["access_token"] != nil else {
                DispatchQueue.main.async {
                   // 获取授权信息异常
                }
                return
            }
            
            guard dic!["openid"] != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                }
                return
            }
            // 根据获取到的accessToken来请求用户信息
            self.requestUserInfo(dic!["access_token"]! as! String, openID: dic!["openid"]! as! String)
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
            }
        }
    }
    private func requestUserInfo(_ accessToken: String, openID: String) {
        
        let urlStr = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openID)"
        
        let url = URL(string: urlStr)
        
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            
            guard dic != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                }
                
                return
            }
            
            if let dic = dic {
                
                // 这个字典(dic)内包含了我们所请求回的相关用户信息
            }
        } catch {
            DispatchQueue.main.async {
               // 获取授权信息异常
            }
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "wekol")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

