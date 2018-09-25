//
//  ViewController.swift
//  Session2
//
//  Created by screson on 2017/6/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var txtfUserName: UITextField!
    @IBOutlet weak var txtfPassword: UITextField!
    var userModel:UserModel?
    var canPush = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //按钮点击事件
    @IBAction func loginAction(_ sender: UIButton) {
        print("login action")
        //登录验证、接口调用
        self.login(with: txtfUserName.text ?? "", password: txtfPassword.text ?? "")
        
        //测试接口
        Alamofire.request("http://www.weather.com.cn/data/cityinfo/101010100.html?a=1").responseJSON { (data) in
            print(data.value!)
        }
        //测试接口
        Alamofire.request("http://192.168.0.203:5008/user/login", method: .post, parameters: ["userName":"","passWord":"",], encoding: JSONEncoding.default, headers: nil).responseJSON { (data) in
            print(data.result)
        }
    }
    
    //MARK: - 是否执行连接点事件
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return canPush
    }
    
    //MARK: - 执行连接点事件准备工作
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailvc = segue.destination as? DetailViewController {
            detailvc.model = self.userModel
            canPush = false
        }
    }
    
    func login(with userName:String,password:String) {
        if userName.isEmpty {
            showAlert("用户名不能为空")
            return
        }
        if password.isEmpty {
            showAlert("密码不能为空")
            return
        }
        self.view.endEditing(true)
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = "http://115.182.15.118:5008/user/login"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let params = "userName=\(userName)&passWord=\(password)"
        request.httpBody = params.data(using: .utf8)
        request.timeoutInterval = 5
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
                if error == nil {
                    if let response = response as? HTTPURLResponse,response.statusCode == 200 {
                        if let data = data {
                            do {
                                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                print(String.init(data: data, encoding: .utf8) ?? "")
                                if let obj = jsonObj as? Dictionary <String,Any> {
                                    if let code = obj["status"] as? String,Int(code) == 0 {
                                        let model = UserModel()
                                        model.setValuesForKeys(obj["data"] as! Dictionary<String,Any>)
                                        self.userModel = model
                                        self.canPush = true
                                        //执行Segue
                                        self.performSegue(withIdentifier: "ZXLogin", sender: nil)
                                    } else {
                                        self.showAlert(obj["msg"] as? String ?? "未知错误")
                                    }
                                } else {
                                    self.showAlert("数据格式错误")
                                }
                            } catch {
                                self.showAlert("数据格式错误")
                            }
                        } else {
                            self.showAlert("数据返回为空...")
                        }
                    } else {
                        self.showAlert((response as! HTTPURLResponse).description)
                    }
                } else {
                    self.showAlert(error!.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    //MARK: - 警告框
    func showAlert(_ msg:String) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //用户点击屏幕 取消键盘
        self.view.endEditing(true)
    }
    
}

