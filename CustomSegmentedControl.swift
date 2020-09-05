//
//  CustomSegmentedControl.swift
//  CustomSegmentedControl
//
//  Created by Varun Rathi on 01/09/20.
//

import UIKit


@IBDesignable open class CustomSegmentedControl : UIControl, UIGestureRecognizerDelegate {
    public private(set) var selectedSegmentIndex: Int
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialIndicatorViewFrame: CGRect?
    public let indicatorView = IndicatorThumbView()
    private let normalSegmentsView = UIView()
    private let selectedSegmentsView = UIView()
    private var width: CGFloat { return bounds.width }
    private var height: CGFloat { return bounds.height }
    private var normalSegmentsCount :Int {
        return normalSegmentsView.subviews.count
    }
    
    private var normalSegments: [UIView] {
        return normalSegmentsView.subviews
    }
    
    private var lastIndex: Int {
        return segments.endIndex - 1
    }
    
    var segments : [CustomMaskSegment] {
        didSet  {
            guard  segments.count > 1 else {
                return
            }
            
            normalSegmentsView.subviews.forEach({ $0.removeFromSuperview() })
            selectedSegmentsView.subviews.forEach({ $0.removeFromSuperview() })
            
            for segment in segments {
                normalSegmentsView.addSubview(segment.normalView)
                selectedSegmentsView.addSubview(segment.selectedView)
            }
            
            setNeedsLayout()
        }
    }
    
    /// The duration of the animation of an index change. Defaults to `0.3`.
    @IBInspectable public var animationDuration: TimeInterval = 1.0
    /// The spring damping ratio of the animation of an index change. Defaults to `0.75`. Set to `1.0` for a no bounce effect.
    
    @IBInspectable public var animationSpringDamping: CGFloat = 0.75
    @IBInspectable public var announcesValueImmediately: Bool = true
    
    @IBInspectable public var indicatorViewBorderColor: UIColor? {
        get {
            guard let color = indicatorView.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            indicatorView.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var indicatorViewInset: CGFloat = 2.0 {
        didSet {
            //   updateCornerRadii()
            setNeedsLayout()
        }
    }
    
    public init(frame:CGRect, segments:[CustomMaskSegment],defaultIndex: Int = 0) {
        self.selectedSegmentIndex = defaultIndex
        self.segments = segments
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        self.selectedSegmentIndex = 0
        self.segments = [CustomLabelSegment(title:"Abc")]
        super.init(coder: coder)
        commonInit()
    }
    
    // Setting UP the View Hierarchy
    /****  Order is important
     1. Normal View
     2. Indicator View
     3. Selected View
     */
    func commonInit() {
        layer.masksToBounds = true
        normalSegmentsView.clipsToBounds = true
        selectedSegmentsView.clipsToBounds = true
        
        
        addSubview(normalSegmentsView)
        addSubview(indicatorView)
        addSubview(selectedSegmentsView)
        selectedSegmentsView.layer.mask = indicatorView.segmentMaskView.layer
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        guard segments.count > 1 else {
            return
        }
        
        for segment in self.segments {
            //Normal View
            segment.normalView.clipsToBounds = true
            normalSegmentsView.addSubview(segment.normalView)
            
            //Selected View
            segment.selectedView.clipsToBounds = true
            selectedSegmentsView.addSubview(segment.selectedView)
        }
        
        
        
        layoutIfNeeded()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard normalSegmentsCount > 1 else {
            return
        }
        normalSegmentsView.frame = bounds
        selectedSegmentsView.frame = bounds
        indicatorView.frame = elementFrame(forIndex: selectedSegmentIndex)
        
        for i in 0..<normalSegmentsCount {
            let frame = elementFrame(forIndex: i)
            normalSegmentsView.subviews[i].frame = frame
            selectedSegmentsView.subviews[i].frame = frame
        }
        
    }
    
    public func setIndex(_ newIndex:Int,animation:Bool = true){
        guard 0..<normalSegmentsCount ~= newIndex else {
            return
        }
        
        let oldIndex = self.selectedSegmentIndex
        self.selectedSegmentIndex = newIndex
        moveIndicatorView(animation, shouldSendEvent: oldIndex != newIndex || announcesValueImmediately)
    }
    
    
    private func moveIndicatorView(_ animated: Bool, shouldSendEvent: Bool) {
        if animated{
            if shouldSendEvent && announcesValueImmediately {
                sendActions(for: .valueChanged)
            }
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: animationSpringDamping,
                           initialSpringVelocity: 0.0,
                           options: [.beginFromCurrentState, .curveEaseOut],
                           animations: { () -> Void in
                              self.moveIndicatorView()
                           }, completion: { finished -> Void in
                            if finished && shouldSendEvent && !self.announcesValueImmediately {
                                self.sendActions(for: .valueChanged)
                            }
                           })
        }
        else {
            moveIndicatorView()
            
            if shouldSendEvent {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    private func nearestIndex(toPoint point: CGPoint) -> Int {
        let distances = normalSegments.map { abs(point.x - $0.center.x) }
        return Int(distances.firstIndex(of: distances.min()!)!)
    }
    
    func moveIndicatorView(){
        indicatorView.frame = normalSegments[selectedSegmentIndex].frame
        layoutIfNeeded()
    }
    
    @objc private func tapped(_ gestureRecognizer: UITapGestureRecognizer!) {
        let location = gestureRecognizer.location(in: self)
        setIndex(nearestIndex(toPoint: location))
    }
    
    @objc private func panned(_ gestureRecognizer: UIPanGestureRecognizer!) {
        switch gestureRecognizer.state {
        case .began:
            initialIndicatorViewFrame = indicatorView.frame
        case .changed:
            var frame = initialIndicatorViewFrame!
            frame.origin.x += gestureRecognizer.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - indicatorViewInset - frame.width), indicatorViewInset)
            indicatorView.frame = frame
        case .ended, .failed, .cancelled:
            setIndex(nearestIndex(toPoint: indicatorView.center))
        default: break
        }
    }
    
    //MARK:- Helpers
    private func elementFrame(forIndex index: Int) -> CGRect {
        let elementWidth = width/CGFloat(normalSegmentsCount)
        let isLayoutDirectionRightToLeft = false
        let x = CGFloat(isLayoutDirectionRightToLeft ? lastIndex - index : index) * elementWidth
        return CGRect(x: x, y: indicatorViewInset, width: elementWidth, height: height)
    }
    
}
