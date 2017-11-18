//
//  ViewController.swift
//  com.justmobiledev.mobile.ios.flickrsearch
//
//  Created by Christian Scheid on 11/16/17.
//  Copyright © 2017 Christian Scheid. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        
        let searchText = searchTextField.text
        if (searchText!.isEmpty)
        {
            displayAlert("Search text cannot be empty")
            return;
        }
        
        let searchURL = flickrURLFromParameters(searchString: searchText!)
        print("URL: \(searchURL)")
        
        // Send the request
        performFlickrSearch(searchURL)
        
    }
    
    private func flickrURLFromParameters(searchString: String) -> URL {
        
        // Build base URL
        var components = URLComponents()
        components.scheme = Constants.FlickrURLParams.APIScheme
        components.host = Constants.FlickrURLParams.APIHost
        components.path = Constants.FlickrURLParams.APIPath
        
        // Build query string
        components.queryItems = [URLQueryItem]()
        
        // Query components
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.APIKey, value: Constants.FlickrAPIValues.APIKey));
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.SearchMethod, value: Constants.FlickrAPIValues.SearchMethod));
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.ResponseFormat, value: Constants.FlickrAPIValues.ResponseFormat));
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Extras, value: Constants.FlickrAPIValues.MediumURL));
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.SafeSearch, value: Constants.FlickrAPIValues.SafeSearch));
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.DisableJSONCallback, value: Constants.FlickrAPIValues.DisableJSONCallback));
        components.queryItems!.append(URLQueryItem(name: Constants.FlickrAPIKeys.Text, value: searchString));
        
        return components.url!
    }
    
    private func performFlickrSearch(_ searchURL: URL) {
        
        // Perform the request
        let session = URLSession.shared
        let request = URLRequest(url: searchURL)
        let task = session.dataTask(with: request){
            (data, response, error) in
            if (error == nil)
            {
                // Check response code
                let status = (response as! HTTPURLResponse).statusCode
                if (status < 200 || status > 300)
                {
                    self.displayAlert("Server returned an error")
                    return;
                }
                
                /* Check data returned? */
                guard let data = data else {
                    self.displayAlert("No data was returned by the request!")
                    return
                }
                
                // Parse the data
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    self.displayAlert("Could not parse the data as JSON: '\(data)'")
                    return
                }
                print("Result: \(parsedResult)")
                
                // Check for "photos" key in our result
                guard let photosDictionary = parsedResult["photos"] as? [String:AnyObject] else {
                    self.displayAlert("Key 'photos' not in \(parsedResult)")
                    return
                }
                //print("Result: \(photosDictionary)")
                
                /* GUARD: Is the "photo" key in photosDictionary? */
                guard let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                    self.displayAlert("Cannot find key 'photo' in \(photosDictionary)")
                    return
                }
                
                // Check number of ophotos
                if photosArray.count == 0 {
                    self.displayAlert("No Photos Found. Search Again.")
                    return
                } else {
                    // Get the first image
                    let photoDictionary = photosArray[0] as [String: AnyObject]
                    
                    /* GUARD: Does our photo have a key for 'url_m'? */
                    guard let imageUrlString = photoDictionary["url_m"] as? String else {
                        self.displayAlert("Cannot find key 'url_m' in \(photoDictionary)")
                        return
                    }
                    
                    // Fetch the image
                    self.fetchImage(imageUrlString);
                }
            
            }
            else{
                self.displayAlert((error?.localizedDescription)!)
            }
        }
        task.resume()
    }
    
    private func fetchImage(_ url: String) {
        
        let imageURL = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            if error == nil {
                let downloadImage = UIImage(data: data!)!
                
                DispatchQueue.main.async(){
                    self.flickrImageView.image = downloadImage
                }
            }
        }
        
        task.resume()
    }
    
    func displayAlert(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

