//
//  DetailViewController.swift
//  Session2
//
//  Created by screson on 2017/6/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var imgvHeader: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbTel: UILabel!
    
    var model:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lbName.text = ""
        self.lbUserName.text = ""
        self.lbTel.text = ""
        
        if let model = model {
            self.lbName.text = model.name
            self.lbUserName.text = model.userName
            self.lbTel.text = model.tel
            self.imgvHeader.kf.setImage(with: URL(string: model.headPortraitStr), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
