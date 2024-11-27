//
//  ContentView.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 29/10/2024.
//

import SwiftUI

struct HomeScreen: View {
  
  @EnvironmentObject var placementSettings: PlacementSettings
  @State private var isControlVisible : Bool = true
  @State private var isShowBrowseScreen : Bool = false
  @State private var isShowSettingsScreen: Bool = false
  
  var body: some View {
    VStack {
      ZStack(alignment: .bottom) {
        CustomARViewContainer()
        
        /// Show ControlView if no model selected, otherwise show placement screen
        if let _ = placementSettings.selectedModel {
          PlacementControlView()
        } else {
          ControlView(
            isControlVisible: $isControlVisible,
            isShowBrowseScreen: $isShowBrowseScreen,
            isShowSettingsScreen: $isShowSettingsScreen
          )
        }
      }
      .ignoresSafeArea()
    }
  }
}

#Preview {
  HomeScreen()
    .environmentObject(PlacementSettings())
    .environmentObject(SessionSettings())
}
