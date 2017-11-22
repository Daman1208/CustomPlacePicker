//
//  TestViewController.swift
//  CustomPlacePicker
//
//  Created by Damandeep Kaur on 10/31/17.
//  Copyright © 2017 Damandeep Kaur. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dsf(_ sender: Any) {
        let locationsVC = PPSelectLocationViewController.instance()
        locationsVC.completionBlock = { location in
            print(location?.name)
        }
        present(locationsVC, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
