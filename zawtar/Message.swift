//
//  Message.swift
//  zawtar
//
//  Created by kassem on 4/30/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import Foundation
class Message {
    var title:String = ""
    var details :String = ""
    var imagename :String = ""
    var time : String = ""
}
class Item {
    var message : Message = Message()
    var done : Bool = false
    
}
