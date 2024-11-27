//
//  SessionSettings.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 01/11/2024.
//

import Foundation

final class SessionSettings: ObservableObject {
  @Published var isPeopleOcclusionEnabled: Bool = false
  @Published var isObjectOcclusionEnabled: Bool = false
  @Published var isLiDarDebugEnabled: Bool = false
  @Published var isFeatureDebugEnabled: Bool = false
  @Published var isMultiUserEnabled: Bool = false
}
