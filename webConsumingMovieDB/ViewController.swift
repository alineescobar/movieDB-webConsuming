//
//  ViewController.swift
//  webConsumingMovieDB
//
//  Created by Aline Osana Escobar on 01/07/21.
//

import UIKit

//MARK: - API Info
    
    //API key: ed59a401ccb87b2fa3fd6a859f9563c4
    //URL popular: https://api.themoviedb.org/3/movie/popular?api_key=ed59a401ccb87b2fa3fd6a859f9563c4
    //URL Now Playing: https://api.themoviedb.org/3/movie/now_playing?api_key=ed59a401ccb87b2fa3fd6a859f9563c4


//MARK: - Struct Movies
struct Movies: CustomStringConvertible {
    let id: Int
    let title: String
    let overview: String
    let vote_average: Double
    
    var description: String{
        return "\(title), \(overview) with \(vote_average) vote "
    }
} //Movies


//MARK: - ViewController
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var popularMovies: [Movies] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - API request - Popular Movies
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=ed59a401ccb87b2fa3fd6a859f9563c4"
        let url = URL(string: urlString)!
    
        URLSession.shared.dataTask(with: url) { data, response, error in
        
            typealias TMDBMovies = [String: Any]

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed), //parsing
                  let dictionary = json as? [String: Any], //converting parsing into local dictionary
                  let resultMovies = dictionary["results"] as? [TMDBMovies] //converting parsing key
            else { return }
            
            //MARK: - Converting dictionary to structure
            var localPopularMovies: [Movies] = []
           
            for moviesDictionary in resultMovies {
                
                guard let id = moviesDictionary["id"] as? Int,
                      let title = moviesDictionary["title"] as? String,
                      let overview = moviesDictionary["overview"] as? String,
                      let vote_average = moviesDictionary["vote_average"] as? Double
                else { continue }
                
                let movie = Movies(id: id, title: title, overview: overview, vote_average: vote_average)
                localPopularMovies.append(movie)
            }
            
            self.popularMovies = localPopularMovies //popular movies of class
            
        } // API request
        .resume()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }// viewDidLoad

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = popularMovies[indexPath.row]
        
        cell.movieTitle.text = movie.title
        cell.overviewText.text = movie.overview
        cell.rating.text = String(movie.vote_average)
        
        return cell
    }

}//ViewController

