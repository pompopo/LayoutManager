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
            self.manager = LayoutManager(view: self.view, type:.Vertical)

            var blackView:UIView = UIView()
            blackView.backgroundColor = UIColor.blackColor()
            var grayView:UIView = UIView()
            grayView.backgroundColor = UIColor.grayColor()
            var blueView = UIView()
            blueView.backgroundColor = UIColor.blueColor()
            var greenView = UIView()
            greenView.backgroundColor = UIColor.greenColor()
            var redView = UIView()
            redView.backgroundColor = UIColor.redColor()

            self.manager?.addView(blackView, size: SizeClassPair.anySize(), layout: [.Width: 100, .Height: 100, .Top: 50])
            self.manager?.addView(blackView, size: SizeClassPair.iPhonePortrait(), layout: [.Left:30])
            self.manager?.addView(blackView, size: SizeClassPair.iPhoneLandscape(), layout: [.Right:-30])

            self.manager?.addView(grayView, size: SizeClassPair.anySize(), layout: [.Width:50, .Height:50, .Left:30, .Top:10])

            self.manager?.addView(blueView, layout: [.Top: 50, .Left:10, .Right:-10, .Height: 100])


            let manager2 = LayoutManager(view: blueView, type: .Horizontal)

            manager2 .addView(greenView, size: SizeClassPair.iPhonePortrait(),layout: [.Left: 10, .Top: 10, .Bottom:-10, .Width:100])

            manager2 .addView(redView, layout: [.Left: 10, .Top: 10, .Bottom:-10, .Width:100])

            manager?.addManager(manager2)
    }

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
        super.traitCollectionDidChange(previousTraitCollection);
        manager?.layout()
    }
}
```
