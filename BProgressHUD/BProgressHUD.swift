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
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setActionViewMode(mode: ActionViewMode) {
        activityIndicator.isHidden = true
        activityIndicator.removeFromSuperview()
        
        actionMode = mode
        
        switch mode {
        case .Loading:
            self.backgroundColor = UIColor.clear
            activityIndicator.isHidden = false
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // set paint color
        UIColor.white.set()
        // get the context
        let currentContext = UIGraphicsGetCurrentContext()
        // set line width
        currentContext?.setLineWidth(5.0)
        
        switch actionMode {
        case .Loading:
            
            break
        case .Failed:
            currentContext?.move(to: CGPoint(x: 8, y: 8))
            currentContext?.move(to: CGPoint(x: 22, y: 22))
            currentContext?.move(to: CGPoint(x: 15, y: 15))
            currentContext?.move(to: CGPoint(x: 22, y: 8))
            currentContext?.move(to: CGPoint(x: 8, y: 22))
            currentContext?.strokePath()
            break
        case .Success:
            currentContext?.setLineJoin(CGLineJoin.round)
            currentContext?.move(to: CGPoint(x: 7, y: 15))
            currentContext?.addLine(to: CGPoint(x: 14, y: 20))
            currentContext?.addLine(to: CGPoint(x: 24, y: 7))
            currentContext?.strokePath()
            
            break
        }
        
    }
}

public enum BProgressHUDMode {
    case Loading            // only loading
    case LoadingWithMessage // loading and message
    case SuccessMessage     //
    case FailedMessage
    case OnlyMessage
}

