//
//  ViewController.swift
//  webConsumingMovieDB
//
//  Dupla: Aline Escobar e Eduarda Soares 
//

import UIKit

//MARK: - API Info

//API key: ed59a401ccb87b2fa3fd6a859f9563c4
//URL popular: https://api.themoviedb.org/3/movie/popular?api_key=ed59a401ccb87b2fa3fd6a859f9563c4
//URL Now Playing: https://api.themoviedb.org/3/movie/now_playing?api_key=ed59a401ccb87b2fa3fd6a859f9563c4


//MARK: - Struct Movies
struct Movies {
    let id: Int
    let title: String
    let overview: String
    let vote_average: Double
    let poster_path: String
    let genre_ids: [Int]
    
} //Movies


//MARK: API Request Popular Movies

struct APIRequestPopularMovies {
    
    mutating func requestPopularMovies(completionHandler: @escaping ([Movies]) -> Void){
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
                      let vote_average = moviesDictionary["vote_average"] as? Double,
                      let poster_path = moviesDictionary["poster_path"] as? String,
                      let genre_ids = moviesDictionary["genre_ids"] as? [Int]
                else { continue }
                
                let movie = Movies(id: id, title: title, overview: overview, vote_average: vote_average, poster_path: poster_path, genre_ids: genre_ids)
                localPopularMovies.append(movie)
            }
            completionHandler(localPopularMovies)
        } // API request
        
        .resume()
    }
    
}

//MARK: - API request Now Playing
struct APIRequestNowPlaying {

    func requestNowPlaying(page: Int = 0, completionHandler: @escaping ([Movies]) -> Void) {

    let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=ed59a401ccb87b2fa3fd6a859f9563c4"
    let url = URL(string: urlString)!

    URLSession.shared.dataTask(with: url) { data, response, error in

        typealias TMDBMovies = [String: Any]

        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed), //parsing
              let dictionary = json as? [String: Any], //converting parsing into local dictionary
              let resultMovies = dictionary["results"] as? [TMDBMovies] //converting parsing key
        else { return }

        //MARK: - Converting dictionary to structure
        var localNowPlaying: [Movies] = []

        for moviesDictionary in resultMovies {

            guard let id = moviesDictionary["id"] as? Int,
                  let title = moviesDictionary["title"] as? String,
                  let overview = moviesDictionary["overview"] as? String,
                  let vote_average = moviesDictionary["vote_average"] as? Double,
                  let poster_path = moviesDictionary["poster_path"] as? String,
                  let genre_ids = moviesDictionary["genre_ids"] as? [Int]
            else { continue }

            let movie = Movies(id: id, title: title, overview: overview, vote_average: vote_average, poster_path: poster_path, genre_ids: genre_ids)
            localNowPlaying.append(movie)
        }
        completionHandler(localNowPlaying)

    } // API request
    .resume()
    }
}

//MARK: - ViewController
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var popularMovies: [Movies] = []
    var nowPlayingMovies: [Movies] = []
    var popularMoviesAPI = APIRequestPopularMovies()
    var nowPlayingMoviesAPI = APIRequestNowPlaying()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        popularMoviesAPI.requestPopularMovies { (movies) in
            self.popularMovies = movies
        }
        
        nowPlayingMoviesAPI.requestNowPlaying { (movies) in
            self.nowPlayingMovies = movies
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }// viewDidLoad
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.frame = header.bounds
        header.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section==0 ? "Popular movies" : "Now playing"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section==0 ? popularMovies.prefix(2).count : nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let section = indexPath.section
        
        if (section == 0){
            let movie = popularMovies[indexPath.row]
        
            let url = URL(string:"https://image.tmdb.org/t/p/original\(movie.poster_path)")

            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

                DispatchQueue.main.async {
                    cell.posterImage.image = UIImage(data: data!)!
                    cell.posterImage.layer.cornerRadius = 10

                }
            }
            task.resume()
            
            cell.movieTitle.text = movie.title
            cell.overviewText.text = movie.overview
            cell.rating.text = String(movie.vote_average)
        } else {
            
            let movie = nowPlayingMovies[indexPath.row]
            let url = URL(string:"https://image.tmdb.org/t/p/original\(movie.poster_path)")

            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

                let image: UIImage = UIImage(data: data!)!
                DispatchQueue.main.async {
                    cell.posterImage.image = UIImage(data: data!)!
                    cell.posterImage.layer.cornerRadius = 10
                }
            }
            task.resume()
            
            cell.movieTitle.text = movie.title
            cell.overviewText.text = movie.overview
            cell.rating.text = String(movie.vote_average)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail", let indexPath = sender as? IndexPath {
            let section = indexPath.section
            
            if (section == 0){
                let movie = popularMovies[indexPath.row]
                guard let destination = segue.destination as? MovieDetailViewController else { return }
                destination.movieDetails = movie
            } else {
                let movie = nowPlayingMovies[indexPath.row]
                guard let destination = segue.destination as? MovieDetailViewController else { return }
                destination.movieDetails = movie
            }
        }
    }
    
}//ViewController

