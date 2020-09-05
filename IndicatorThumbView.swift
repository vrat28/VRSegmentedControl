//
//  IndicatorThumbView.swift
//  CustomSegmentedControl
//
//  Created by Varun Rathi on 02/09/20.
//

import UIKit

    open class IndicatorThumbView: UIView {
         let segmentMaskView = UIView()
        fileprivate var cornerRadius: CGFloat = 0 {
            didSet {
                layer.cornerRadius = cornerRadius
                segmentMaskView.layer.cornerRadius = cornerRadius
            }
        }
        override open var frame: CGRect {
            didSet {
                segmentMaskView.frame = frame
            }
        }
        
        init() {
            super.init(frame: CGRect.zero)
            completeInit()
        }
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            completeInit()
        }
        private func completeInit() {
            segmentMaskView.backgroundColor = .black
        }
    }
