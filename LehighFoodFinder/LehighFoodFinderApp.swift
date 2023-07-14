//
//  LehighFoodFinderApp.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI
import Firebase
import UIKit
import GoogleSignIn



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GoogleSignInManager.shared.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct LehighFoodFinderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
//            LoginView()
//                .environmentObject(navigationState)
            RathboneDetailsView()
        }
    }
}


//@main
//struct LehighFoodFinderApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    var body: some Scene {
//        WindowGroup {
//            LoginView()
//        }
//    }
//}
