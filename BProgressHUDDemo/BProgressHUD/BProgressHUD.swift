//
//  BProgressHUD.swift
//  BProgressHUDDemo
//
//  Created by Brant on 5/26/15.
//  Copyright (c) 2015 brant. All rights reserved.
//

import UIKit

enum ActionViewMode {
    case Success
    case Failed
    case Loading
}

class ActionView: UIView {
    
    var isSuccess: Bool = true
    private var actionMode: ActionViewMode = .Loading
    var activityIndicator = UIActivityIndicatorView()
    
    // 30 X 30
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(red: 39/255.0, green: 183/255.0, blue: 42/255.0, alpha: 1)
        
        
        activityIndicator.frame = self.bounds
        activityIndicator.startAnimating()
        activityIndicator.hidden = true
        addSubview(activityIndicator)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setActionViewMode(mode: ActionViewMode) {
        activityIndicator.hidden = true
        activityIndicator.removeFromSuperview()
        
        actionMode = mode
        
        switch mode {
        case .Loading:
            self.backgroundColor = UIColor.clearColor()
            activityIndicator.hidden = false
            addSubview(activityIndicator)
            break
            
        case .Success:
            self.backgroundColor = UIColor(red: 39/255.0, green: 183/255.0, blue: 42/255.0, alpha: 1)
            break
            
        case .Failed:
            
            self.backgroundColor = UIColor(red: 236/255.0, green: 96/255.0, blue: 98/255.0, alpha: 1)
            break
            
        default:
            
            break
            
        }
        
        setNeedsDisplay()
    }

    
    func setSuccess(suc: Bool) {
        self.isSuccess = suc
        if suc {
            self.backgroundColor = UIColor(red: 39/255.0, green: 183/255.0, blue: 42/255.0, alpha: 1)
        } else {
            self.backgroundColor = UIColor(red: 236/255.0, green: 96/255.0, blue: 98/255.0, alpha: 1)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // set paint color
        UIColor.whiteColor().set()
        // get the context
        var currentContext = UIGraphicsGetCurrentContext()
        // set line width
        CGContextSetLineWidth(currentContext,5.0)
        
        switch actionMode {
        case .Loading:
            
            break
        case .Failed:
            CGContextMoveToPoint(currentContext, 8, 8)
            CGContextAddLineToPoint(currentContext, 22, 22)
            CGContextAddLineToPoint(currentContext, 15, 15)
            CGContextAddLineToPoint(currentContext, 22, 8)
            CGContextAddLineToPoint(currentContext, 8, 22)
            CGContextStrokePath(currentContext)
            break
        case .Success:
            CGContextSetLineJoin(currentContext, kCGLineJoinRound)
            CGContextMoveToPoint(currentContext, 7, 15)
            CGContextAddLineToPoint(currentContext, 14, 20)
            CGContextAddLineToPoint(currentContext, 24, 7)
            CGContextStrokePath(currentContext)
            break
        }
        
    }
}

enum BProgressHUDMode {
    case Loading            // only loading
    case LoadingWithMessage // loading and message
    case SuccessMessage     //
    case FailedMessage
    case OnlyMessage
}

class BProgressHUD: NSObject {
    var backView: UIView!  // the fullscreen back
    var backColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0) // the fullscreen back color
    var messageBackView: UIView! // the hud back
    var messageBackColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) // hud back color
    
    var dismissBlock: (() -> Void)? // the hud dismiss block
    var actionView: ActionView?
    
    var messageLabel: UILabel?
    var message: String?
    var messageLabelFont: CGFloat = 15
    var messageLabelColor = UIColor.whiteColor()
    let MIN_WIDTH: CGFloat = 80 // the message back view min width
    
    var progressMode: BProgressHUDMode = .Loading
    
    override init() {
        super.init()
        backView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        backView.backgroundColor = backColor
//        backView.userInteractionEnabled = false
        
        messageBackView = UIView(frame: CGRectMake(0, 0, MIN_WIDTH, 80))
        messageBackView.layer.cornerRadius = 8
        messageBackView.layer.masksToBounds = true
        messageBackView.backgroundColor = messageBackColor
        messageBackView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2 - 40)
        backView.addSubview(messageBackView)
        
        actionView = ActionView(frame: CGRectMake(0, 0, 30, 30))
        actionView!.center = CGPointMake(messageBackView.frame.size.width / 2, 28)
        messageBackView.addSubview(actionView!)
        
        messageLabel = UILabel(frame: CGRectMake(0, 0, messageBackView.frame.size.width, 20))
        messageLabel?.font = UIFont.systemFontOfSize(messageLabelFont)
        messageLabel?.textColor = messageLabelColor
        messageLabel?.textAlignment = NSTextAlignment.Center
        messageBackView.addSubview(messageLabel!)
    }
    
    // text width
    class func getTextWidth(text: NSString, font: UIFont) -> CGFloat {
        var textSize: CGSize = text.boundingRectWithSize(CGSizeMake(CGFloat.max, 20), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName: font], context: nil).size
        
        return textSize.width
    }

    
    // singleton
    class var sharedInstance : BProgressHUD {
        struct Static {
            static let instance : BProgressHUD = BProgressHUD()
        }
        
        return Static.instance
    }
    
    func layoutSubviews() {
        actionView?.hidden = false
        
        switch progressMode {
        case .Loading:
            messageLabel?.text = ""
            actionView?.hidden = false
            
            messageBackView.frame.size.height = 80
            messageBackView.frame.size.width = MIN_WIDTH
            actionView?.center = CGPointMake(self.messageBackView.frame.size.width / 2, self.messageBackView.frame.size.height / 2)
            messageBackView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2 - 40)
            break
        case .LoadingWithMessage:
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(message!, font: UIFont.systemFontOfSize(messageLabelFont))
            }
            
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageBackView.frame.size.height = 80
            messageLabel?.frame = CGRectMake(0, messageBackView.frame.size.height - 30, messageBackView.frame.size.width, 20)
            
            actionView?.center = CGPointMake(self.messageBackView.frame.size.width / 2, 28)
            messageBackView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2 - 40)
            
            break
        case .SuccessMessage:
            
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(message!, font: UIFont.systemFontOfSize(messageLabelFont))
            }
            
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageBackView.frame.size.height = 80
            messageLabel?.frame = CGRectMake(0, messageBackView.frame.size.height - 30, messageBackView.frame.size.width, 20)
            
            actionView?.center = CGPointMake(self.messageBackView.frame.size.width / 2, 28)
            messageBackView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2 - 40)
            break
        case .FailedMessage:
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(message!, font: UIFont.systemFontOfSize(messageLabelFont))
            }
            
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageBackView.frame.size.height = 80
            messageLabel?.frame = CGRectMake(0, messageBackView.frame.size.height - 30, messageBackView.frame.size.width, 20)
            actionView?.center = CGPointMake(self.messageBackView.frame.size.width / 2, 28)
            messageBackView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2 - 40)
            break
        
        case .OnlyMessage:
            actionView?.hidden = true
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(message!, font: UIFont.systemFontOfSize(messageLabelFont))
            }
            
            messageBackView.frame.size.height = 60
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageLabel?.frame = CGRectMake(0, 0, messageBackView.frame.size.width, messageBackView.frame.size.height)
            messageBackView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2 - 40)
            break
        }
    }
    
    class func showLoadingView() {
        showLoadingViewWithMessage(nil)
    }
    
    class func showLoadingViewWithMessage(msg: String?) {
        var hud = BProgressHUD.sharedInstance
        hud.message = msg
        hud.messageLabel?.text = msg
        hud.actionView?.setActionViewMode(.Loading)
        hud.progressMode = .LoadingWithMessage
        if msg == nil {
            hud.progressMode = .Loading
        }
        
        hud.layoutSubviews()
        hud.show()
    }
    
    class func showOnlyMessageAutoHide(delay: NSTimeInterval, msg: String, dismissBlock: (() -> Void)?) {
        var hud = BProgressHUD.sharedInstance
        hud.dismissBlock = dismissBlock
        hud.message = msg
        
        hud.actionView?.setActionViewMode(.Success)
        hud.progressMode = .OnlyMessage
        hud.messageLabel?.text = msg
        hud.layoutSubviews()
        
        hud.show()
        hud.dismiss(delay)
    }
    
    class func showSuccessMessageAutoHide(delay: NSTimeInterval, msg: String) {
        BProgressHUD.showSuccessMessageAutoHide(delay, msg: msg, dismissBlock: nil)
    }
    
    class func showSuccessMessageAutoHide(delay: NSTimeInterval, msg: String, dismissBlock: (() -> Void)?) {
        var hud = BProgressHUD.sharedInstance
        hud.dismissBlock = dismissBlock
        hud.message = msg
        
        hud.actionView?.setActionViewMode(.Success)
        hud.progressMode = .SuccessMessage
        hud.messageLabel?.text = msg
        hud.layoutSubviews()
        
        hud.show()
        hud.dismiss(delay)
    }
    
    class func showErrorMessageAutoHide(delay: NSTimeInterval, msg: String, dismissBlock: (() -> Void)?) {
        var hud = BProgressHUD.sharedInstance
        hud.dismissBlock = dismissBlock
        hud.message = msg
        
        hud.actionView?.setActionViewMode(.Failed)
        hud.progressMode = .FailedMessage
        hud.messageLabel?.text = msg
        hud.layoutSubviews()
        
        hud.show()
        hud.dismiss(delay)
    }
    
    func show() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var pv: UIView = UIApplication.sharedApplication().keyWindow?.subviews.first as! UIView
            pv.addSubview(self.backView)
        })
    }
    
    class func dismissHUD(delay: NSTimeInterval) {
        var hud = BProgressHUD.sharedInstance
        hud.dismiss(delay)
    }
    
    func dismiss(delay: NSTimeInterval) {
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "dismiss", userInfo: nil, repeats: false)
    }
    
//    func dismiss(delay: NSTimeInterval, animated: Bool) {
//        if animated {
//            NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "dismissAnimated", userInfo: nil, repeats: false)
//        } else {
//            NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "dismiss", userInfo: nil, repeats: false)
//        }
//    }
    
    func dismiss() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
//            println("dismiss alert view")
            if self.backView.superview != nil {
                self.backView.removeFromSuperview()
                if self.dismissBlock != nil {
                    self.dismissBlock!()
                    self.dismissBlock = nil
                }
                
            }
        })
        
    }
    
}
