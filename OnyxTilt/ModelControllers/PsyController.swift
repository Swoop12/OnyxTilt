//
//  psiController.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

typealias SuccessCompletion = (Bool) -> Void

class PsyController {
    
    static let shared = PsyController()
    private init() {
        clearFileUrl()
    }
    
    private let remoteVideoUrlString = "https://firebasestorage.googleapis.com/v0/b/spiltcoffee-45332.appspot.com/o/BrewMethods%2Fgangnam_style.mp4?alt=media&token=70a2e8fe-b4b3-42ef-9dc5-aedb4759254e"
    var videoIsDownloaded = false
    let videoLocation: URL = {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("gangnamstyle.mp4")
    }()
    
    func fetchGangnamStyle(completion: @escaping SuccessCompletion) {
        guard let url = URL(string: remoteVideoUrlString) else { return }
        URLSession.shared.downloadTask(with: url) { (location, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let location = location else { return }
            let fileManager = FileManager()
            do {
                try fileManager.copyItem(at: location, to: self.videoLocation)
                self.videoIsDownloaded = true
                completion(true)
            }catch {
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            }.resume()
    }
    
    func clearFileUrl() {
        do{
            try FileManager.default.removeItem(at: videoLocation)
            videoIsDownloaded = false
        }catch {
            print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
        }
    }
}
