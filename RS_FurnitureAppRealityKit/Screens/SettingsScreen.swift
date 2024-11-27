//
//  SettingsScreen.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 01/11/2024.
//

import SwiftUI

// Available setting to be diplay in the grid view
enum Setting {
  case peopleOcclusion
  case objectOcclusion
  case lidarDebug
  case featureDebug
  case multiuser
  
  var label: String {
    switch self {
    case .peopleOcclusion,.objectOcclusion:
      return "Occlusion"
    case .lidarDebug:
      return "LiDAR"
    case .featureDebug:
      return "Points"
    case .multiuser:
      return "Multiuser"
    }
  }
  
  var systemIconName: String {
    switch self {
    case .peopleOcclusion:
      return "person"
    case .objectOcclusion:
      return "cube.box.fill"
    case .lidarDebug:
      return "light.min"
    case .featureDebug:
      return "rays"
    case .multiuser:
      return "person.2"
      
    }
  }
}

struct SettingsScreen: View {
  @Binding var isShowSettingsScreen: Bool
  
  var body: some View {
    VStack {
      NavigationView {
        SettingGrid()
          .navigationTitle("Settings")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            Button {
              self.isShowSettingsScreen.toggle()
            } label: {
              Text("Done").bold()
            }
          }
      }
    }
  }
}

struct SettingGrid: View {
  // Create grid layout to fit as many item of size 100 with spacing 25 for horizontal side
  private let gridItemLayout: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]
  @EnvironmentObject var sessionSettings: SessionSettings
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: gridItemLayout, spacing: 25) {
        SettingToggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOcclusionEnabled)
        
        SettingToggleButton(setting: .objectOcclusion, isOn: $sessionSettings.isObjectOcclusionEnabled)
        
        SettingToggleButton(setting: .lidarDebug, isOn: $sessionSettings.isLiDarDebugEnabled)
        
        SettingToggleButton(setting: .featureDebug, isOn: $sessionSettings.isFeatureDebugEnabled)
        
        SettingToggleButton(setting: .multiuser, isOn: $sessionSettings.isMultiUserEnabled)
      }
    }
    .padding(.top)
  }
}

struct SettingToggleButton:View {
  let setting:Setting
  @Binding var isOn: Bool
  
  var body: some View {
    Button {
      self.isOn.toggle()
      print("\(#file) - \(setting): \(self.isOn)")
    } label: {
      VStack {
        Image(systemName: setting.systemIconName)
          .font(.system(size: 35))
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(isOn ? Color.green : Color(uiColor: .secondaryLabel))
          .buttonStyle(.plain)
          .frame(maxHeight: .infinity)
        
        Text(setting.label)
          .font(.headline)
          .foregroundStyle(isOn ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel))
          .padding(.bottom, 8)
      }
    }
    .frame(width: 100, height: 100)
    .background(Color(uiColor: .secondarySystemFill))
    .cornerRadius(8)
  }
}

#Preview {
  SettingsScreen(isShowSettingsScreen: .constant(true))
    .environmentObject(SessionSettings())
}
