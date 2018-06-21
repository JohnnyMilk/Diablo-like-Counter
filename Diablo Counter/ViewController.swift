//
//  ViewController.swift
//  Diablo Counter
//
//  Created by Johnny Wang on 2018/6/19.
//  Copyright © 2018年 Johnny Wang. All rights reserved.
//

import UIKit

enum FillingType {
    case health
    case essence
}

class ViewController: UIViewController {
    @IBOutlet weak var healthView: UIView!
    @IBOutlet weak var essenceView: UIView!
    @IBOutlet weak var healthCounterView: UIView!
    @IBOutlet weak var essenceCounterView: UIView!
    
    var healthFillingView: UIImageView!
    var essenceFillingView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(viewDidDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc private func viewDidDoubleTap() {
        let hFrame = healthFillingView.frame
        healthFillingView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        healthFillingView.frame = hFrame
        
        let eFrame = essenceFillingView.frame
        essenceFillingView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        essenceFillingView.frame = eFrame
        
        let hRandom = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let hHeight = healthCounterView.frame.height * hRandom
        
        let eRandom = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let eHeight = essenceCounterView.frame.height * eRandom
        
        let width = healthCounterView.frame.width
        
        UIView.animate(withDuration: 1.0) {
            self.healthFillingView.bounds.size = CGSize(width: width, height: hHeight)
            self.essenceFillingView.bounds.size = CGSize(width: width, height: eHeight)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        healthCountViewSetting()
        essenceCountViewSetting()
    }
    
    private func healthCountViewSetting() {
        // Background
        let background = UIImageView(frame: healthCounterView.bounds)
        background.contentMode = .scaleAspectFit
        background.image = getBackgroundImage(type: .health)
        healthCounterView.addSubview(background)

        // Filling
        healthFillingView = UIImageView(frame: healthCounterView.bounds)
        healthFillingView.contentMode = .bottom
        healthFillingView.clipsToBounds = true
        
        let filling = getFillingImage(type: .health)
        healthFillingView.image = getResizedImage(image: filling, newSize: healthCounterView.frame.size)!
        healthCounterView.addSubview(healthFillingView)
        
        // Gloss
        let gloss = UIImageView(frame: healthCounterView.bounds)
        gloss.contentMode = .scaleAspectFit
        gloss.image = getGlossImage()
        healthCounterView.addSubview(gloss)
    }
    
    private func essenceCountViewSetting() {
        // Background
        let background = UIImageView(frame: essenceCounterView.bounds)
        background.contentMode = .scaleAspectFit
        background.image = getBackgroundImage(type: .essence)
        essenceCounterView.addSubview(background)
        
        // Filling
        essenceFillingView = UIImageView(frame: healthCounterView.bounds)
        essenceFillingView.contentMode = .bottom
        essenceFillingView.clipsToBounds = true
        
        let filling = getFillingImage(type: .essence)
        essenceFillingView.image = getResizedImage(image: filling, newSize: essenceCounterView.frame.size)!
        essenceCounterView.addSubview(essenceFillingView)
        
        // Gloss
        let gloss = UIImageView(frame: healthCounterView.bounds)
        gloss.contentMode = .scaleAspectFit
        gloss.image = getGlossImage()
        essenceCounterView.addSubview(gloss)
    }
    
    private func getResizedImage(image: UIImage?, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    private func getBackgroundImage(type: FillingType) -> UIImage? {
        let r: [CGFloat]
        let g: [CGFloat]
        let b: [CGFloat]
        
        switch type {
        case .health:
            r = [1.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            g = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            b = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        case .essence:
            r = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            g = [0.0, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            b = [0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        }
    
        let fillingImage = CIImage(image: UIImage(named: "counter background")!)
        let hueFilter = CIFilter(name: "CIColorCrossPolynomial")
        hueFilter?.setValue(fillingImage, forKey: kCIInputImageKey)
        hueFilter?.setValue(CIVector(values: r, count: r.count), forKey: "inputRedCoefficients")
        hueFilter?.setValue(CIVector(values: g, count: g.count), forKey: "inputGreenCoefficients")
        hueFilter?.setValue(CIVector(values: b, count: b.count), forKey: "inputBlueCoefficients")
        
        return UIImage(ciImage: (hueFilter?.outputImage)!)
    }
    
    private func getFillingImage(type: FillingType) -> UIImage? {
        let r: [CGFloat]
        let g: [CGFloat]
        let b: [CGFloat]
        
        switch type {
        case .health:
            r = [0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.2, 0.0]
            g = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            b = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        case .essence:
            r = [0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            g = [0.0, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0]
            b = [0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0]
        }
        
        let fillingImage = CIImage(image: UIImage(named: "counter filling")!)
        let hueFilter = CIFilter(name: "CIColorCrossPolynomial")
        hueFilter?.setValue(fillingImage, forKey: kCIInputImageKey)
        hueFilter?.setValue(CIVector(values: r, count: r.count), forKey: "inputRedCoefficients")
        hueFilter?.setValue(CIVector(values: g, count: g.count), forKey: "inputGreenCoefficients")
        hueFilter?.setValue(CIVector(values: b, count: b.count), forKey: "inputBlueCoefficients")
        
        return UIImage(ciImage: (hueFilter?.outputImage)!)
    }
    
    private func getGlossImage() -> UIImage? {
        return UIImage(named: "counter gloss cover")
    }
}

