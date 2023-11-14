//
//  SearchViewModel.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

import FirebaseFirestore
import FirebaseAuth

protocol ChangeResultsProtocol: AnyObject{
    func changeResults(_ response: SearchTrackResponse)
}

protocol RecentSearchesDelegate: AnyObject {
    func updateRecentSearches()
}

class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: - Properties
    var data: SearchTrackResponse?
    weak var changeResultsProtocol: ChangeResultsProtocol?
    weak var recentSearchesDelegate: RecentSearchesDelegate?
    let manager = DeezerAPIManager()
    var searchText = ""
    var recentSearches: [String] = []
    
    // MARK: - Functions
    func getData() {
        manager.getSearchResults(searchText: self.searchText) { data in
            self.data = data
            if let data = data {
                self.changeResultsProtocol?.changeResults(data)
            }
        } onError: { error in
            print(error)
        }
    }
    
    func getRecentSearches() {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let searchTexts = snapshot?.get("recentSearches") as? [String] else { return }
                recentSearches = searchTexts
                recentSearchesDelegate?.updateRecentSearches()
                
            }
    }
    
    func updateRecentSearches(searchText: String) {
        Firestore.firestore()
            .collection("UsersInfo")
            .document(Auth.auth().currentUser!.uid)
            .getDocument { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let document = snapshot else { return }
                do {
                    let user = try document.data(as: User.self)
                    if user.recentSearches?.count == 10 {
                        Firestore.firestore()
                            .collection("UsersInfo")
                            .document(Auth.auth().currentUser!.uid)
                            .updateData(["recentSearches" : FieldValue.arrayRemove([user.recentSearches?.first])]) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                
                                Firestore.firestore()
                                    .collection("UsersInfo")
                                    .document(Auth.auth().currentUser!.uid)
                                    .updateData(["recentSearches" : FieldValue.arrayUnion([searchText])])
                            }
                    } else {
                        Firestore.firestore()
                            .collection("UsersInfo")
                            .document(Auth.auth().currentUser!.uid)
                            .updateData(["recentSearches" : FieldValue.arrayUnion([searchText])])
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
    }
}

