//
//  UrfuCheckApp.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 23.02.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct UrfuCheckApp: App {
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(DS.Color.positiveColor)
        
        UISegmentedControl.appearance().backgroundColor = UIColor(DS.Color.navColor)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(DS.Color.titleColor),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(DS.Color.titleColor),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .selected)
        
        UITabBar.appearance().tintColor = UIColor(DS.Color.positiveColor)
        
        UITabBar.appearance().unselectedItemTintColor = UIColor(DS.Color.titleColor)
        
        UITabBar.appearance().backgroundColor = UIColor(DS.Color.navColor)
        
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
