//
//  ControlView.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 29/10/2024.
//

import SwiftUI

struct ControlView: View {
  @Binding var isControlVisible: Bool
  @Binding var isShowBrowseScreen : Bool
  @Binding var isShowSettingsScreen: Bool
  
  var body: some View {
    VStack {
      ControlVisibilityToggleButton(
        isControlVisible: $isControlVisible
      )
      
      Spacer()
      
      if isControlVisible {
        ControlButtonBar(
          isShowBrowseScreen: $isShowBrowseScreen,
          isShowSettingsScreen: $isShowSettingsScreen
        )
      }
    }
  }
}

struct ControlVisibilityToggleButton : View {
  @Binding var isControlVisible: Bool
  
  var body: some View {
    HStack {
      Spacer()
      
      ZStack {
        Color.black.opacity(0.3)
        Button {
          print("Control Visibility Toggle Press")
          self.isControlVisible.toggle()
          
        } label: {
          Image(systemName: isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
            .font(.system(size: 25))
            .foregroundStyle(Color.white)
            .buttonStyle(.plain)
        }
      }
      .frame(width: 50, height: 50)
      .clipShape(.rect(cornerRadius: 8))
    }
    .padding(.top, 45)
    .padding(.leading)
  }
}

struct ControlButtonBar : View {
  @EnvironmentObject var placementSettings: PlacementSettings
  @Binding var isShowBrowseScreen : Bool
  @Binding var isShowSettingsScreen: Bool
  
  var body: some View {
    HStack {
      
      let shouldHideMostRecentButton = !placementSettings.recentPlacedModel.isEmpty
      
      if shouldHideMostRecentButton {
        MostRecentPlacementButton()
      }
      
      Spacer()
      
      ControlButton(systemName: "square.grid.2x2") {
        print("Browse Button Press")
        self.isShowBrowseScreen.toggle()
      }
      .sheet(isPresented: $isShowBrowseScreen) {
        // Browse Screen
        BrowseScreen(
          isShowBrowseScreen: $isShowBrowseScreen
        )
      }
      
      
      Spacer()
      
      ControlButton(systemName: "slider.horizontal.3") {
        print("Setting Button Press")
        self.isShowSettingsScreen.toggle()
      }
      .sheet(isPresented: $isShowSettingsScreen) {
        SettingsScreen(isShowSettingsScreen: $isShowSettingsScreen)
      }
      
      
    }
    .frame(maxWidth: .infinity)
    .padding(20)
    .background(Color.black.opacity(0.3))
    
  }
}

struct ControlButton : View {
  let systemName : String
  let action : () -> Void
  
  var body: some View {
    
    Button {
      action()
    } label: {
      Image(systemName: systemName)
        .font(.system(size: 35))
        .foregroundStyle(Color.white)
    }
    .frame(width: 50, height: 50)
    .buttonStyle(.plain)
  }
}

struct MostRecentPlacementButton: View {
  @EnvironmentObject var placementSettings: PlacementSettings
  
  var body: some View {
    Button {
      print("Most Recently Button Press")
      // Assign last element in recentPlaceModel to selectedModel. Allow to provide
      // user shortcut to place multiple copy of same model in the scene
      self.placementSettings.selectedModel = self.placementSettings.recentPlacedModel.last
    } label: {
      if let mostRecentlyPlacedModel = self.placementSettings.recentPlacedModel.last {
        Image(uiImage: mostRecentlyPlacedModel.thumbnail)
          .resizable()
          .frame(width: 45)
          .aspectRatio(1/1, contentMode: .fit)
      } else {
        Image(systemName: "clock.fill")
          .font(.system(size: 35))
          .foregroundStyle(Color.white)
          .buttonStyle(.plain)
      }
    }
    .frame(width: 50, height: 50)
    .background(Color.white)
    .clipShape(.rect(cornerRadius:8))
  }
}

#Preview {
  ControlView(
    isControlVisible: .constant(true),
    isShowBrowseScreen: .constant(true),
    isShowSettingsScreen: .constant(true)
  )
}
