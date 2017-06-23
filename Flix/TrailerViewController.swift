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
        fetchVideos()
       // loadYoutube(videoID: videoID)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadYoutube(videoID:String) {
        
        if (self.videoID==""){
            print("not working")
        }
        
        if (self.videoID != ""){
    
        let url = URL(string:"https://www.youtube.com/watch?v=\(self.videoID)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval:10)
        

        youTubeWebView.loadRequest(request)
        }
        
        
        
    }
    
    
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
                
                print(videos)
                
                self.results = videos["results"] as! [[String: Any]]
            
                let video = self.results[0]
                
                let key = video["key"] as! String
                
                print(key)
                
                self.videoID = key
                
                self.loadYoutube(videoID: self.videoID)
                
            }
        }
        
        task.resume()
       
        
    }

}
