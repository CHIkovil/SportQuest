//
//  NetworkService.swift
//  SportQuest
//
//  Created by Никита Бычков on 11.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation


class NetworkService
{
    public static var sharedobj = NetworkService()
    private let url = "https://type.fit/api/quotes"
    private let session = URLSession(configuration: .default)
   
    func getQuotes(onSuccess: @escaping(Quotes) -> Void)
    {
        let qurl = URL(string: url)!
        
        let task = session.dataTask(with: qurl) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                do
                {
                    
                   
                    
                    let quotes = try JSONDecoder().decode(Quotes.self, from: data!)
                    onSuccess(quotes)
                    
                }
                
                catch
                {
                    print(error.localizedDescription)
                }
               
            }
            
        }
              
        task.resume()
    }
}
