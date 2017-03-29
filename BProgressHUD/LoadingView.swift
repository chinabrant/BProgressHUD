//
//  LoadingView.swift
//  BProgressHUDDemo
//
//  Created by brant on 2017/3/29.
//  Copyright © 2017年 brant. All rights reserved.
//

import UIKit
import CoreGraphics

class LoadingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let circle: UIBezierPath = UIBezierPath.init(ovalIn: CGRect(x: 4, y: 4, width: self.frame.size.width - 8, height: self.frame.size.height - 8))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circle.cgPath //存入UIBezierPath的路径
        shapeLayer.fillColor = UIColor.clear.cgColor //设置填充色
        shapeLayer.lineWidth = 10  //设置路径线的宽度
        shapeLayer.strokeColor = UIColor.gray.cgColor //路径颜色
        self.layer.addSublayer(shapeLayer)
        
        let colorLayer = CAGradientLayer()
        colorLayer.frame = self.bounds
        colorLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        colorLayer.startPoint = CGPoint(x: 0, y: 0)
        colorLayer.endPoint = CGPoint(x: 1, y: 0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = circle.cgPath //存入UIBezierPath的路径
        maskLayer.fillColor = UIColor.clear.cgColor //设置填充色
        maskLayer.lineWidth = 10  //设置路径线的宽度
        maskLayer.strokeColor = UIColor.orange.cgColor //路径颜色
        maskLayer.lineCap = kCALineCapRound // CGLineCap.round
        maskLayer.strokeEnd = 0.8
        
        colorLayer.mask = maskLayer
        
        self.layer.addSublayer(colorLayer)
        
        let animate = CABasicAnimation(keyPath: "transform.rotation.z")
        animate.fromValue = 0
        animate.toValue = 2 * Double.pi
        animate.duration = 2
        animate.repeatCount = Float.greatestFiniteMagnitude
        maskLayer.add(animate, forKey: "x")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        let circle: UIBezierPath = UIBezierPath.init(ovalIn: CGRect(x: 4, y: 4, width: self.frame.size.width - 8, height: self.frame.size.height - 8))
//        circle.lineWidth = 4.0
//        circle.lineCapStyle = CGLineCap.round
//        UIColor.red.setStroke()
//        circle.stroke()
    }

}
