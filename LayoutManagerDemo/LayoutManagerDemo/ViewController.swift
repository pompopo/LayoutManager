//
//  ViewController.swift
//  LayoutManagerDemo
//
//  Created by pom on 2014/09/19.
//  Copyright (c) 2014年 com.gmail.pompopo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var manager:LayoutManager? = nil;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = LayoutManager(view: self.view, type:.Vertical)
        
        var view1:UIView = UIView()
        view1.backgroundColor = UIColor.blackColor()

        self.manager?.addView(view1, size: SizeClassPair.anySize(), layout: [.Width: 100, .Height: 100, .Top: 50])

        self.manager?.addView(view1, size: SizeClassPair.iPhonePortrait(), layout: [.Left:30])
        self.manager?.addView(view1, size: SizeClassPair.iPhoneLandscape(), layout: [.Left:130])

        var view2:UIView = UIView()
        view2.backgroundColor = UIColor.grayColor()
        self.manager?.addView(view2, size: SizeClassPair.anySize(), layout: [.Width:50, .Height:50, .Left:10, .Top:10])
        
//
//        var horizontal = UIView()
//        horizontal.backgroundColor = UIColor.blueColor()
//        
//        self.manager?.addView(horizontal, layout: [.Top: 50, .Left:10, .Right:-10, .Height: 100])
        
//
//        let manager2 = LayoutManager(view: horizontal, type: .Horizontal)
//        var view3 = UIView()
//        view3.backgroundColor = UIColor.greenColor()
//        manager2 .addView(view3, layout: [.Left: 10, .Top: 10, .Bottom:10, .Width:100])
//        
//        var view4 = UIView()
//        view4.backgroundColor = UIColor.redColor()
//        manager2 .addView(view4, layout: [.Left: 10, .Top: 10, .Bottom:10, .Width:100])
//        

//                manager2.layout()

    }

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
        super.traitCollectionDidChange(previousTraitCollection);
        manager?.layout()

    }


}

