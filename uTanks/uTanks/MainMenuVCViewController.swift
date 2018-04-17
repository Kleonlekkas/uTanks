//Kyle Lekkas and Irvin Do
//  MainMenuVCViewController.swift
//  uTanks
//
//  Created by Student on 4/12/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit

class MainMenuVCViewController: UIViewController {

    
    //Queue button, when pressed initiates match making process
    //pressing again removes player from queue
    var isQueued: Bool = false
    @IBOutlet weak var matchmakingLabel: UILabel!
    @IBAction func queueButtonPressed(_ sender: Any) {
        isQueued = !isQueued
        if (isQueued) {
            matchmakingLabel.text = "Waiting for players..."
        } else {
            matchmakingLabel.text = "   "
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       print("view loaded")
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
