//
//  LayoutManager.swift
//  LayoutManagerDemo
//
//  Created by pom on 2014/09/19.
//  Copyright (c) 2014年 com.gmail.pompopo. All rights reserved.
//

import UIKit

func ==(lhs: SizeClassPair, rhs: SizeClassPair) -> Bool {
    return lhs.horizontal == rhs.horizontal && lhs.vertical == rhs.vertical
}
struct SizeClassPair : Hashable {
    var horizontal: UIUserInterfaceSizeClass
    var vertical: UIUserInterfaceSizeClass
    
    static func iPhonePortrait() -> SizeClassPair {
        return SizeClassPair(horizontal: .Compact, vertical: .Regular)
    }
    static func iPhoneLandscape() -> SizeClassPair {
        return SizeClassPair(horizontal: .Compact, vertical: .Compact)
    }
    static func iPadPortrait() -> SizeClassPair {
        return SizeClassPair(horizontal: .Regular, vertical: .Regular)
    }
    static func iPadLandscape() -> SizeClassPair {
        return SizeClassPair(horizontal: .Regular, vertical: .Regular)
    }
    static func anySize() -> SizeClassPair {
        return SizeClassPair(horizontal: .Unspecified, vertical: .Unspecified)
    }
    var hashValue: Int {
        return 31 * horizontal.hashValue + vertical.hashValue
    }
    
    func contains(other: SizeClassPair) -> Bool {
        return self == other
            || (self.horizontal == other.horizontal && other.vertical == .Unspecified)
            || (self.vertical == other.vertical && other.horizontal == .Unspecified)
            || (other.horizontal == .Unspecified && other.vertical == .Unspecified)
    }
}

typealias LayoutParam = Dictionary<NSLayoutAttribute, CGFloat>

class LayoutManager: NSObject {
    var hierarchy2 = [(UIView, SizeClassPair, LayoutParam)]()
    var owner:UIView
    init(view: UIView) {
        owner = view;
    }
    
    func addView(view: UIView!, size: SizeClassPair!, layout: LayoutParam!) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let constraints = makeConstraintsWithLayoutParam(layout, view: view)
        hierarchy2.append((view, size, layout))

    }

    func layout() {
        let targetSize: SizeClassPair = SizeClassPair(horizontal: self.owner.traitCollection.horizontalSizeClass, vertical: self.owner.traitCollection.verticalSizeClass)

        for view in owner.subviews {
            view.removeFromSuperview()
        }

        
        for (view, _, param) in hierarchy2.filter({(_, size, _) in return targetSize.contains(size)}) {
            if view.superview == nil {
                self.owner.addSubview(view)
            }
            let constraints:[NSLayoutConstraint] = makeConstraintsWithLayoutParam(param, view: view)
            for constraint in constraints {
                if constraint.secondItem == nil {
                    view.addConstraint(constraint)
                } else {
                    owner.addConstraint(constraint)
                }
            }
        }
    }

    
    private func makeConstraintsWithLayoutParam(param: LayoutParam, view:UIView) -> [NSLayoutConstraint] {
        var result:[NSLayoutConstraint] = []

        for key in param.keys {
            var constraint:NSLayoutConstraint
            if key == .Width || key == .Height {
                constraint = NSLayoutConstraint(item: view,
                    attribute: key,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: param[key]!)
            } else {
                constraint = NSLayoutConstraint(item: view,
                    attribute: key,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: owner,
                    attribute: key,
                    multiplier: 1.0,
                    constant: param[key]!)
            }
            constraint.identifier = "com.gmail.pompopo.LayoutManager"
            result.append(constraint)
        }
        return result
    }
}
