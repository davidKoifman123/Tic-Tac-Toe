//
//  Model.swift
//  Tic Tac Toe
//
//  Created by Work on 11/8/22.
//

import Foundation
import SwiftUI

class Field: ObservableObject {
    typealias Square = Character
    @Published var board = [[Square]]()
    
    var drawCounter = 0
    var result = "" //counter of diffrent games
    
    var dictionaryOfCoordinates = [String : (Int, Int)]()
    var resultString = ""

    var crossTurn = true //true for crosses, false for noughts
    var stringTurn = "Crosses"
    var gameOver = false
    var emptySquareArray: [(Int, Int)] = []
    
    init() {
        print(board)
        var digitBoard = 0
            
        for row in 0..<GameCharacters.dimension {
            digitBoard += 1
            board.append([Square]())
            
            for column in 0..<GameCharacters.dimension {
                board[row].append(characterForBoard(row: row, column: column))
                dictionaryOfCoordinates[generateKey(row: row, column: column)] = (row, column)
            }
        }
        print(board)
    }
    
   @objc func noughtMakeMove() {
        for row in 0..<board.count {
            for column in 0..<board[row].count  {
                if board[row][column] != GameCharacters.cross || board [row][column] != GameCharacters.nought {
                    emptySquareArray.append((row, column))
                }
            }
        }
        
        let radnomEmtySquare = emptySquareArray.randomElement()
        
        changeBoardElement(array: &board, squareToChange: generateKey(row: radnomEmtySquare!.0, column: radnomEmtySquare!.1))
        print(resultString)
       crossTurn = true
    }
    
    func getCoordinates(row: Int, column: Int) {
         let key = generateKey(row: row, column: column)
         changeBoardElement(array: &board, squareToChange: key)
         print(board)

        if isGameOver(array: board) {
            print("yep")
            let _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(reset), userInfo: nil, repeats: false)
             // crossTurn = nil
            
            let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(reset2), userInfo: nil, repeats: false)
        }
    }
    
   @objc func reset2() {
         result = ""
    }
    
    @objc func reset() {
             resetBoard(array: &board)
             crossTurn = true
             drawCounter = 0
            // Field.result = ""
             
    }
    
    func resetToIntiaState() {
         crossTurn = true
          drawCounter = 0
    }
    
    func resetBoard(array: inout [[Square]]) {
        for row in 0..<GameCharacters.dimension {
            for column in 0..<GameCharacters.dimension {
                 array[row][column] = characterForBoard(row: row, column: column)
            }
        }
    }
    
    func displayBoard() -> String {
        var resultString = String()
        
        for row in board {
            for column in row {
                resultString += String(column)
            }
            resultString += "\n"
        }
        return resultString
    }


func initializeArray2D<T>(dimension: Int, dimension2: Int = 3, array: inout [[T]], elementToFill: T) {
    for row in 0..<dimension {
        array.append([T]())
         for _ in 0..<dimension2 {
             array[row].append(elementToFill)
        }
    }
}

