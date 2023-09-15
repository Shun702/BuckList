//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Shun Le Yi Mon on 03/09/2023.
//

import Foundation

class EditModel: ObservableObject {
    
}

extension EditView {
    @MainActor class EditModel: ObservableObject {
        var location: Location
        @Published var name : String
        @Published var description: String
        @Published var loadingState : LoadingState = .loading
        @Published var pages = [Page]()
        
        init(location: Location) {
            self.location = location
            
            name = location.name
            description = location.description
        }
        
        enum LoadingState {
            case loading, loaded, failed
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted { $0.title < $1.title }
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
    }
}
