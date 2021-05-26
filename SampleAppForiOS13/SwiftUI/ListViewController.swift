//
//  ListViewController.swift
//  SampleAppForiOS13
//
//  Created by Kazuhiro Hayashi on 2021/05/26.
//  
//

import UIKit
import SwiftUI

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listVC = UIHostingController(rootView: ListView())
        addChild(listVC)
        listVC.view.frame = view.bounds
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        listVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(listVC.view)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
