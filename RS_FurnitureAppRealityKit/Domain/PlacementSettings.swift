//
//  PlacementSettings.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 01/11/2024.
//

import Foundation
import Combine
//import RealityKit

final class PlacementSettings : ObservableObject {
  /// When user selects a model in BrowseScreen, this property will set
  @Published var selectedModel : Model? {
    willSet {
      print("Setting selectedModel to \(String(describing: newValue?.name))")
    }
  }
  
  /// When the user taps confirm in PlacementScreen, the value of selectedModel
  /// is assigned to confirmedModel
  @Published var confirmedModel : Model? {
    willSet {
      // Check if the new value not empty
      guard let model = newValue else {
        print("Clearing confirmedModel")
        return
      }
      
      print("Setting confirmedModel to \(model.name)")
      
      // Add confirmed model to recentlyPlaceModel
      self.recentPlacedModel.append(model)
    }
  }
  
  
  /// This property will retains a record of place models in the scene. The last element
  /// is the most recently place model
  @Published var recentPlacedModel: [Model] = []
  
  /// This property retains the cancellable object for our SceneEvents.Update subscriber
  var sceneObserver : Cancellable?
}
