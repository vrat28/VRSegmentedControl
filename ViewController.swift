//
//  ViewController.swift
//  CustomSegmentedControl
//
//  Created by Varun Rathi on 01/09/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSegments()
        // Do any additional setup after loading the view.
    }
    
    func addSegments(){
        let viewControl = CustomSegmentedControl(frame: CGRect(x: 0.0, y: 332.0, width: view.bounds.width, height: 50.0), segments: CustomLabelSegment.getSegments(with: ["Inejghgghjhgjghjh","Twojhhkjjkhkjh","Threejkkjkkjjkkj"], textColor: .black, backgroundColor: .white, selectedTextColor: .white, selectedBackgroundColor: .black, font: .systemFont(ofSize: 12)), defaultIndex: 0,options: [.selectorBackgroundColor(UIColor.white),.cornerRadius(25.0)])
        
        view.addSubview(viewControl)
    }


}

