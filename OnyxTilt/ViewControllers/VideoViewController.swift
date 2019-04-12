//
//  VideoViewController.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var psyVideoView : PsysVideoView!
    
    func updateView(with url: URL){
        loadViewIfNeeded()
        psyVideoView.videoUrl = url
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        PsyController.shared.clearFileUrl()
        
        dismiss(animated: true, completion: nil)
    }
}
