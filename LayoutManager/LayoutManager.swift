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
    var hierarchy = Dictionary<UIView, Dictionary<SizeClassPair, [NSLayoutConstraint]>>()
    var owner:UIView
    init(view: UIView) {
        owner = view;
    }
    
    func addView(view: UIView!, size: SizeClassPair!, layout: LayoutParam!) {
        let constraints = makeConstraintsWithLayoutParam(layout, view: view)
        for constraint in constraints {
            addView(view, size: size, constraint: constraint)
        }
    }
    
    func addView(view: UIView!, size: SizeClassPair!, constraint:NSLayoutConstraint) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        if (hierarchy[view] == nil) {
            hierarchy[view] = Dictionary<SizeClassPair, [NSLayoutConstraint]>()
        }
        
        if (hierarchy[view]![size] == nil) {
            hierarchy[view]![size] = [NSLayoutConstraint]()
        }
        hierarchy[view]![size]!.append(constraint)
    }
    
    func layout() {
        layout(self.owner.traitCollection)
    }
    
    func layout(trait: UITraitCollection) {
        let targetSize: SizeClassPair = SizeClassPair(horizontal: trait.horizontalSizeClass, vertical: trait.verticalSizeClass)

        for view in hierarchy.keys {
            if view.superview == nil {
                owner.addSubview(view)
            }

            
            for size in hierarchy[view]!.keys {
                if !targetSize.contains(size) {
                    let constraints:[NSLayoutConstraint] = hierarchy[view]![size]!
                    for constraint in constraints {
                        if constraint.secondItem == nil {
                            view.removeConstraint(constraint)
                        } else {
                            owner.removeConstraint(constraint)
                        }
                    }
                }
            }
            for size in hierarchy[view]!.keys {
                if targetSize.contains(size) {
                    let constraints:[NSLayoutConstraint] = hierarchy[view]![size]!
                    for constraint in constraints {
                        if constraint.secondItem == nil {
                            view.addConstraint(constraint)
                        } else {
                            owner.addConstraint(constraint)
                        }
                    }
                }
            }
        }
    }
    
    private func makeConstraintsWithLayoutParam(param: LayoutParam, view:UIView) -> [NSLayoutConstraint] {
        var result:[NSLayoutConstraint] = []

        for key in param.keys {
            if key == .Width || key == .Height {
                result.append(NSLayoutConstraint(item: view,
                    attribute: key,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: param[key]!))
            } else {
                result.append(NSLayoutConstraint(item: view,
                    attribute: key,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: owner,
                    attribute: key,
                    multiplier: 1.0,
                    constant: param[key]!))
            }
        }
        return result
    }
}
