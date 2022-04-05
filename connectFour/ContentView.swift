//
//  ContentView.swift
//  connectFour
//
//  Created by User23 on 2022/3/9.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @Binding var showGameView: Bool
    @Binding var game: Game
    @State private var win: Bool = false
    @State private var player1point: Int = 0
    @State private var player2point: Int = 0
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var sx: Int = 0 // when win, record smaller x
    @State private var bx: Int = 0 // bigger y (index)
    @State private var sy: Int = 0 // smaller y
    @State private var by: Int = 0 // bigger y
    
    func  initial(){
        game.board = Array(repeating: Array(repeating: 0, count: 6), count: 7)
        game.nowTurn = Int.random(in: 1...2) // 1 or 2
        game.player1.remainSteps = 21
        game.player2.remainSteps = 21
        
        sx = 0
        bx = 0
        sy = 0
        by = 0
        
        if game.nowTurn == 2 && game.player2.playerType == PlayerType.computer{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // wait 1 second
                doComputerMove()
            }
        } // computer first
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
            sx = startX
            bx = endX
            sy = y
            by = y
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
            sx = x
            bx = x
            sy = startY
            by = endY
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
            sx = endX
            bx = startX
            sy = startY
            by = endY
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
            sx = startX
            bx = endX
            sy = startY
            by = endY
            return true
        }
        
        return false
    }
    
    func doComputerMove(){
        let xlist = canMoveXList(board: game.board)
        let x = xlist.randomElement()!
        let y = doMoveY(board: game.board, x: x)
        
        game.board[x][y] = 2 // game.nowTurn (computer always 2)
        game.player2.remainSteps -= 1
        
        let win = isWin(board: game.board, x: x, y: y, player: 2)
        if win{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // wait 1 second
                showAlert = true
                alertTitle = "You Lose !"
                
                player2point += 1 // 比數+1
                
                initial()
            }
        }
        else{
            game.nowTurn = 1 // turn change
            if game.player1.remainSteps == 0 && game.player2.remainSteps == 0{ // 平手
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // wait 1 second
                    showAlert = true
                    alertTitle = "no Space!"
                    initial()
                }
            }
        }
    }
    
    func doHumanMove(x: Int, y: Int){
        if canMove(board: game.board, x: x, y: y){
            let yyy = doMoveY(board: game.board, x: x)
            game.board[x][yyy] = game.nowTurn // PlayerNum 1 or 2
            
            if game.nowTurn == 1{ // player steps -1
                game.player1.remainSteps -= 1
            }
            else{
                game.player2.remainSteps -= 1
            }
            
            let win = isWin(board: game.board, x: x, y: yyy, player: game.nowTurn)
            if win{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // wait 1 second
                    showAlert = true
                    alertTitle = "You WINNNNN !"
                    
                    if game.nowTurn == 1{ // 比數+1
                        player1point += 1
                    }
                    else{
                        player2point += 1
                    }
                    initial()
                }
            }
            else{
                game.nowTurn = (game.nowTurn == 1) ? 2 : 1 // turn change
                if game.player1.remainSteps == 0 && game.player2.remainSteps == 0{ // 平手
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // wait 1 second
                        showAlert = true
                        alertTitle = "no Space!"
                    }
                    
                }
                if game.nowTurn == 2 && game.player2.playerType == PlayerType.computer{ // 輪到computer下
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // wait 1 second
                        doComputerMove()
                    }
                }
            }
            
        }
    }
    
    var body: some View {
        let fontColor: Color = Color(red: 115/255, green: 95/255, blue: 75/255)
        let darkColor: Color = Color(red: 196/255, green: 156/255, blue: 124/255)
        let lightColor: Color = Color(red: 237/255, green: 220/255, blue: 187/255)
        let bgColor: Color = Color(red: 250/255, green: 240/255, blue: 218/255)
        let strokeColor: Color = Color(red: 216/255, green: 176/255, blue: 130/255)
        
        VStack{
            HStack{
                Spacer()
                Text("CONNECT FOUR") // title: Connect Four
                    .font((.custom("GameOfSquids", size: 30)))
                    .foregroundColor(fontColor)
                    .background(
                        Rectangle()
                            .fill(darkColor)
                            .frame(width: .greatestFiniteMagnitude, height: 40)
                    )
                
                Button(action: { // 按叉叉 返回前一頁
                    showGameView = false
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(lightColor)
                })
            }
                
            HStack{ // you v.s. computer
                Text("\tPlayer 1 ").foregroundColor(fontColor)
                Spacer()
                Text("Player 2\t").foregroundColor(fontColor)
            }
            .background(
                Rectangle()
                    .fill(lightColor)
                    .frame(height: 35)
            )
            
            HStack{ // 兩個圈圈，剩餘步數，比數
                Circle()
                    .fill(game.player1.playerColor)
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(game.player1.playerColor, lineWidth: 5))
                    .shadow(radius: 1)
                VStack{ // 剩餘步數
                    Spacer()
                    Text("\(game.player1.remainSteps)")
                        .foregroundColor(darkColor)
                    Text("steps")
                        .font((.custom("", size: 12)))
                        .foregroundColor(darkColor)
                }
                
                Spacer()
                HStack{ // 比數
                    Rectangle()
                        .fill(game.player1.playerColor)
                        .frame(width: 20, height: 40)
                        .cornerRadius(10)
                        .overlay(Text("\(player1point)").foregroundColor(Color.white))
                    Rectangle()
                        .fill(game.player2.playerColor)
                        .frame(width: 20, height: 40)
                        .cornerRadius(10)
                        .overlay(Text("\(player2point)").foregroundColor(Color.white))
                }.overlay(Text(":")
                            .font(.largeTitle)
                            .foregroundColor(darkColor)
                            )
                Spacer()
                
                VStack{ // 剩餘步數
                    Spacer()
                    Text("\(game.player2.remainSteps)")
                        .foregroundColor(darkColor)
                    Text("steps")
                        .font((.custom("", size: 12)))
                        .foregroundColor(darkColor)
                }
                Circle()
                    .fill(game.player2.playerColor)
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(game.player2.playerColor, lineWidth: 5))
                    .shadow(radius: 1)
            }
            .padding()
            .background(
                Rectangle()
                    .fill(bgColor)
                    .frame(height: 100)
            )
            
            ZStack{ // 棋盤
                Image("wood")
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 275)
                
                HStack{
                    ForEach(game.board.indices){ x in // 7行
                        VStack{
                            ForEach(game.board[x].indices){ y in // 6列
                                ZStack{
                                    Circle() // 白色在下面
                                        .fill(Color.white)
                                        .frame(width: 30, height: 35)
                                        .overlay(Circle().stroke(strokeColor, lineWidth: 3))
                                    
                                    Button(action: {
                                        doHumanMove(x: x, y: y)
                                    }, label: {
                                        buttonView(color1: game.player1.playerColor, color2: game.player2.playerColor, value: game.board[x][y])
                                    })
                                }
                            }
                        }
                        .padding(3)
                    }
                }
                .alert(isPresented: $showAlert) { () -> Alert in
                    return Alert(title: Text("\(alertTitle)"))
                 }
                
                winLine(sx: $sx, bx: $bx, sy: $sy, by: $by) // 畫線(直或橫)
            }
            
            HStack{
                Spacer()
                VStack{ // turn
                    Text("Player Turn")
                        .foregroundColor(fontColor)
                    PlayerTurnView(color1: game.player1.playerColor, color2: game.player2.playerColor, nowTurn: game.nowTurn)
                        .background(
                            Rectangle()
                                .stroke(darkColor, lineWidth: 1)
                                .frame(width: 75, height: 60)
                        )
                        .padding(.bottom, 10)
                }
                .padding(12)
                .background(lightColor)
                .cornerRadius(20)
                
                
                Button(action: {
                    initial()
                }, label: {
                    VStack{ // restart
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(darkColor)
                            .font(.largeTitle)
                        Text("Restart")
                            .foregroundColor(fontColor)
                    }
                    .padding()
                })
                    
            }.background(
                Rectangle()
                    .fill(bgColor)
                    .frame(height: 130)
            )
        }
        .onAppear{
            initial()
            player1point = 0
            player2point = 0
        }
    }
}

