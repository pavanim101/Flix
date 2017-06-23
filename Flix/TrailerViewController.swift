//
//  TrailerViewController.swift
//  Flix
//
//  Created by Pavani Malli on 6/22/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {
    var movieID: Int = 0
    var videoID: String = ""
    var results: [[String:Any]] = []
    
    @IBOutlet weak var youTubeWebView: UIWebView!
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetches the needed video ID and loads into YouTube web request
        fetchVideos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          }
    

    //Data task to fetch video ID and passes in loadYoutube helper function
    func fetchVideos() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/"+String(movieID)+"?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&append_to_response=videos")!
        
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
                
                let videos = dataDictionary["videos"] as! [String: Any]
                
                self.results = videos["results"] as! [[String: Any]]
            
                let video = self.results[0]
                
                let key = video["key"] as! String
                
                self.videoID = key
                
                self.loadYoutube(videoID: self.videoID)
            }
        }
        
        task.resume()
    }
    
    //Helper function for loading in specified URL into Web View
    func loadYoutube(videoID:String) {
        let url = URL(string:"https://www.youtube.com/watch?v=\(self.videoID)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval:10)
        
        youTubeWebView.loadRequest(request)
        
    }

}
