//
//  LayoutManager.swift
//  LayoutManagerDemo
//
//  Created by pom on 2014/09/19.
//  Copyright (c) 2014年 com.gmail.pompopo. All rights reserved.
//

import UIKit
enum LayoutType {
    case Parent, Vertical, Horizontal
}
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
typealias Rule = (UIView, SizeClassPair, LayoutParam)

class LayoutManager: NSObject {
    private var hierarchy = [Rule]()
    private let owner:UIView
    private let type:LayoutType
    private var subManagers:[LayoutManager] = [LayoutManager]()
    init(view: UIView) {
        owner = view;
        type = .Parent
    }
    
    init(view: UIView, type: LayoutType) {
        owner = view
        self.type = type
    }
    
    func addView(view: UIView, layout: LayoutParam) {
        addView(view, size: SizeClassPair.anySize(), layout: layout)
    }
    
    func addView(view: UIView!, size: SizeClassPair!, layout: LayoutParam!) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        hierarchy.append(Rule(view, size, layout))
    }
    
    func addManager(manager:LayoutManager) {
        subManagers.append(manager)
    }

    func layout() {
        let targetSize: SizeClassPair = SizeClassPair(horizontal: self.owner.traitCollection.horizontalSizeClass, vertical: self.owner.traitCollection.verticalSizeClass)

        for view in owner.subviews {
            view.removeFromSuperview()
        }


        var previousView:UIView = owner
        var currentView:UIView = owner
        for (view, _, param) in rulesContainSize(targetSize) {
            if view.superview == nil {
                self.owner.addSubview(view)
            }
            if view != currentView {
                previousView = currentView
            }
            let constraints:[NSLayoutConstraint] = constraintsWithLayoutParam(param, view: view, size: targetSize, previousView: previousView)
            currentView = view

            for constraint in constraints {
                if constraint.secondItem == nil {
                    view.addConstraint(constraint)
                } else {
                    owner.addConstraint(constraint)
                }
            }
        }
        
        for manager in subManagers {
            manager.layout()
        }
    }

    private func rulesContainSize(currentSize: SizeClassPair) -> [(UIView, SizeClassPair, LayoutParam)] {
        return hierarchy.filter({(_, size, _) in return currentSize.contains(size)})
    }
    
    private func rulesContainedBySize(currentSize: SizeClassPair) -> [(UIView, SizeClassPair, LayoutParam)] {
        return hierarchy.filter({(_, size, _) in return size.contains(currentSize)})
    }

    private func constraintsWithLayoutParam(param: LayoutParam, view:UIView, size:SizeClassPair, previousView:UIView?) -> [NSLayoutConstraint] {
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
                if (key == .Top && type == .Vertical) || (key == .Left && type == .Horizontal) {
                    var attr:NSLayoutAttribute
                    if previousView == owner {
                        attr = key
                    } else if key == .Top && type == .Vertical {
                        attr = .Bottom
                    } else if key == .Left && type == .Horizontal {
                        attr = .Right
                    } else {
                        attr = key
                    }

                    constraint = NSLayoutConstraint(item: view,
                        attribute: key,
                        relatedBy: NSLayoutRelation.Equal,
                        toItem: previousView,
                        attribute: attr,
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
            }

            result.append(constraint)
        }
        return result
    }
}
