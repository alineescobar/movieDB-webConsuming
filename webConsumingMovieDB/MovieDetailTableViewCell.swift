//
//  MovieDetailTableViewCell.swift
//  webConsumingMovieDB
//
//  Created by Aline Osana Escobar on 02/07/21.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
