//
//  PsisVideoView.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

class PsysVideoView: UIView {
    
    var videoUrl: URL?{
        didSet{
            runVideo()
        }
    }
    
    weak var delegate: UIViewController?
    
    func runVideo(){
        guard let url = videoUrl else { return }
        player = AVPlayer(url: url)
        player?.play()
        player?.volume = 0.5
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get{
            return playerLayer.player
        }
        set{
            playerLayer.player = newValue
        }
    }
    
    override class var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tap = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
        addGestureRecognizer(tap)
    }
    
    @objc func wasTapped(){
        player?.timeControlStatus.rawValue == 0 ? player?.play() : player?.pause()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero) { (_) in
                self.player?.play()
            }
        }
    }
}
