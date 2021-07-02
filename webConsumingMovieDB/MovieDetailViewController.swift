//
//  MovieDetailViewController.swift
//  webConsumingMovieDB
//
//  Created by Aline Osana Escobar on 02/07/21.
//

import UIKit

//MARK: - Struct Genre
struct Genre {
    let id: Int
    let name: String
}

//MARK: - API request genres
struct APIRequestGenres {

    func requestGenre(page: Int = 0, completionHandler: @escaping ([Genre]) -> Void) {
    let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=ed59a401ccb87b2fa3fd6a859f9563c4"
    let url = URL(string: urlString)!

    URLSession.shared.dataTask(with: url) { data, response, error in

        typealias TMDBGenre = [String: Any]

        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed), //parsing
              let dictionary = json as? [String: Any], //converting parsing into local dictionary
              let resultGenre = dictionary["genres"] as? [TMDBGenre] //converting parsing key
        else { return }

        //MARK: - Converting dictionary to structure
        var localGenre: [Genre] = []

        for genreDictionary in resultGenre {

            guard let id = genreDictionary["id"] as? Int,
                  let name = genreDictionary["name"] as? String
            else { continue }

            let genre = Genre(id: id, name: name)
            localGenre.append(genre)
        }
        completionHandler(localGenre)

    } // API request
    .resume()
    }
}

class MovieDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movieDetails: Movies?
    
    var genres: [Genre] = []
    var genreAPI = APIRequestGenres()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        genreAPI.requestGenre { (genres) in
            self.genres = genres
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! MovieDetailTableViewCell
        if let movie = movieDetails {
            
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
