//
//  Player.swift
//  connectFour
//
//  Created by User23 on 2022/3/20.
//
import SwiftUI
import Foundation

struct Player{
    var playerColor: Color
    var playerType: PlayerType // Human or computer
    var playerNum: Int // 1 or 2(fist or second)
    var remainSteps: Int = 21 // initial 21
}

enum PlayerType{
    case human, computer
}

//enum PlayerTurn: Int{
//    case first = 1, second = 2
//}
