//
//  MainMenuVCViewController.swift
//  uTanks
//
//  Created by Student on 4/12/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit

class MainMenuVCViewController: UIViewController {
    
      func viewDidappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        print("view appeared")
        //or to rotate and lock
        //AppUtility.lockOrientation(.portrait, andRotateTo: .portait)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       print("view loaded")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //reset wen being removed
        AppUtility.lockOrientation(.all)
        
        print("view disappeared")
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
