//
//  PlaylistVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 12.11.2023.
//

import UIKit
import Kingfisher

class PlaylistVC: UITableViewController {
    
    
    let viewModel: PlaylistViewModel
    
    init(playlistURL: String, manager: DeezerAPIManager) {
        self.viewModel = PlaylistViewModel(playlistURL: playlistURL, manager: manager)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Play List"
        navigationItem.backButtonTitle = "Discover"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let response = viewModel.data {
            if let tracks = response.data {
                return tracks.count
            }
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as! ProfileFavoriteTableViewCell
        
        if let response = viewModel.data {
            if let tracks = response.data {
                
                let track = tracks[indexPath.row]
                
                if let album = track.album {
                    if let imageURL = album.coverXl {
                        cell.songImageView.kf.setImage(with: URL(string: imageURL)!)
                    }
                    
                    if let albumName = album.title {
                        cell.recommendationReason.text = albumName
                    }
                }
                
                if let songName = track.title {
                    if let artist = track.artist {
                        if let artistName = artist.name {
                            cell.songNameLabel.text = "\(artistName) - \(songName)"
                        }
                    }
                }
            }
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel.data {
            if let track = data.data?[indexPath.row] {
                navigationController?.pushViewController(PlayerVC(track: track), animated: true)
            }
        }
        
     
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlaylistVC: PlaylistViewModelDelegate {
    func updateUI() {
        tableView.reloadData()
    }
}
