//
//  MovieViewsController.swift
//  Flix
//
//  Created by Pavani Malli on 6/21/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieViewsController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableDisplayView: UITableView!
    
    var movies: [[String :Any]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector (MovieViewsController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableDisplayView.insertSubview(refreshControl, at:0)
    
        tableDisplayView.dataSource = self
        
        
        fetchMovies()
    
        }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
        
        
        self.tableDisplayView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    
    
    func fetchMovies() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval:10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //Asynchronous
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data{
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                
                print(dataDictionary)
                
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableDisplayView.reloadData()
                
                
            }
        }
        activityIndicator.stopAnimating()
        task.resume()

    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as!MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String

        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
    

        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.af_setImage(withURL: posterURL)
       
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        if let indexPath = tableDisplayView.indexPath(for: cell){
            let movie = movies[indexPath.row]
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            movieDetailViewController.movie = movie
        }
        
        
    }


}