func isGameOver(array: [[Square]]) -> Bool {
    var horlResultArray = [[Square]]() //TODO: RENAME
    initializeArray2D(dimension: 3, array: &horlResultArray, elementToFill: "-")
     
    for (index1, row) in array.enumerated() {
        var counterCrossesHorizontal = 0
        var counterNoughtsHorizontal = 0

        for (index2 ,column) in row.enumerated() {
            
            if column == GameCharacters.cross {
                counterCrossesHorizontal += 1
                characterToAppend(index1: index1, index2: index2, character: GameCharacters.cross, arrayToChange: &horlResultArray)

            } else if column == GameCharacters.nought {
                counterNoughtsHorizontal += 1
                characterToAppend(index1: index1, index2: index2, character: GameCharacters.nought, arrayToChange: &horlResultArray)
            }
        }
        
        if counterCrossesHorizontal == 3 {
            print("crosses win! Horizontaly")
            result = GameResults.crossesVictory
             return true
        } else if counterNoughtsHorizontal == 3 {
            result = GameResults.noughtsVictory
            print("noughts win! Horizontaly")
             return true
        }
    }
    
    if horlResultArray[0][0] == GameCharacters.cross && horlResultArray[1][1] == GameCharacters.cross && horlResultArray[2][2] == GameCharacters.cross {
        print("cross win")
        result = GameResults.crossesVictory
        return true
    } else if horlResultArray[0][2] == GameCharacters.nought && horlResultArray[1][1] == GameCharacters.nought && horlResultArray[2][0] == GameCharacters.nought {
        print("nought wins")
        result = GameResults.noughtsVictory
        return true
    } else if horlResultArray[0][2] == GameCharacters.cross && horlResultArray[1][1] == GameCharacters.cross && horlResultArray[2][0] == GameCharacters.cross  {
        print("cross wins")
        result = GameResults.crossesVictory
        return true
    } else if horlResultArray[0][0] == GameCharacters.nought && horlResultArray[1][1] == GameCharacters.nought && horlResultArray[2][2] == GameCharacters.nought {
        print("nought wins")
        result = GameResults.noughtsVictory
        return true
    }
    
    //TODO: OPTIMIZE
    var a1 = ""
    var a2 = ""
    var a3 = ""
    
    for row3 in horlResultArray {
        for (index3, column3) in row3.enumerated() {
            
            switch index3 {
              case 0:
               a1 += String(column3)
              case 1:
               a2 += String(column3)
              case 2:
               a3 += String(column3)
            default:
                break
            }
        }
    }
    
    let array2 = [a1, a2, a3]
    
    for i in array2 {
        if i.trimmingCharacters(in: .whitespacesAndNewlines) == "✚✚✚" {
            print("Crosses Wins")
            result = GameResults.crossesVictory
            return true
        } else if i.trimmingCharacters(in: .whitespacesAndNewlines) == "⭕️⭕️⭕️" {
            print("Noughts Wins")
            result = GameResults.noughtsVictory
            return true
        }
    }
    
    if drawCounter == GameCharacters.squaresNeededForDraw {
        result = GameResults.draw
        return true
    }
    
    return false
}

func characterToAppend(index1: Int, index2: Int, character: Square, arrayToChange: inout [[Square]]) {
    switch index2 {
       case 0:
        arrayToChange[index1][index2] = character
       case 1:
        arrayToChange[index1][index2] = character
       case 2:
        arrayToChange[index1][index2] = character
    
      default:
        break
    }
}

func characterForBoard(row: Int, column: Int) -> Square {
    (row + column) % 2 == 0 ? GameCharacters.whiteSquare : GameCharacters.blackSquare
}

func changeBoardElement(array: inout [[Square]], squareToChange: String) {
    let indexForArrayIn = dictionaryOfCoordinates[squareToChange]
    
    if crossTurn == true && isSquareTaken() == false  {
        array[indexForArrayIn!.0][indexForArrayIn!.1] = GameCharacters.cross
        crossTurn = false
        stringTurn = "Noughts"
        drawCounter += 1
    } else if crossTurn == false && isSquareTaken() == false  {
        array[indexForArrayIn!.0][indexForArrayIn!.1] = GameCharacters.nought
        crossTurn = true
        stringTurn = "Crosses"
        drawCounter += 1
    }
    
    func isSquareTaken() -> Bool {
         if array[indexForArrayIn!.0][indexForArrayIn!.1] == GameCharacters.whiteSquare || array[indexForArrayIn!.0][indexForArrayIn!.1] == GameCharacters.blackSquare {
            return false
        }
        print("Square is already taken!")
        return true
    }
}

func intializeBoard(array: inout [[Square]]) {
    var digitBoard = 0
    
for row in 0..<GameCharacters.dimension {
    digitBoard += 1
    array.append([Square]())
    
    for column in 0..<GameCharacters.dimension {
        array[row].append(characterForBoard(row: row, column: column))
        
        print(column == 2 ? "\(array[row][column])\(digitBoard)" : "\(array[row][column])", terminator: "")
        
        dictionaryOfCoordinates[generateKey(row: row, column: column)] = (row, column)
    }
    print()
  }
}
    
func generateKey(row: Int, column: Int) -> String {
    var letter = String()
    var number = String()
    
    switch column {
       case 0:
        letter = "A"
       case 1:
        letter = "B"
       case 2:
        letter = "C"
       default:
        break
    }
    
    switch row {
      case 0:
        number = "1"
      case 1:
        number = "2"
      case 2:
        number = "3"
      default:
        break
    }
   return letter + number
  }
    
    struct GameCharacters {
       static let cross: Character = "✚"
       static let nought: Character = "⭕️"
       static let filler: Character = " "
       static let whiteSquare: Square = "⬜️"
       static let blackSquare: Square = "⬛️"
       static let dimension = 3
       static let squaresNeededForDraw = 9
    }

    struct GameResults {
        static let crossesVictory = "Crosses Win!"
        static let noughtsVictory = "Noughts Win!"
        static let draw = "Draw!"
    }
}
