//
//  startView.swift
//  connectFour
//
//  Created by User23 on 2022/3/20.
//

import SwiftUI
import Foundation

struct startView: View {
    @State private var player1Color: Color = Color.yellow
    @State private var player2Color: Color = Color.red
    @State private var showGameView: Bool = false
    @State private var player1: Player = Player(playerColor: Color.yellow, playerType: .human, playerNum: 1)
    @State private var player2: Player = Player(playerColor: Color.yellow, playerType: .computer, playerNum: 2)
    @State private var game: Game = Game()
    
    var body: some View {
        let bgColor: Color = Color(red: 250/255, green: 240/255, blue: 218/255)
        let pinkColor: Color = Color(red: 255/255, green: 150/250, blue: 150/250, opacity: 0.75)
        let purpleColor: Color = Color(red: 200/255, green: 150/250, blue: 200/250, opacity: 0.75)
        let fontColor: Color = Color(red: 115/255, green: 95/255, blue: 75/255)
        
        ZStack{
            bgColor
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text("Player1")
                        .foregroundColor(fontColor)
                    ColorPicker("Choose your Color", selection: $player1Color)
                        .labelsHidden()
                    Text("\tPlayer2")
                        .foregroundColor(fontColor)
                    ColorPicker("Choose your Color", selection: $player2Color)
                        .labelsHidden()
                }
                
                Text("-Start Game-")
                    .foregroundColor(fontColor)
                    .font((.custom("GameOfSquids", size: 25)))
                
                HStack{
                    Button(action: {
                        let turn = Int.random(in: 1...2) // 1 or 2
                        player1 = Player(playerColor: player1Color, playerType: PlayerType.human, playerNum: 1)
                        player2 = Player(playerColor: player2Color, playerType: PlayerType.human, playerNum: 2)
                        game = Game( player1: player1, player2: player2, nowTurn: turn)

                        showGameView = true

                    }, label: {
                        Rectangle()
                            .fill(pinkColor)
                            .frame(width: 120, height: 60)
                            .cornerRadius(10)
                            .overlay(
                                Text("🧑‍🎨 vs 🧑‍🎨")
                                    .foregroundColor(Color.white))
                    })
                    .fullScreenCover(isPresented: $showGameView){
                        ContentView(showGameView: $showGameView, game: $game)
                    }

                    Button(action: {
                        let turn = Int.random(in: 1...2) // 1 or 2
                        player1 = Player(playerColor: player1Color, playerType: PlayerType.human, playerNum: 1)
                        player2 = Player(playerColor: player2Color, playerType: PlayerType.computer, playerNum: 2)
                        game = Game(player1: player1, player2: player2, nowTurn: turn)

                        showGameView = true
                    }, label: {
                        Rectangle()
                            .fill(purpleColor)
                            .frame(width: 120, height: 60)
                            .cornerRadius(10)
                            .overlay(
                                Text("🧑‍🎨 vs 💻")
                                    .foregroundColor(Color.white))
                    })
                    .fullScreenCover(isPresented: $showGameView){
                        ContentView(showGameView: $showGameView, game: $game)
                    }

                }
            }
        }
        
    }
}

struct startView_Previews: PreviewProvider {
    static var previews: some View {
        startView()
    }
}
