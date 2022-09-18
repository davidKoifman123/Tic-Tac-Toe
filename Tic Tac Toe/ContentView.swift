//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Work on 11/8/22.
//

import SwiftUI

struct TwoPlayers: View {
    @ObservedObject var model = Field()

      var body: some View {
            VStack(spacing: 5) {
              if model.result == Field.GameResults.crossesVictory {
                  Text(model.result).font(.system(size: 50)).foregroundColor(.green)
                  
              } else if model.result == Field.GameResults.noughtsVictory {
                  Text(model.result).font(.system(size: 50)).foregroundColor(.red)
              } else {
                  Text(model.result).font(.system(size: 50)).foregroundColor(.blue)
              }
              
                  ForEach(0..<model.board.count) { row in
                      HStack {
                          ForEach(0..<model.board.count) { column in
                              Text(String(model.board[row][column])).font(.system(size: 50))
                                  .onTapGesture {
                              print(row, column)
                                      model.getCoordinates(row: row, column: column)
                          }
                      }
                  }
              }
          }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            TwoPlayers()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
