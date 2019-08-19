//
//  ViewController.swift
//  HTTP Session
//
//  Created by Denis Bystruev on 15/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var decriptionLabel: UILabel!
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forwardButton.isEnabled = false
        loadRequest(date: date)
    }
    
    func loadRequest(date: Date) {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: date)
        
        let query = [
            "api_key": "DEMO_KEY",
            "date": stringDate,
        ]
        
        navigationItem.title = "Loading for \(stringDate)"
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(#function, #line, error?.localizedDescription ?? "no description")
                return
            }
            
            let decoder = JSONDecoder()
            guard let photoInfo = try? decoder.decode(PhotoInfo.self, from: data) else {
                
                guard let stringData = String(data: data, encoding: .utf8) else {
                    print(#function, #line, "ERROR: can't decode \(data) as UTF8")
                    return
                }
                
                print(#function, #line, "ERROR: can't decode data from \(stringData)")
                return
            }
            
            
            OperationQueue.main.addOperation {
                self.imageView.image = nil
            }
            
            URLSession.shared.dataTask(with: photoInfo.url) { imageData, _, _ in
                guard let imageData = imageData else { return }
                OperationQueue.main.addOperation {
                    self.imageView.image = UIImage(data: imageData)
                }
                print(#line, #function, photoInfo.url.absoluteString)
            }.resume()
            
            DispatchQueue.main.async {
                self.navigationItem.title = photoInfo.title
                self.decriptionLabel.text = photoInfo.description
            }
        }
        task.resume()
    }
    
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        let secondsInDay = TimeInterval(24 * 60 * 60)
        
        switch sender {
            
        case backButton:
            date = date.addingTimeInterval(-secondsInDay)
            forwardButton.isEnabled = true
            
        case forwardButton:
            let tomorrow = date.addingTimeInterval(secondsInDay)
            let afterTomorrow = tomorrow.addingTimeInterval(secondsInDay)
            
            forwardButton.isEnabled = afterTomorrow <= Date()
            guard tomorrow <= Date() else { return }
            
            date = tomorrow
            
        default:
            return
        }
        
        loadRequest(date: date)
    }
    
}

