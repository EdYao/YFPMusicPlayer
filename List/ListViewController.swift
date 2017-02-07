//
//  ViewController.swift
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/10.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {

    var descriptionView: DescriptionListView!
    var scrollView: UIScrollView!
    var images: NSMutableArray!
    var selectedImg: UIImageView!
    let scrollViewScaleValue = CGFloat(0.4)
    var aniKeyIndex: NSInteger!
    var songInfos: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(247.0/255.0), alpha: CGFloat(1))
        
        songInfos = NSMutableArray()
        
        let songInfo1 = SongInfo()
        songInfo1.initial(songName: "真心英雄 (Live)-李宗盛", covertImg: "真心英雄", singerName: "李宗盛", albumName: "理性与感性作品音乐会")
        songInfos.add(songInfo1)
        
        let songInfo2 = SongInfo()
        songInfo2.initial(songName: "一千个世纪-五月天", covertImg: "一千个世纪", singerName: "五月天", albumName: "为爱而生")
        songInfos.add(songInfo2)
        
        let songInfo3 = SongInfo()
        songInfo3.initial(songName: "我终于失去了你 (Live)-李宗盛", covertImg: "我终于失去了你", singerName: "李宗盛", albumName: "理性与感性作品音乐会")
        songInfos.add(songInfo3)
        
        let songInfo4 = SongInfo()
        songInfo4.initial(songName: "真心英雄 (Live)-李宗盛", covertImg: "真心英雄", singerName: "李宗盛", albumName: "理性与感性作品音乐会")
        songInfos.add(songInfo4)
        
        let songInfo5 = SongInfo()
        songInfo5.initial(songName: "一千个世纪-五月天", covertImg: "一千个世纪", singerName: "五月天", albumName: "为爱而生")
        songInfos.add(songInfo5)
        
        let songInfo6 = SongInfo()
        songInfo6.initial(songName: "我终于失去了你 (Live)-李宗盛", covertImg: "我终于失去了你", singerName: "李宗盛", albumName: "理性与感性作品音乐会")
        songInfos.add(songInfo6)
        
        images = NSMutableArray()
        aniKeyIndex = 1
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstIn {
            initViews()
            isFirstIn = false
        }
    }
    
    func initViews() {
        let btn = UIButton(frame: CGRect(x: 0, y: 25, width: 30, height: 30))
        btn.setImage(UIImage(named: "back_img"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        
        descriptionView = DescriptionListView(frame: CGRect(x: 0, y: g_screenSize.height*0.6, width: g_screenSize.width, height: g_screenSize.height*scrollViewScaleValue))
        descriptionView.initLabels()
        self.view.addSubview(descriptionView)
        scrollView = UIScrollView()
        scrollView.frame = UIScreen.main.bounds
        var imageViewPosY = CGFloat(0.0)
        var index = 0
        for info in songInfos {
            let songInfo = info as! SongInfo
            let imageView = UIImageView(image: UIImage(named: songInfo.covertImg))
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(imageViewPosY), width: g_screenSize.width, height: g_screenSize.width)
            imageViewPosY += g_screenSize.width
            self.images.add(imageView)
            imageView.tag = index
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickedImg))
            imageView.addGestureRecognizer(tapGes)
            imageView.isUserInteractionEnabled = true
            index += 1
        }
        scrollView.contentSize = CGSize(width: g_screenSize.width, height: imageViewPosY)
        self.view.addSubview(scrollView)
    }
    
    func back() {
        var imageViewPosY = CGFloat(0.0)
        for img in images {
            let imageView = img as! UIImageView
            imageView.removeFromSuperview()
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: CGFloat(0), y: imageViewPosY, width: g_screenSize.width, height: g_screenSize.width)
            imageViewPosY += g_screenSize.width
        }
        scrollView.contentSize = CGSize(width: g_screenSize.width, height: imageViewPosY)
        self.selectedImg = nil
        self.descriptionView.resetLabels()
        self.descriptionView.isHidden = true
        self.scrollView.scrollRectToVisible(CGRect(x: CGFloat(0), y: CGFloat(0), width: g_screenSize.width, height: g_screenSize.height), animated: true)
        self.scaleView(view: scrollView, fromValue: CGPoint(x: scrollViewScaleValue, y: scrollViewScaleValue), toValue: CGPoint(x: 1.0, y: 1.0))
        self.moveViewByPop(view: scrollView, from: scrollView.frame, to: self.view.bounds)
    }
    
    func clickedImg(_ ges: UITapGestureRecognizer) {
        if (selectedImg != nil) && (selectedImg == ges.view) {
            self.gotoPlayViewController()
        }else if(selectedImg != nil) {
            let selectImgFrame = self.selectedImg.frame
            //move the selected img to the place of clicking img.将上次选中的图片移动到当前点击的图片（在scrollView中）的位置
            let clickingView = ges.view as! UIImageView
            let posY = scrollView.frame.origin.y + (clickingView.frame.origin.y - scrollView.contentOffset.y)*scrollViewScaleValue
            let toValue = CGRect(x: scrollView.frame.origin.x, y: posY, width: scrollView.frame.size.width, height: scrollView.frame.size.width)
            moveViewByPop(view: selectedImg, from: selectedImg.frame, to: toValue)
            
            let clickingViewFrame = clickingView.frame
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedImg.removeFromSuperview()
                self.scrollView.addSubview(self.selectedImg)
                self.selectedImg.frame = clickingViewFrame
                self.selectedImg = clickingView
            }
            
            //move the clicking img to the place of the selected img.将点钱点击的图片移动到上次选中的图片的位置
            clickingView.removeFromSuperview()
            self.view.addSubview(clickingView)
            clickingView.frame = CGRect(x: scrollView.frame.origin.x, y: posY, width: g_screenSize.width*scrollViewScaleValue, height: g_screenSize.width*scrollViewScaleValue)
            self.moveViewByPop(view: clickingView, from: clickingView.frame, to: selectImgFrame)
            
            let songInfo = songInfos[clickingView.tag] as! SongInfo
            self.descriptionView.updateWithSongInfo(songInfo: songInfo)
            
        }else {
            //Remove the clicking img from scrollView,add it to the root view,and reset the frame,then run the moving animation.将当前点击的UIImageView从ScrollView中移除，添加到根视图中，重新设置位置,再执行移动的动画
            var posY = CGFloat(0.0)
            var index = -1
            for img in images {
                let imageView = (img as! UIImageView)
                if imageView.tag == ges.view?.tag {
                    index = imageView.tag
                    imageView.removeFromSuperview()
                    self.view.addSubview(imageView)
                    NSLog("%@", NSValue(cgPoint: scrollView.contentOffset));
                    imageView.frame.origin = CGPoint(x: CGFloat(0), y: CGFloat(imageView.frame.origin.y - scrollView.contentOffset.y))
                    let toValue = CGRect(x: CGFloat(10), y: CGFloat(64), width: g_screenSize.width*0.5, height: g_screenSize.width*0.5)
                    self.moveViewByPop(view: imageView, from: imageView.frame, to: toValue)
                    selectedImg = imageView
                }else {
                    imageView.frame.origin = CGPoint(x: CGFloat(0.0), y: posY)
                    posY += g_screenSize.width
                }
            }
            scrollView.contentSize = CGSize(width: g_screenSize.width, height: posY)
            scrollView.frame = CGRect(x: 0, y: 0, width: g_screenSize.width, height: g_screenSize.height*2)
            
            self.scaleView(view: scrollView, fromValue: CGPoint(x: 1.0, y: 1.0), toValue: CGPoint(x: scrollViewScaleValue, y: scrollViewScaleValue))
            let toValue = CGRect(x: g_screenSize.width*(1 - scrollViewScaleValue), y: 20, width: g_screenSize.width*scrollViewScaleValue, height: g_screenSize.height*(1 - scrollViewScaleValue))
            moveViewByPop(view: scrollView, from: scrollView.frame, to: toValue)
            descriptionView.isHidden = false
            
            let songInfo = songInfos[index] as! SongInfo
            descriptionView.updateWithSongInfo(songInfo: songInfo)
            descriptionView.performEffect()
        }
    }
    
    func scaleView(view: UIView, fromValue: CGPoint, toValue: CGPoint) {
        view.pop_removeAnimation(forKey: "scale")
        let ani = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        ani?.duration = 0.5
        ani?.fromValue = fromValue
        ani?.toValue = toValue
        ani?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.pop_add(ani, forKey: "scale")
    }
    
    func moveViewByPop(view: UIView, from: CGRect, to: CGRect) {
        let ani = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        ani?.duration = 0.5
        ani?.fromValue = from
        ani?.toValue = to
        ani?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.pop_add(ani, forKey: String(aniKeyIndex))
        aniKeyIndex = aniKeyIndex + 1;
    }
    
    func gotoPlayViewController() {
        let keyWindow = UIApplication.shared.keyWindow
        UIGraphicsBeginImageContext(g_screenSize)
        let context = UIGraphicsGetCurrentContext()
        keyWindow?.layer.render(in: context!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let vc = PlayViewController(nibName: "PlayViewController", bundle: nil)
        vc.lastVCImg = img
        vc.songInfo = self.songInfos[selectedImg.tag] as? SongInfo
        vc.songInfos = self.songInfos
        vc.songIndex = selectedImg.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

