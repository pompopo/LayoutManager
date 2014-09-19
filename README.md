LayoutManager
=============
LayoutManager manages view hierarchy with AutoLayout and SizeClass.
Try Demo.
More explanation will be added.

```swift:ViewController.swift
class ViewController: UIViewController {

    var manager:LayoutManager? = nil;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = LayoutManager(view: self.view)
        
        var view1:UIView = UIView()
        view1.backgroundColor = UIColor(white: 0, alpha: 1)

        [self.manager?.addView(view1, size: SizeClassPair.anySize(), layout: [.Width: 100, .Height: 100])]
        
        [self.manager?.addView(view1, size: SizeClassPair.iPhonePortrait(), layout: [.Top: 30, .Left:30])]
        
        [self.manager?.addView(view1, size: SizeClassPair.iPhoneLandscape(), layout: [.Bottom: -30, .Right:-30])]
        
        var view2:UIView = UIView()
        view2.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        [self.manager?.addView(view2, size: SizeClassPair.anySize(), layout: [.Width:30, .Height:30, .Top: 10])]
        
        let constraint = NSLayoutConstraint(item: view2, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view1, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        [self.manager?.addView(view2, size: SizeClassPair.anySize(), constraint: constraint)]
    }

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
        super.traitCollectionDidChange(previousTraitCollection);
        self.manager?.layout(self.traitCollection)
    }
}


```
