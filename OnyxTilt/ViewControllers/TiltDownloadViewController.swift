//
//  ViewController.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CoreMotion

class TiltDownloadViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var downloadButton : UIButton!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var videoDownloadActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    var motionController = CoreMotionController()
    
    //MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        motionController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewForDownload()
    }
    
    func beginDownloadProcedure() {
        configureViewForVideo()
        motionController.startDeviceMotion()
        startVideoDownload()
    }
    
    func updatePitchSlider() {
        let pitchValue = Float(motionController.pitchInDegrees)
        pitchSlider.setValue(pitchValue, animated: true)
    }
    
    func configureViewForVideo(){
        self.pitchSlider.isHidden = false
        self.downArrowImageView.isHidden = false
        self.upArrowImageView.isHidden = false
        self.configureButtonForVideo()
    }
    
    func configureViewForDownload() {
        pitchSlider.isHidden = true
        downArrowImageView.isHidden = true
        upArrowImageView.isHidden = true
        toggleActivityIndicator(on: false)
        configureButtonForDownload()
    }
    
    func startVideoDownload() {
        toggleActivityIndicator(on: true)
        PsyController.shared.fetchGangnamStyle { (success) in
            DispatchQueue.main.async {
                self.toggleActivityIndicator(on: false)
                if success {
                    self.enableStartButton()
                }else {
                    self.presentSimpleAlertWith(title: "Whoops", body: "Something went wrong fetching the video.  This is awkward?")
                }
            }
            
        }
    }
    
    func configureButtonForVideo() {
        self.downloadButton.isEnabled = false
        self.downloadButton.setTitle("Start Video", for: .disabled)
        self.downloadButton.setTitle("Start Video", for: .normal)
    }
    
    func configureButtonForDownload() {
        self.downloadButton.isEnabled = true
        self.downloadButton.setTitle("Download", for: .disabled)
        self.downloadButton.setTitle("Download", for: .normal)
    }
    
    func enableStartButton(){
        guard PsyController.shared.videoIsDownloaded && motionController.phoneIsProperlyTilted else { return }
        self.downloadButton.isEnabled = true
    }
    
    func disableStartButton() {
        DispatchQueue.main.async {
            self.downloadButton.isEnabled = false
        }
    }
    
    func toggleActivityIndicator(on: Bool){
        if on{
            videoDownloadActivityIndicator.startAnimating()
        }else{
            videoDownloadActivityIndicator.stopAnimating()
        }
        UIView.animate(withDuration: 0.2) {
            self.videoDownloadActivityIndicator.isHidden = !on
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPsi"{
            let destination = segue.destination as? VideoViewController
            destination?.updateView(with: PsyController.shared.videoLocation)
        }
    }
    
    //MARK: - Actions
    @IBAction func downloadButtonTapped(_ sender: Any) {
        if PsyController.shared.videoIsDownloaded{
            motionController.motionManager.stopDeviceMotionUpdates()
            performSegue(withIdentifier: "toPsi", sender: self)
        }else {
            beginDownloadProcedure()
        }
    }
}


extension TiltDownloadViewController: CoreMotionControllerDelegate {
    func deviceDidEnterSweetSpot() {
        enableStartButton()
    }
    
    func deviceDidUpdatePitch() {
        updatePitchSlider()
    }
    
    func deviceDidExitSweetSpot() {
        disableStartButton()
    }
}
