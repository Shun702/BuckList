//
//  EditView.swift
//  BucketList
//
//  Created by Shun Le Yi Mon on 02/09/2023.
//

import SwiftUI

struct EditView: View {
    @StateObject private var editModel : EditModel
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Location) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $editModel.name)
                    TextField("Description", text: $editModel.description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = editModel.location
                    newLocation.id = UUID()
                    newLocation.name = editModel.name
                    newLocation.description = editModel.description

                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await editModel.fetchNearbyPlaces()
            }
        }
        Section("Nearby…") {
            switch editModel.loadingState {
            case .loaded:
                ForEach(editModel.pages, id: \.pageid) { page in
                    Text(page.title)
                        .font(.headline)
                    + Text(": ") +
                    Text(page.description)
                        .italic()
                }
            case .loading:
                Text("Loading…")
            case .failed:
                Text("Please try again later.")
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        _editModel = StateObject(wrappedValue: EditModel(location: location))
        self.onSave = onSave

    }
    
//    enum LoadingState {
//        case loading, loaded, failed
//    }
    
//    func fetchNearbyPlaces() async {
//        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
//
//        guard let url = URL(string: urlString) else {
//            print("Bad URL: \(urlString)")
//            return
//        }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            // we got some data back!
//            let items = try JSONDecoder().decode(Result.self, from: data)
//
//            // success – convert the array values to our pages array
//            pages = items.query.pages.values.sorted { $0.title < $1.title }
//            loadingState = .loaded
//        } catch {
//            // if we're still here it means the request failed somehow
//            loadingState = .failed
//        }
//    }
    
    
}   
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { newLocation in }
    }
}
