//
//  MovieDetailViewController.swift
//  Flix
//
//  Created by Pavani Malli on 6/22/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import AlamofireImage

//Reassigns keys from JSON
enum MovieKeys {
    static let title = "title"
    static let overview = "overview"
    static let backdrop = "backdrop_path"
    static let poster = "poster_path"
    static let releaseDate = "release_date"
}

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageViewButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    var movie: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigns title, overview, release date, and images to respective UI widget
        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            overviewLabel.text = movie[MovieKeys.overview] as? String
            releaseDateLabel.text = movie[MovieKeys.releaseDate] as? String
            let backDropPath = movie[MovieKeys.backdrop] as! String
            let posterPath = movie[MovieKeys.poster] as! String
            
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPath)!
            let backdropURL = URL(string:baseURLString + backDropPath)!
            
            backdropImageView.af_setImage(withURL: backdropURL)
        
            imageViewButton.af_setBackgroundImage(for:  .normal, url: posterURL)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //Push Navigation method to pass data to destination TrailerViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Passes movie id to TrailerViewController
        if let movie = movie {
            let trailerViewController = segue.destination as! TrailerViewController
            trailerViewController.movieID = movie["id"] as! Int
        }
        
    }
    
}
