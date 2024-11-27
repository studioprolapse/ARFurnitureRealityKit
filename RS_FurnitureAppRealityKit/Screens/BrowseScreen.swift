//
//  BrowseScreen.swift
//  RS_FurnitureAppRealityKit
//
//  Created by esikmalazman on 29/10/2024.
//

import SwiftUI

struct BrowseScreen: View {
  @Binding var isShowBrowseScreen : Bool
  
  var body: some View {
    NavigationView {
      ScrollView {
        RecentsGrid(isShowBrowseScreen: $isShowBrowseScreen)
        ModelsByCategoryGrid(isShowBrowseScreen: $isShowBrowseScreen)
      }
      .navigationTitle("Browse")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        Button("Done") {
          print("Done Button press")
          self.isShowBrowseScreen.toggle()
        }
      }
    }
  }
}

struct ModelsByCategoryGrid : View {
  @Binding var isShowBrowseScreen : Bool
  private let models = Models()
  
  var body: some View {
    VStack {
      ForEach(ModelCategory.allCases, id: \.self) { category in
        
        // Only display grid if it contains one item
        let modelsByCategory = models.get(category: category)
        if modelsByCategory.isEmpty == false {
          HorizontalGrid(
            title: category.label,
            items:modelsByCategory,
            isShowBrowseScreen: $isShowBrowseScreen
          )
        }
      }
    }
  }
}

struct RecentsGrid: View {
  @EnvironmentObject var placementSettings : PlacementSettings
  @Binding var isShowBrowseScreen : Bool
  
  var body: some View {
    if !placementSettings.recentPlacedModel.isEmpty{
      HorizontalGrid(
        title: "Recents",
        items: getRecentPlacedUniquedOrderModels(),
        isShowBrowseScreen: $isShowBrowseScreen
      )
    }
  }
  
  func getRecentPlacedUniquedOrderModels() -> [Model] {
    var recentsUniquedOrderedArray : [Model] = []
    var modelNameSet: Set<String> = []
    
    // Looping recentPlaceModel in reverse, so the last one will be recent one
    for model in placementSettings.recentPlacedModel.reversed() {
      // Check if the model name already exist in Set, if not
      // we append model in uniqued array and insert model in set
      if modelNameSet.contains(model.name) == false {
        recentsUniquedOrderedArray.append(model)
        modelNameSet.insert(model.name)
      }
    }
    
    return recentsUniquedOrderedArray
  }
}


struct HorizontalGrid : View {
  let title : String
  let items : [Model]
  
  @EnvironmentObject var placementSettings : PlacementSettings
  @Binding var isShowBrowseScreen : Bool
  
  // Specify on layout and spcify 1 item in row with the fix height of 150
  private let gridItemLayout : [GridItem] = [GridItem(.fixed(150))]
  
  var body: some View {
    VStack(alignment: .leading) {
      Separator()
      
      Text(title)
        .font(.title2).bold()
        .padding(.top)
        .padding(.leading)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: gridItemLayout, spacing: 30) {
          ForEach(0..<items.count, id: \.self) { index in
            
            let model  = items[index]
            
            ItemButton(model: model) {
              // 1. Load ModelEntity async
              model.asyncLoadModelEntity()
              // 2. Assign loaded model to selectedModel in placementSettings
              self.placementSettings.selectedModel = model
              
              print("Browse Screen: selected \(model.name) for placement")
              // Dismiss screen when item selected
              self.isShowBrowseScreen = false
            }
          }
          
        }
        .padding(.horizontal)
        .padding(.vertical)
        
      }
    }
  }
}

struct ItemButton : View {
  let model : Model
  let action : () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      Image(uiImage: model.thumbnail)
        .resizable()
        .frame(height: 150)
      // Set to 1/1 to contrain width n height like they are equal
      // Enforcing square aspect ratio
        .aspectRatio(1/1, contentMode: .fit)
        .background(Color(uiColor: .secondarySystemFill))
        .clipShape(.rect(cornerRadius: 8))
    }
    
  }
}


struct Separator : View {
  var body: some View {
    Divider()
      .padding()
  }
  
}
#Preview {
  BrowseScreen(
    isShowBrowseScreen: .constant(true)
  )
}
