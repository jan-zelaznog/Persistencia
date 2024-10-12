//
//  AppDelegate.swift
//  Persist
//
//  Created by Ángel González on 01/04/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Mostrar todas las llaves guardadas en UserDefaults
        let ud = UserDefaults.standard
        let diccionarioNativo = ud.dictionaryRepresentation()
        /*
        for (llave, _ ) in diccionarioNativo {
            let valor = ud.value(forKey: llave) ?? ""
            print ("\(llave) = \(valor)")
        }
         */
        print ("contenido de la entity Log: ")
        print (DataManager.instance.obtenerLog())
        return true
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


}

