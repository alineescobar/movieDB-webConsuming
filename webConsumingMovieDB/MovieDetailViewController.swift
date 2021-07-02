//
//  MovieDetailViewController.swift
//  webConsumingMovieDB
//
//  Created by Aline Osana Escobar on 02/07/21.
//

import UIKit

class MovieDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var popularMovie: Movies?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! MovieDetailTableViewCell
        if let movie = popularMovie {
            
            let url = URL(string:"https://image.tmdb.org/t/p/original\(movie.poster_path)")

            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

                let image: UIImage = UIImage(data: data!)!
                DispatchQueue.main.async {
                    cell.coverImage.image = UIImage(data: data!)!
                }
            }
            task.resume()
            
            cell.movieTitle.text = movie.title
            cell.overviewText.text = movie.overview
            cell.ratings.text = String(movie.vote_average)
    
        }
        
        
        
        return cell
    }

}
