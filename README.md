# BProgressHUD
A lightenweight progress hud with dismiss callback by swift. Easy to modify.

# Requirements
iOS7 or higher

# HOW TO USE

```
	BProgressHUD.showLoadingView()
        BProgressHUD.dismissHUD(5)

	BProgressHUD.showSuccessMessageAutoHide(2, msg: "test", dismissBlock: { () -> Void in
                
        })

	BProgressHUD.showOnlyMessageAutoHide(2, msg: "only message", dismissBlock: nil)
```

# Effects
* showLoadingView
![showLoadingView](http://ww4.sinaimg.cn/mw690/acbce940gw1esiks92fbcj20ku112abx.jpg)

* showErrorMessageAutoHide
![showErrorMessageAutoHide](http://ww3.sinaimg.cn/mw690/acbce940gw1esiksaatf0j20ku112mz4.jpg)

# Podfile
If you use CocoaPods, you can install the latest release version of BProgressHUD by adding the following to your project's Podfile:
```
pod 'BProgressHUD'
```
# LICENSE
BBannerView is licensed under the MIT License.