struct buttonView: View {
    var color1: Color
    var color2: Color
    var value: Int
    
    var body: some View{
        let strokeColor: Color = Color(red: 216/255, green: 176/255, blue: 130/255)
        
        if value == 0{
            Circle()
                .fill(Color.white)
                .frame(width: 30, height: 35)
                .opacity(0)
        }
        else if value == 1{
            Circle()
                .fill(color1)
                .frame(width: 30, height: 35)
                .overlay(Circle().stroke(strokeColor, lineWidth: 3))
        }
        else{
            Circle()
                .fill(color2)
                .frame(width: 30, height: 35)
                .overlay(Circle().stroke(strokeColor, lineWidth: 3))
        }
    }
}

struct winLine: View {
    @Binding var sx: Int // when win, record smaller x
    @Binding var bx: Int // bigger y
    @Binding var sy: Int // smaller y
    @Binding var by: Int // bigger y
    
    var body: some View{
        let lineColor: Color = Color(red: 180/255, green: 180/255, blue: 225/255)
        let x: [Int] = [68, 117, 162, 205, 250, 292, 237]
        let y: [Int] = [29,  75, 118, 160, 205, 247]
        
        Path { (path) in
            path.move(to: CGPoint(x: x[sx], y: y[sy]))
            path.addLine(to: CGPoint(x: x[bx], y: y[by]))
        }
        .stroke(lineColor, lineWidth: 15)
        .cornerRadius(5)
    }
}

struct PlayerTurnView: View{
    var color1: Color
    var color2: Color
    var nowTurn: Int;
    
    var body: some View{
        if nowTurn == 1{ // player 1
            Circle()
                .fill(color1)
                .overlay(Circle().stroke(color1, lineWidth: 3))
                .shadow(radius: 1)
                .frame(width: 75, height: 40)
        }
        else{ // player 2
            Circle()
                .fill(color2)
                .overlay(Circle().stroke(color2, lineWidth: 3))
                .shadow(radius: 1)
                .frame(width: 75, height: 40)
        }
    }
}
