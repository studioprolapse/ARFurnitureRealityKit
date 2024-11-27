//
//  PlacementScreen.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 01/11/2024.
//

import SwiftUI

struct PlacementControlView: View {
  @EnvironmentObject var placementSettings: PlacementSettings
  
    var body: some View {
      HStack {
        Spacer()
        
        PlacementButton(systemIconName: "xmark.circle.fill") {
          print("Cancel Placement button pressed")
          // Clear the selected model bcs user already cancel it
          self.placementSettings.selectedModel = nil
        }
        
        Spacer()
        
        PlacementButton(systemIconName: "checkmark.circle.fill") {
          print("Confirm Placement button pressed")
          // Transfer model from selected State to confirmed State
          
          // Assign selected model to confirmed model
          self.placementSettings.confirmedModel = self.placementSettings.selectedModel
          
          // Clear selected model bcs the user already confirm it
          self.placementSettings.selectedModel = nil
        }
        
        Spacer()
      }
      .padding(.bottom)
    }
}

struct PlacementButton : View {
  let systemIconName: String
  let action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      Image(systemName: systemIconName)
        .font(.system(size: 50, weight: .light, design: .default))
        .foregroundStyle(Color.white)
        .buttonStyle(.plain)
    }
    .frame(width: 75, height: 75)
  }
}

#Preview {
    PlacementControlView()
}
