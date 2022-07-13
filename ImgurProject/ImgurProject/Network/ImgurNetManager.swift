//
//  ImgurNetManager.swift
//  ImgurProject
//
//  Created by Fedii Ihor on 12.07.2022.
//

import UIKit

class ImgurNetManager {

    //https://api.imgur.com/3/gallery/search/{{sort}}/{{window}}/{{page}}?q=cats
    let clientID = "5af4a79c42ea7df"
    let mainUrl = "https://api.imgur.com/3/image"
    let session = URLSession.shared
    
    private func decodeImageToBace64String(image: UIImage, complete: @escaping (String?) -> ()) {
        DispatchQueue.main.async {
            //конвертировать в данные
            let imageData = image.pngData()
            let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
            complete(base64Image)
        }
    }
    
    private func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("data has been not decoded : \(error.localizedDescription)")
            return nil
        }
    }
    
   private func createURLRequest(url: URL, boundary: String ) -> URLRequest {
        var request = URLRequest(url: url)
              request.addValue("Client-ID \(self.clientID)", forHTTPHeaderField: "Authorization")
              request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
              request.httpMethod = "POST"
       
        return request
    }
    
    func downloadFotos(by term: String, completion: @escaping (SearchResponse?,Error?) -> Void) {
    let urlStr = "https://api.imgur.com/3/gallery/search/top/2?q=tenerife&q_type=jpg&q_size_px=500"
        guard let url = URL(string: urlStr) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Client-ID \(self.clientID)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let json = self.decodejson(type: SearchResponse.self, from: data) else {return}
            completion(json,nil)
        }.resume()
    }
    

func uploadImageToImgur(image: UIImage) {
        decodeImageToBace64String(image: image) { base64Image in
            let boundary = "Boundary-\(UUID().uuidString)"

            guard let url = URL(string: self.mainUrl) else { return }
            var request = self.createURLRequest(url: url, boundary: boundary)

                  var body = ""
                  body += "--\(boundary)\r\n"
                  body += "Content-Disposition:form-data; name=\"image\""
                  body += "\r\n\r\n\(base64Image ?? "")\r\n"
                  body += "--\(boundary)--\r\n"
                  let postData = body.data(using: .utf8)

                  request.httpBody = postData
            
            self.session.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    print("failed with error: \(error)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                    print("server error")
                    return
                }
                
                print("status code: ",response.statusCode)
                
                if let mimeType = response.mimeType, mimeType == "application/json", let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("imgur upload results: \(dataString)")

                    let parsedResult: [String: AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        if let dataJson = parsedResult["data"] as? [String: Any] {
                            print("Link is : \(dataJson["link"] as? String ?? "Link not found")")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}
