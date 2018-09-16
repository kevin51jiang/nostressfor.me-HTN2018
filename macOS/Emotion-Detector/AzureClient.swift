//
//  AzureClient.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/16/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Cocoa

typealias FaceId = String
typealias Confidence = Double

enum AzureClient {
    
    static let baseURL = URL(string: "https://canadacentral.api.cognitive.microsoft.com/face/v1.0/detect")!
    static let subscriptionID = "331fe003ca5a412186ecb755032bf687"
    
    static func endpoint(named name: String) -> URL {
        return baseURL.appendingPathComponent(name)
    }
    
    // MARK: Azure requests
    
    static func getExpressionInfo(image: CIImage, completion: @escaping (FaceId?) -> Void) {
        hostImageOnServer(image: image, completion: { hostedUrl in
            guard let hostedUrl = hostedUrl else {
                completion(nil)
                return
            }
            
            print("hosted new image at \(hostedUrl)")
            uploadImageToAzure(at: hostedUrl, completion: completion)
        })
    }
    
    
    private static func uploadImageToAzure(at imageUrl: String, completion: @escaping (FaceId?) -> Void) {
        
        let body = [
            "url": imageUrl
        ]
        
        request(to: "detect", method: "POST", with: body) { (json) in
            guard let json = json as? [[String: Any]],
                let faceId = json.first?["faceId"] as? String else
            {
                completion(nil)
                return
            }
            
            completion(faceId)
        }
    }
    
    static func request(
        to endpointName: String,
        method: String,
        with body: [String: Any],
        completion: @escaping (Any?) -> Void)
    {
        let request = NSMutableURLRequest(url: endpoint(named: endpointName))
        request.addValue(subscriptionID, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        request.httpMethod = method
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
            {
                completion(jsonObject)
            } else {
                completion(nil)
            }
        }).resume()
    }
    
    // MARK: imgur requests
    
    static let imageServerBaseURL = URL(string: "https://api.imgur.com/3/image")!
    static let imageServerClientID = "Client-ID c5034654d9f801a"
    
    static func hostImageOnServer(image: CIImage, completion: @escaping (String?) -> Void) {
        let imageData = NSBitmapImageRep(ciImage: image)
        guard let base64Data = imageData.representation(using: .jpeg, properties: [:]) else {
            completion(nil)
            return
        }
            
        let base64String = base64Data.base64EncodedString()
        let bodyJson = "{\"image\": \"\(base64String)\"}"

        //post the data
        var request = URLRequest(url: imageServerBaseURL)
        request.httpMethod = "POST"
        request.addValue(imageServerClientID, forHTTPHeaderField: "Authorization")
        request.httpBody = bodyJson.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")

        URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) -> () in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let imgurData = json?["data"] as? [String: Any],
                let url = imgurData["link"] as? String
            {
                completion(url)
            }
                
            else {
                print(error ?? "")
                completion(nil)
            }
        }).resume()
    }
    
}
