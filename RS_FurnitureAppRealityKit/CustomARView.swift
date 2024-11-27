//
//  CustomARView.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 01/11/2024.
//

import RealityKit
import ARKit
import FocusEntity
import Combine

final class CustomARView: ARView {
  var focusEntity: FocusEntity?
  // ARView does not have EnvironmentObject access since
  // it was UIKit, so we need to pass it via initialiser
  // then listen the changes via combine
  var sessionSettings: SessionSettings
  
  private var peopleOcclusionCancellable: AnyCancellable?
  private var objectOcclusionCancellable: AnyCancellable?
  private var lidarDebugCancellable: AnyCancellable?
  private var featureDebugCancellable: AnyCancellable?
  private var multiuserCancellable: AnyCancellable?
  
  
  required init(
    frame frameRect: CGRect,
    sessionSettings : SessionSettings
  ) {
    self.sessionSettings = sessionSettings
    super.init(frame: frameRect)
    
    // Create FocusEntity instance
    focusEntity = FocusEntity(on: self, focus: .classic)
    
    initialiseSessionSettings()
    setupSubscribers()
    configureAR()
  }
  
  required init(frame frameRect: CGRect) {
    fatalError("init(frame:) has not been implemented")
  }
  
  @MainActor
  @preconcurrency required dynamic init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureAR() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.horizontal, .vertical]
    session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  }
  
  /// Method to assign default settings in SessionSettings to ARView
  private func initialiseSessionSettings() {
    updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
    updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
    updateLiDARDebug(isEnabled: sessionSettings.isLiDarDebugEnabled)
    updateFeatureDebug(isEnabled: sessionSettings.isFeatureDebugEnabled)
    updateMultiUser(isEnabled: sessionSettings.isMultiUserEnabled)
  }
  
  /// Method to subscribe @Published property in SessionSettings Observable object
  private func setupSubscribers() {
    // $property allow to access projected value and combine published and subscribe to it
    peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled
      .sink { [weak self] isEnabled in
        self?.updatePeopleOcclusion(isEnabled: isEnabled)
      }
    
    objectOcclusionCancellable = sessionSettings.$isObjectOcclusionEnabled
      .sink { [weak self] isEnabled in
        self?.updateObjectOcclusion(isEnabled: isEnabled)
      }
    
    lidarDebugCancellable = sessionSettings.$isLiDarDebugEnabled
      .sink { [weak self] isEnabled in
        self?.updateLiDARDebug(isEnabled: isEnabled)
      }
    
    featureDebugCancellable = sessionSettings.$isFeatureDebugEnabled
      .sink { [weak self] isEnabled in
        self?.updateFeatureDebug(isEnabled: isEnabled)
      }
    
    multiuserCancellable = sessionSettings.$isMultiUserEnabled
      .sink { [weak self] isEnabled in
        self?.updateMultiUser(isEnabled: isEnabled)
      }
  }
  
}

private extension CustomARView {
  func updatePeopleOcclusion(isEnabled : Bool) {
    //print("\(#file): is People Occlusion Enabled: \(isEnabled)")
    
    // Check if device supported for people occlusion
    guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
      print("People occlusion is not supported in this device")
      return
    }
    
    // Access and update current configuration. We not create new
    // because we want to retain current configuration
    guard let configuration = session.configuration as? ARWorldTrackingConfiguration else {
      return
    }
    
    // Check if the people occlusion already enable, if yes remove else enable it
    if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
      configuration.frameSemantics.remove(.personSegmentationWithDepth)
      print("-> People occlusion turned off")
    } else {
      print("-> People occlusion turned off")
      configuration.frameSemantics.insert(.personSegmentationWithDepth)
    }
    
    self.session.run(configuration)
  }
  
  func updateObjectOcclusion(isEnabled : Bool) {
    print("\(#file): is Object Occlusion Enabled: \(isEnabled)")
    
    // Check if object occlusion already enable, if yes remove else enable it
    if environment.sceneUnderstanding.options.contains(.occlusion) {
      environment.sceneUnderstanding.options.remove(.occlusion)
    } else {
      environment.sceneUnderstanding.options.insert(.occlusion)
    }
  }
  
  func updateLiDARDebug(isEnabled : Bool) {
    print("\(#file): is LiDAR Debug Enabled: \(isEnabled)")
    
    // Check and enable LiDAR if supported in the current device
    guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else{
      print("LiDAR debug not supported")
      return
    }
    
    guard let configuration = session.configuration as? ARWorldTrackingConfiguration else {
      return
    }
    configuration.sceneReconstruction = .mesh
    
    // Check if LiDAR debug already enable, if yes remove else enable it
    if debugOptions.contains(.showSceneUnderstanding) {
      debugOptions.remove(.showSceneUnderstanding)
    } else {
      debugOptions.insert(.showSceneUnderstanding)
    }
    
    self.session.run(configuration)
  }
  
  func updateFeatureDebug(isEnabled : Bool) {
    print("\(#file): is Feature Debug Enabled: \(isEnabled)")
    
    // Check if LiDAR debug already enable, if yes remove else enable it
    if debugOptions.contains(.showFeaturePoints) {
      debugOptions.remove(.showFeaturePoints)
    } else {
      debugOptions.insert(.showFeaturePoints)
    }
  }
  
  func updateMultiUser(isEnabled : Bool) {
    print("\(#file): is MultiUser Enabled: \(isEnabled)")
  }
}
