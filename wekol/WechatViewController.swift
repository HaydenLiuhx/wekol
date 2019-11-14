//
//  WechatViewController.swift
//  wekol
//
//  Created by 刘皇逊 on 14/11/19.
//  Copyright © 2019 Eidetika. All rights reserved.
//

import UIKit

class WechatViewController: UIViewController {

   
    @IBAction func Login(_ sender: Any) {
        let req = SendAuthReq()
                      req.scope = "snsapi_userinfo"
                      req.state = "default_state"
                      
                      WXApi.send(req)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
