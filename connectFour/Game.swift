//
//  Game.swift
//  connectFour
//
//  Created by User23 on 2022/3/20.
//

import SwiftUI
import Foundation

struct Game{
    var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 6), count: 7)
    var player1: Player = Player(playerColor: Color.yellow, playerType: PlayerType.human, playerNum: 1)
    var player2: Player = Player(playerColor: Color.red, playerType: PlayerType.computer, playerNum: 2)
    var nowTurn = 1
}

func doMoveY(board: [[Int]], x: Int) -> Int{ // 回傳該行下的y
    for yyy in 0..<6{ // 0~5
        if(board[x][5-yyy] == 0){ // 由下往上(5~0)第一個值為0
            //board[x][5-yyy] = player
            return 5-yyy
        }
    }
    return 0
}

func canMove(board: [[Int]], x: Int, y: Int) -> Bool{ // 可否下這行
    if board[x][0] == 0{
        return true
    }
    return false
}

func canMoveXList(board: [[Int]]) -> [Int]{ // 目前所有可下的行
    var list: [Int] = []
    for x in 0..<7 {
        if board[x][0] == 0{
            list.append(x)
        }
    }
    return list
}
