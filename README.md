# Flickr Search API sample app
## Overview
This app is intended to demonstrate the use of the Flickr search API. It let's the user search for a random image on Flickr.

## Supporting Resources
A detailed tutorial on how to use the Flickr API is on my blog at 
[http://justmobiledev.com](http://justmobiledev.com/ios-tutorial-getting-started-with-flickr-search-api/).

Documentation for the Flickr API can be found [here](https://www.flickr.com/services/api/).

## Implementation
* This app only consists of a ViewController that displays the search input field, search button and the Flickr image in an UIImageView.
* To call the Flickr REST API, the iOS URLSession, URLRequest classes are used. The URLComponent class is used to specify scheme, host, and path for the API. To assemble the Flickr API query parameters, we used the URLQueryItem and those objects are added to the componenr.queryItems array.
* To parse the JSON response payload, we are using the JSONSerialization class, which is part of the iOS Foundation library since iOS 5.
* From the result array, we pick a random image URL, which we use to load the UIImageView.

## Usage
1. When the app is started, you can use the search input field to add a keyword.
2. Press the search button to retrieve a random image from Flickr and display it.

## Screenshots
![Flickr Search 1](screenshots/flickr-search-ss-1.png?raw=true "Flickr Search 1")


