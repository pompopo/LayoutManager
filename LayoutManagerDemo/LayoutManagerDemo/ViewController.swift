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
        self.manager = LayoutManager(view: self.view)
        
        var view1:UIView = UIView()
        view1.backgroundColor = UIColor(white: 0, alpha: 1)

        self.manager?.addView(view1, size: SizeClassPair.anySize(), layout: [.Width: 100, .Height: 100])

        self.manager?.addView(view1, size: SizeClassPair.iPhonePortrait(), layout: [.Top: 30, .Left:30])
        self.manager?.addView(view1, size: SizeClassPair.iPhoneLandscape(), layout: [.Bottom: -30, .Right:-30])

    }

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
        super.traitCollectionDidChange(previousTraitCollection);
                self.manager?.layout()
    }


}

