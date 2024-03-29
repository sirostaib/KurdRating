//
//  APICaller.swift
//  KurdRating
//
//  Created by Siros Taib on 3/28/24.
//

import Foundation

struct Constants {
    static let API_KEY = "4a06669b886242b8f805e61ea75a43e6"
    static let BEARER_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YTA2NjY5Yjg4NjI0MmI4ZjgwNWU2MWVhNzVhNDNlNiIsInN1YiI6IjY1ZjQyYmE1NTk1YTU2MDE4NjA2YTMwYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FMpyDG5RkGGZFDr1NFMJSWUZreaka_GS21e75B4NTZ8"
    static let BASE_URL = "https://api.themoviedb.org"
    static let YT_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let YOUTUBE_API_KEY = "AIzaSyA9VrhZy7fK994oU-sN7KiKPbTB6osvmMo"
    
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?language=en-US") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Assuming you're making a GET request
        request.addValue("Bearer \(Constants.BEARER_TOKEN)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // Handle your response data here
            
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                // try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingSeries(completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?language=en-US") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Assuming you're making a GET request
        request.addValue("Bearer \(Constants.BEARER_TOKEN)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // Handle your response data here
            
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                // TODO: make this for tv only
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?language=en-US&page=1") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Assuming you're making a GET request
        request.addValue("Bearer \(Constants.BEARER_TOKEN)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // Handle your response data here
            
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                print(try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed))
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(results.results))

                } catch {
                    completion(.failure(APIError.failedToGetData))
                }

            }
            task.resume()
        }

    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
            
            guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
            guard let url = URL(string: "\(Constants.BASE_URL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(results.results))

                } catch {
                    completion(.failure(APIError.failedToGetData))
                }

            }
            task.resume()
        }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
            

            guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
            guard let url = URL(string: "\(Constants.YT_BASE_URL)q=\(query)&key=\(Constants.YOUTUBE_API_KEY)") else {return}
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                print("hereeee")
                do {
//                   // print(try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed))
//                    print(String(data: data, encoding: .utf8))
//                    print("{\n  \"kind\": \"youtube#searchListResponse\",\n  \"etag\": \"fsFfiwYUyjoNLX0jTHKKYcagv8c\",\n  \"nextPageToken\": \"CAUQAA\",\n  \"regionCode\": \"IQ\",\n  \"pageInfo\": {\n    \"totalResults\": 1000000,\n    \"resultsPerPage\": 5\n  },\n  \"items\": [\n    {\n      \"kind\": \"youtube#searchResult\",\n      \"etag\": \"YdkLmG6ReizQHsHj-_w8JZe4rMg\",\n      \"id\": {\n        \"kind\": \"youtube#video\",\n        \"videoId\": \"dbjPnXaacAU\"\n      }\n    },\n    {\n      \"kind\": \"youtube#searchResult\",\n      \"etag\": \"0IKTJXl2MLrajRFu5LxQAPo9l6A\",\n      \"id\": {\n        \"kind\": \"youtube#video\",\n        \"videoId\": \"hMrnFgH-Cu8\"\n      }\n    },\n    {\n      \"kind\": \"youtube#searchResult\",\n      \"etag\": \"nlFm3T4DMnev1qdEQFkkteO-fmk\",\n      \"id\": {\n        \"kind\": \"youtube#video\",\n        \"videoId\": \"yrN96mgnEl0\"\n      }\n    },\n    {\n      \"kind\": \"youtube#searchResult\",\n      \"etag\": \"JgQjQfvK9EihMPj1Jf-ndAoopDI\",\n      \"id\": {\n        \"kind\": \"youtube#video\",\n        \"videoId\": \"mJVWX0vud-g\"\n      }\n    },\n    {\n      \"kind\": \"youtube#searchResult\",\n      \"etag\": \"iAryBx5n6w_mzDKoHJI4vNznGL4\",\n      \"id\": {\n        \"kind\": \"youtube#video\",\n        \"videoId\": \"2a4Uxdy9TQY\"\n      }\n    }\n  ]\n}\n")
                    let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                    print(results.items.first?.id.videoId)
                    completion(.success(results.items.first!))
                    

                } catch {       
                    print(error)
                    completion(.failure(error))
            
                }

            }
            task.resume()
        }
    
}
