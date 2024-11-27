//
//  CustomARViewContainer.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 06/11/2024.
//

import SwiftUI
import RealityKit
import ARKit

/// SwiftUI wrapper for ARView
struct CustomARViewContainer : UIViewRepresentable {
  @EnvironmentObject var placementSettings: PlacementSettings
  @EnvironmentObject var sessionSettings: SessionSettings
  
  func makeUIView(context: Context) -> some CustomARView {
    let arView = CustomARView(frame: .zero, sessionSettings: sessionSettings)
    // Subscribe to SceneEvents.Update from RealityKit that allow us to
    // access once per frame interval to execute logic
    self.placementSettings.sceneObserver = arView.scene.subscribe(
      to: SceneEvents.Update.self
    ) { event in
      self.updateScene(for: arView)
    }
    return arView
  }
  
  private func updateScene(for arView: CustomARView) {
    // 1. Handle display logic for our FocusEntity, only want to show
    // when user has selected model and not empty for placement
    if let _ = self.placementSettings.selectedModel {
      arView.focusEntity?.isEnabled = true
    } else {
      arView.focusEntity?.isEnabled = false
    }
    
    // 2. Add model to screen if confirmed for placemement
    // Check if there is a confirmed model and there is check if it has modelEntity
    if let confirmedModel = placementSettings.confirmedModel,
       let modelEntity = confirmedModel.modelEntity {
      
      self.place(modelEntity, in: arView)
      // Reset confirmedModel to avoid updateScene method repeatly place our model
      // in scene
      self.placementSettings.confirmedModel = nil
    }
  }
  
  private func place(_ modelEntity : ModelEntity, in arview : ARView) {
    // 1. Clone modelEntity, to create identical copy of modelEntity and references
    // the same model. This also allow us to have multiple models of same asset
    // in our scene.
    let clonedEntity = modelEntity.clone(recursive: true)
    
    // 2. Enable translation and rotation gesture for clone entity
    clonedEntity.generateCollisionShapes(recursive: true)
    arview.installGestures([.translation, .rotation], for: clonedEntity)
  
    // 3. Create an anchorEntity and add cloned modelEntity to the anchorEntity
    let anchorEntity = AnchorEntity(plane: .any, classification: .any, minimumBounds: .zero)
    anchorEntity.addChild(clonedEntity)
    
    // 4. Add anchorEntity to the ARView Scene
    arview.scene.addAnchor(anchorEntity)
    print("Added model entity to the scene")
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {}
  
}
