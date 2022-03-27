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

func isWin(board: [[Int]], x: Int, y: Int, player: Int) -> Bool{ // 是否連線
    var startX = x
    var endX = x
    var startY = y
    var endY = y
    
    // 橫(左->右)x
    while(endX < 6 && board[endX+1][y] == player){
        endX += 1
    }
    while(startX >= 1 && board[startX-1][y] == player){
        startX -= 1
    }
    if(endX - startX >= 3){
        return true
    }
    
    // 直(上->下)y
    while(endY < 5 && board[x][endY+1] == player){
        endY += 1
    }
    while(startY >= 1 && board[x][startY-1] == player){
        startY -= 1
    }
    if(endY - startY >= 3){
        return true
    }
    
    // 斜/(右上->左下)x+y- x-y+
    startX = x
    endX = x
    startY = y
    endY = y
    while(endX < 6 && startY >= 1 && board[endX+1][startY-1] == player){
        endX += 1
        startY -= 1
    }
    while(startX >= 1 && endY < 5 && board[startX-1][endY+1] == player){
        startX -= 1
        endY += 1
    }
    if(endY - startY >= 3){
        return true
    }
    
    // 斜\(左上->右下)x+y+ x-y-
    startX = x
    endX = x
    startY = y
    endY = y
    
    while(startX >= 1 && startY >= 1 && board[startX-1][startY-1] == player){
        startX -= 1
        startY -= 1
    }
    while(endX < 6 && endY < 5 && board[endX+1][endY+1] == player){
        endX += 1
        endY += 1
    }
    if(endY - startY >= 3){
        return true
    }
    
    return false
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
