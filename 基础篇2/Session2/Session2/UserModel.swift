//
//  UserModel.swift
//  Session2
//
//  Created by screson on 2017/6/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var id:Int32 = 0			//id
    var userName:String = ""	//用户名
    var name:String = ""		//姓名
    var tel:String = ""			//电话
    var headPortraitStr:String = "" //头像
    //其他需要字段自行定义....
    
    //重写该方法 空实现
    //避免调用 setValuesForKeys 是系统crash
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
