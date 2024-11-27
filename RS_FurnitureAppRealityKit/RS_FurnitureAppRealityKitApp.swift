//
//  RS_FurnitureAppRealityKitApp.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 29/10/2024.
//

import SwiftUI

@main
struct RS_FurnitureAppRealityKitApp: App {
  @StateObject var placementSetttings: PlacementSettings = PlacementSettings()
  @StateObject var sessionSettings: SessionSettings = SessionSettings()
  
  var body: some Scene {
    WindowGroup {
      HomeScreen()
        .environmentObject(placementSetttings)
        .environmentObject(sessionSettings)
    }
  }
}
