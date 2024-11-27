//
//  Model.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 30/10/2024.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
  case chair
  case decor
  
  var label: String {
    switch self {
    case .chair: return "Chairs"
    case .decor: return "Decors"
    }
  }
}


final class Model : ObservableObject {
  var name : String
  let category: ModelCategory
  var thumbnail: UIImage
  // Set the model either contain model or empty
  @Published var modelEntity: ModelEntity?
  // RealityKit use meter as measurement. Third party models sometimes use
  // different unit or scale. To correct it we use scale compensation property.
  var scaleCompensation : Float
  
  private var cancellable : AnyCancellable?
     
  init(
    name: String,
    category: ModelCategory,
    scaleCompensation: Float = 1.0
  ) {
    self.name = name
    self.category = category
    self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
    self.scaleCompensation = scaleCompensation
  }
  
  // ModelEntity property not initialise upfront due its optional and
  // we will load it asynchronously when user select for placement in AR view scene
  func asyncLoadModelEntity()  {
    let filename = name + ".usdz"
    
    cancellable = ModelEntity.loadModelAsync(named: filename).sink { loadRequest in
      switch loadRequest {
      case .finished: break
      case .failure: print("Failed to load Model Entity: \(filename)")
      }
    } receiveValue: { modelEntity in
      self.modelEntity = modelEntity
      // Apply scaleCompensation to ensure model has appropriate real world scala
      self.modelEntity?.scale *= self.scaleCompensation
    }
  }
}

// Object that will reference all our models. In prod app we might want
// to use better solution to index and organise the 3D models
struct Models {
  var all : [Model] = []
  
  init() {
    // scaleCompensation, we use to scale 3D asset to appropriate real world scale
    
    // Chairs
    let chairSwan = Model(name: "chair_swan", category: .chair, scaleCompensation: 0.5)
    all.append(chairSwan)
    
    // Decors
    let cupSaucerSet = Model(name: "cup_saucer_set", category: .decor, scaleCompensation: 0.5)
    let flowerTulip = Model(name: "flower_tulip", category: .decor, scaleCompensation: 0.5)
    let gramophone = Model(name: "gramophone", category: .decor, scaleCompensation: 0.5)
    let tvRetro = Model(name: "tv_retro", category: .decor, scaleCompensation: 0.5)
    
    all.append(contentsOf: [cupSaucerSet, flowerTulip, gramophone,tvRetro])
  }
  
  
  /// Helper method to filter all of our models and get every model belong to specific category
  /// - Parameter category: Type of model
  /// - Returns: Models of specific category
  func get(category: ModelCategory) -> [Model] {
    return all.filter{ $0.category == category}
  }
}
