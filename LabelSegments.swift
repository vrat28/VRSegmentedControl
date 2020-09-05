//
//  LabelSegments.swift
//  CustomSegmentedControl
//
//  Created by Varun Rathi on 01/09/20.
//

import UIKit

class CustomLabelSegment :CustomMaskSegment {
     private struct DefaultValues {
        static let normalBackgroundColor: UIColor = .clear
        static let normalTextColor: UIColor = .white
        static let selectedBackgroundColor: UIColor = .clear
        static let selectedTextColor: UIColor = .black
        static let font: UIFont = UILabel().font
    }
    
    private let font:UIFont
    public var text:String?
    private let textColor:UIColor
    private let backgroundColor:UIColor
    private let selectedTextColor: UIColor
    private let selectedBackgroundColor: UIColor

    
    public init(title:String? = nil,
                normalTextColor: UIColor? = DefaultValues.normalTextColor,
                normalBackgroundColor:UIColor? = DefaultValues.normalBackgroundColor,
                selectedBackgroundColor:UIColor? = DefaultValues.selectedBackgroundColor,
                selectedTextColor:UIColor? = nil,
                font: UIFont = DefaultValues.font) {
        
        self.font = font
        self.text = title
        self.selectedTextColor = selectedTextColor ?? DefaultValues.selectedTextColor
        self.selectedBackgroundColor  = selectedBackgroundColor ?? DefaultValues.selectedBackgroundColor
        self.textColor = normalTextColor ?? DefaultValues.normalTextColor
        self.backgroundColor = normalBackgroundColor ?? DefaultValues.normalBackgroundColor
    }


    lazy var normalView: UIView = {
    return makeSegmentLabel(title: text, background: backgroundColor, textColor: textColor, font: font)
    }()
    
    
    lazy var selectedView: UIView = {
         return makeSegmentLabel(title: text, background: selectedBackgroundColor, textColor: selectedTextColor, font: font)
    }()
    
    
    func makeSegmentLabel(title:String?,
                        background color:UIColor,
                        textColor: UIColor,
                        font:UIFont)-> UILabel {
                        
       let label =  UILabel()
       label.text = title
       label.font = font
       label.backgroundColor = backgroundColor
       label.textColor = textColor
       label.textAlignment = .center
       label.lineBreakMode = .byTruncatingTail
       return label
       
    }
}

extension CustomLabelSegment {
    
    class func getSegments(with titles:[String],
                            textColor:UIColor? = nil,
                            backgroundColor: UIColor? = nil,
                            selectedTextColor:UIColor? = nil,
                            selectedBackgroundColor: UIColor? = nil,
                            font: UIFont) -> [CustomLabelSegment] {
        return titles.map {
                CustomLabelSegment(title: $0, normalTextColor: textColor, normalBackgroundColor: backgroundColor, selectedBackgroundColor: selectedBackgroundColor, selectedTextColor: selectedTextColor, font: font)
        }
    }
}
