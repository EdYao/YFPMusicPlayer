//
//  DescriptionListView.swift
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/12.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

import UIKit

class DescriptionListView: UIView {
    
    var labels: NSMutableArray!
    var labelHolderArr: NSArray!
    var strings: NSArray!
    
    func initLabels() {
        self.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(247.0/255.0), alpha: CGFloat(1))
        labels = NSMutableArray()
        for i in 0...3 {
            let label = UILabel(frame: CGRect(x: CGFloat(20.0), y: frame.size.height, width: frame.size.width*0.8, height: 20))
            label.text = ""
            label.textColor = UIColor.black
            labels.add(label)
            self.addSubview(label)
        }
        self.labelHolderArr = NSArray(array: labels)
    }
    
    func updateWithSongInfo(songInfo: SongInfo) {
        var label = labels[0] as? UILabel
        label?.text = songInfo.songName
        label = labels[1] as? UILabel
        label?.text = songInfo.singerName
        label = labels[2] as? UILabel
        label?.text = songInfo.singerName
        label = labels[3] as? UILabel
        label?.text = songInfo.albumName
    }
    
    func performEffect() {
        for i in 0...3 {
            self.perform(#selector(animation), with: self, afterDelay: 0.5 + 0.05*Double(i))
        }
    }
    
    func animation() {
        assert(labels != nil && labels.count > 0, "labels cannot be nil or empty")
        let labelNum = labels.count
        let index = 4 - labelNum
        let label = labels[0] as! UILabel
        let ani = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        ani?.duration = 0.3 + Double(index)*0.05
        ani?.fromValue = label.frame
        ani?.toValue = CGRect(x: CGFloat(20.0), y: (CGFloat((0.5 + Double(index))/4.0))*self.frame.size.height - 10.0, width: label.frame.size.width, height: label.frame.size.height)
        label.pop_add(ani, forKey: "")
        
        labels.remove(label)
        if labels.count == 0 {
            labels = NSMutableArray(array: self.labelHolderArr)
        }
    }
    
    func resetLabels() {
        labels = NSMutableArray(array: self.labelHolderArr)
        for label in labels {
            (label as! UILabel).frame = CGRect(x: CGFloat(20.0), y: frame.size.height, width: frame.size.width*0.8, height: 20)
        }
    }
}
