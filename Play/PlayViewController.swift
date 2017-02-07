//
//  PlayViewController.swift
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/18.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

import UIKit

import Foundation
import AudioToolbox

class PlayViewController: BaseViewController {

    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    var touchBeginPos: CGPoint!
    let calcBrain = CalcBrain()
    @IBOutlet weak var bgView: UIView!
    var lastVCImg: UIImage! = nil
    var songInfo: SongInfo!
    var songInfos: NSMutableArray!
    var songIndex: NSInteger!
    var player: MCSimpleAudioPlayer!
    var isPlaying = false
    var rotateAnimation: POPBasicAnimation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImgView.backgroundColor = UIColor.red
        coverImgView.layer.cornerRadius = 150.0/375.0*g_screenSize.width*0.5
        coverImgView.layer.masksToBounds = true
        
        self.view.addSubview(UIImageView(image: lastVCImg))
        self.view.bringSubview(toFront: bgView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstIn {
            startPlay()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func playOrPauseBtnClicked(_ sender: UIButton) {
        if isPlaying {
            self.pause()
        }else {
            self.continuePlay()
        }
    }
    
    @IBAction func previousBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        player.stop()
        
        
        
        self.songIndex = self.songIndex + 1
        if(self.songIndex >= self.songInfos.count) {
            self.songIndex = 0
        }
        self.songInfo = songInfos[self.songIndex] as? SongInfo;
        startPlay()
    }
    
    func startPlay() {
        self.coverImgView.image = UIImage(named: songInfo.covertImg)
        singerNameLabel.text = songInfo.singerName
        nameLabel.text = songInfo.songName
        let path = Bundle.main.path(forResource: songInfo.songName, ofType: "mp3")
        player = MCSimpleAudioPlayer(filePath: path, fileType:kAudioFileMP3Type)
        
        
        coverImgView.layer.removeAllAnimations()
        let ani = CABasicAnimation(keyPath: "transform.rotation")
        ani.toValue = M_PI*2
        ani.duration = 8
        ani.repeatCount = 99999;
        coverImgView.layer.add(ani, forKey: "rotation")
        
        player.play()
        playOrPauseBtn.setBackgroundImage(UIImage(named: "pause"), for: UIControlState.normal)
        isPlaying = true
    }
    
    func pause() {
        
        let pausedTime = coverImgView.layer.convertTime(CACurrentMediaTime(), from: nil)
        coverImgView.layer.speed = 0.0
        coverImgView.layer.timeOffset = pausedTime
        player.pause()
        playOrPauseBtn.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
        isPlaying = false
    }
    
    func continuePlay() {
        let pauseTime = coverImgView.layer.timeOffset
        coverImgView.layer.speed = 1.0
        coverImgView.layer.timeOffset = 0.0
        coverImgView.layer.beginTime = 0.0
        let timeSincePause = coverImgView.layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        coverImgView.layer.beginTime = timeSincePause
        
        player.play()
        playOrPauseBtn.setBackgroundImage(UIImage(named: "pause"), for: UIControlState.normal)
        isPlaying = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchBeginPos = touches.first?.location(in: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first?.location(in: self.view)
        if calcBrain.ifMoveView(a: touchBeginPos, b: pos!) {
            self.bgView.frame.origin.x = pos!.x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first?.location(in: self.view)
        if calcBrain.calcDistance(a: touchBeginPos, b: pos!) > Double(g_screenSize.width*0.5) {
            player.stop()
            self.navigationController?.popViewController(animated: false)
        }else {
            self.bgView.frame.origin.x = 0
        }
    }
}