public class BProgressHUD: NSObject {
    var backView: UIView!  // the fullscreen back
    var backColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0) // the fullscreen back color
    var messageBackView: UIView! // the hud back
    var messageBackColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) // hud back color
    
    var dismissBlock: (() -> Void)? // the hud dismiss block
    var actionView: ActionView?
    
    var messageLabel: UILabel?
    var message: String?
    var messageLabelFont: CGFloat = 15
    var messageLabelColor = UIColor.white
    let MIN_WIDTH: CGFloat = 80 // the message back view min width
    
    var progressMode: BProgressHUDMode = .Loading
    
    override init() {
        super.init()
        backView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backView.backgroundColor = backColor
//        backView.userInteractionEnabled = false
        
        messageBackView = UIView(frame: CGRect(x: 0, y: 0, width: MIN_WIDTH, height: 80))
        messageBackView.layer.cornerRadius = 8
        messageBackView.layer.masksToBounds = true
        messageBackView.backgroundColor = messageBackColor
        messageBackView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 40)
        backView.addSubview(messageBackView)
        
        actionView = ActionView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        actionView!.center = CGPoint(x: messageBackView.frame.size.width / 2, y: 28)
        messageBackView.addSubview(actionView!)
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: messageBackView.frame.size.width, height: 20))
        messageLabel?.font = UIFont.systemFont(ofSize: messageLabelFont)
        messageLabel?.textColor = messageLabelColor
        messageLabel?.textAlignment = NSTextAlignment.center
        messageBackView.addSubview(messageLabel!)
    }
    
    // text width
    class func getTextWidth(text: NSString, font: UIFont) -> CGFloat {
        let textSize: CGSize = text.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSFontAttributeName: font], context: nil).size
        
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
        actionView?.isHidden = false
        
        switch progressMode {
        case .Loading:
            messageLabel?.text = ""
            actionView?.isHidden = false
            
            messageBackView.frame.size.height = 80
            messageBackView.frame.size.width = MIN_WIDTH
            actionView?.center = CGPoint(x: self.messageBackView.frame.size.width / 2, y: self.messageBackView.frame.size.height / 2)
            messageBackView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 40)
            break
        case .LoadingWithMessage:
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(text: message! as NSString, font: UIFont.systemFont(ofSize: messageLabelFont))
            }
            
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageBackView.frame.size.height = 80
            messageLabel?.frame = CGRect(x: 0, y: messageBackView.frame.size.height - 30, width: messageBackView.frame.size.width, height: 20)
            
            actionView?.center = CGPoint(x: self.messageBackView.frame.size.width / 2, y: 28)
            messageBackView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 40)
            
            break
        case .SuccessMessage:
            
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(text: message! as NSString, font: UIFont.systemFont(ofSize: messageLabelFont))
            }
            
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageBackView.frame.size.height = 80
            messageLabel?.frame = CGRect(x: 0, y: messageBackView.frame.size.height - 30, width: messageBackView.frame.size.width, height: 20)
            
            actionView?.center = CGPoint(x: self.messageBackView.frame.size.width / 2, y: 28)
            messageBackView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 40)
            break
        case .FailedMessage:
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(text: message! as NSString, font: UIFont.systemFont(ofSize: messageLabelFont))
            }
            
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageBackView.frame.size.height = 80
            messageLabel?.frame = CGRect(x:0, y: messageBackView.frame.size.height - 30, width: messageBackView.frame.size.width, height: 20)
            actionView?.center = CGPoint(x: self.messageBackView.frame.size.width / 2, y: 28)
            messageBackView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 40)
            break
        
        case .OnlyMessage:
            actionView?.isHidden = true
            var messageWidth: CGFloat = 0
            if message != nil {
                messageWidth = BProgressHUD.getTextWidth(text: message! as NSString, font: UIFont.systemFont(ofSize: messageLabelFont))
            }
            
            messageBackView.frame.size.height = 60
            if messageWidth > MIN_WIDTH {
                messageBackView.frame.size.width = messageWidth + 10
            } else {
                messageBackView.frame.size.width = MIN_WIDTH
            }
            
            messageLabel?.frame = CGRect(x: 0, y: 0, width: messageBackView.frame.size.width, height: messageBackView.frame.size.height)
            messageBackView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 40)
            break
        }
    }
    
    class func showLoadingView() {
        showLoadingViewWithMessage(msg: nil)
    }
    
    class func showLoadingViewWithMessage(msg: String?) {
        let hud = BProgressHUD.sharedInstance
        hud.message = msg
        hud.messageLabel?.text = msg
        hud.actionView?.setActionViewMode(mode: .Loading)
        hud.progressMode = .LoadingWithMessage
        if msg == nil {
            hud.progressMode = .Loading
        }
        
        hud.layoutSubviews()
        hud.show()
    }
    
    class func showOnlyMessageAutoHide(delay: TimeInterval, msg: String, dismissBlock: (() -> Void)?) {
        let hud = BProgressHUD.sharedInstance
        hud.dismissBlock = dismissBlock
        hud.message = msg
        
        hud.actionView?.setActionViewMode(mode: .Success)
        hud.progressMode = .OnlyMessage
        hud.messageLabel?.text = msg
        hud.layoutSubviews()
        
        hud.show()
        hud.dismiss(delay: delay)
    }
    
    class func showSuccessMessageAutoHide(delay: TimeInterval, msg: String) {
        BProgressHUD.showSuccessMessageAutoHide(delay: delay, msg: msg, dismissBlock: nil)
    }
    
    class func showSuccessMessageAutoHide(delay: TimeInterval, msg: String, dismissBlock: (() -> Void)?) {
        let hud = BProgressHUD.sharedInstance
        hud.dismissBlock = dismissBlock
        hud.message = msg
        
        hud.actionView?.setActionViewMode(mode: .Success)
        hud.progressMode = .SuccessMessage
        hud.messageLabel?.text = msg
        hud.layoutSubviews()
        
        hud.show()
        hud.dismiss(delay: delay)
    }
    
    class func showErrorMessageAutoHide(delay: TimeInterval, msg: String, dismissBlock: (() -> Void)?) {
        let hud = BProgressHUD.sharedInstance
        hud.dismissBlock = dismissBlock
        hud.message = msg
        
        hud.actionView?.setActionViewMode(mode: .Failed)
        hud.progressMode = .FailedMessage
        hud.messageLabel?.text = msg
        hud.layoutSubviews()
        
        hud.show()
        hud.dismiss(delay: delay)
    }
    
    func show() {
        DispatchQueue.main.async {
            let pv: UIView = UIApplication.shared.keyWindow!.subviews.first! as UIView
            pv.addSubview(self.backView)
        }
    }
    
    class func dismissHUD(delay: TimeInterval) {
        let hud = BProgressHUD.sharedInstance
        hud.dismiss(delay: delay)
    }
    
    func dismiss(delay: TimeInterval) {
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(BProgressHUD.dismiss as (BProgressHUD) -> () -> ()), userInfo: nil, repeats: false)
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            if self.backView.superview != nil {
                self.backView.removeFromSuperview()
                if self.dismissBlock != nil {
                    self.dismissBlock!()
                    self.dismissBlock = nil
                }
                
            }
        }
        
    }
    
}
