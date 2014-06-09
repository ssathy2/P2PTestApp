//
//  DDDPlayerView.swift
//  P2PTestApp
//
//  Created by Sidd Sathyam on 6/6/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc class DDDPlayerView : UIView
{
	var player : AVPlayer
	var playerLayer : AVPlayerLayer
	var playerItem : AVPlayerItem

	init(playerItem item: AVPlayerItem, frame: CGRect)
	{
		self.playerItem = item
		self.player = AVPlayer(playerItem: self.playerItem)
		self.playerLayer = AVPlayerLayer(player: self.player)
		super.init(frame: frame)
		self.setupPlayerLayer()
	}
	
	func setupPlayerLayer()
	{
		self.playerLayer.frame = self.bounds
		self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		self.layer.addSublayer(self.playerLayer)
	}
}