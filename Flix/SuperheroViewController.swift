//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Pavani Malli on 6/23/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import AlamofireImage

class SuperheroViewController: UIViewController, UICollectionViewDataSource {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var movies: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self;
        fetchMovies()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 2;
        let interItemSpacing = layout.minimumInteritemSpacing * (cellsPerLine-1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacing
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        // Do any additional setup after loading the view.
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString+posterPathString)
            cell.posterImageView.af_setImage(withURL: posterURL!)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return movies.count
    }
    
   
    
    //Network data task to fetch movie data
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
                self.collectionView.reloadData()
                
            }
        }
       
        task.resume()
        
    }
    
    
    
    //Push navigation method - passes in data to destincation ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PosterCell
        if let indexPath = collectionView.indexPath(for: cell){
            let movie = movies[indexPath.item]
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            movieDetailViewController.movie = movie
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    



}
