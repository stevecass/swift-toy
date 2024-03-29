//
//  ApiCommunicator.swift
//  MnApiClient
//
//  Created by Steven Cassidy on 7/19/14.
//  Copyright (c) 2014 Steven Cassidy. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class ApiCommunicator: NSObject {
    var delegate: APIControllerProtocol?
    var maxId = 0;

    func loadLatestThreads() {
        var urlPath = "http://localhost:3000/messages/latest"
        if maxId > 0 {
            urlPath = "http://localhost:3000/messages/newer/\(maxId)";
        }

        var url: NSURL = NSURL(string: urlPath)
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }

            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
            if(err?) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }

            if jsonResult.count > 0 {
                var latest = jsonResult[0] as NSDictionary;
                self.maxId = latest["id"] as Int
            }

            self.delegate?.didReceiveAPIResults(jsonResult)
            })
        task.resume()
    }

}
