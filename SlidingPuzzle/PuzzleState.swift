//
//  PuzzleState.swift
//  SlidingPuzzle
//
//  Created by Tanner Juby on 2/12/17.
//  Copyright © 2017 Juby. All rights reserved.
//

import Foundation

enum Move {
    case None
    
    case Up
    case Down
    case Left
    case Right
}

struct EmptyLocation {
    var row: Int
    var column: Int
}


class PuzzleState {
    
    
    // MARK: - Class Variables
    
    var key : Int
    var move : Move
    
    var n : Int
    var startState : [[Int]]
    var emptyLocation : EmptyLocation!
    
    var possibleMoves : [PuzzleState] = []
    weak var previousState: PuzzleState?
    
    
    // MARK: - Class Initializers
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        key = totalNodes
        move = .None
        
        n = dictionary["n"] as! Int
        startState = dictionary["start"] as! [[Int]]
        
        setEmptyTile()
        
        previousState = nil
    }
    
    init(n: Int, startState: [[Int]], previousState: PuzzleState, move: Move) {
        
        totalNodes += 1
        self.key = totalNodes
        self.move = move
        
        self.n = n
        self.startState = startState
        
        setEmptyTile()
        
        self.previousState = previousState
    }
    
    
    
    // MARK: - Class Functions
    
    /**
     Print Board
     
     Prints out the current state of the puzzle board
     */
    func printState() {
        
        var printObject = ""
        
        for i in 0 ..< n {
            for j in 0 ..< n {
                printObject += "\(startState[i][j]) \t"
            }
            printObject += "\n"
        }
        
        print("\(printObject)")
    }
    
    /**
     Print Goal
 
     Prints out the goal state 
    */
    func printGoal(goal: [[Int]]) {
        
        var printObject = ""
        
        for i in 0 ..< n {
            for j in 0 ..< n {
                printObject += "\(goal[i][j]) \t"
            }
            printObject += "\n"
        }
        
        print("\(printObject)")
    }
    
    
    /**
     Find Empty Tile
     
     Finds the empty location in the current state
     */
    func setEmptyTile()  {
        
        for i in 0 ..< n {
            for j in 0 ..< n {
                if startState[i][j] == 0 {
                    emptyLocation = EmptyLocation(row: i, column: j)
                }
            }
        }
    }
    
    /**
     Set Children
     
     Sets up the children of the node
    */
    func setMoves() {
        
        possibleMoves.removeAll()
        
        // Test Up
        if emptyLocation.row != 0 && move != .Down {
            
            var newState = startState
            
            // MAKE SWAP
            newState[emptyLocation.row][emptyLocation.column] = startState[emptyLocation.row-1][emptyLocation.column]
            newState[emptyLocation.row-1][emptyLocation.column] = startState[emptyLocation.row][emptyLocation.column]
            
            let tempChild = PuzzleState(n: n, startState: newState, previousState: self, move: .Up)
            
            possibleMoves.append(tempChild)
        }
        
        // Test Down
        if emptyLocation.row != n-1 && move != .Up {
            
            var newState = startState
            
            // MAKE SWAP
            newState[emptyLocation.row][emptyLocation.column] = startState[emptyLocation.row+1][emptyLocation.column]
            newState[emptyLocation.row+1][emptyLocation.column] = startState[emptyLocation.row][emptyLocation.column]
            
            let tempChild = PuzzleState(n: n, startState: newState, previousState: self, move: .Down)
            
            possibleMoves.append(tempChild)
        }
        
        // Test Left
        if emptyLocation.column != 0 && move != .Right {
            
            var newState = startState
            
            // MAKE SWAP
            newState[emptyLocation.row][emptyLocation.column] = startState[emptyLocation.row][emptyLocation.column-1]
            newState[emptyLocation.row][emptyLocation.column-1] = startState[emptyLocation.row][emptyLocation.column]
            
            let tempChild = PuzzleState(n: n, startState: newState, previousState: self, move: .Left)
        
            possibleMoves.append(tempChild)
        }
        
        // Test Right
        if emptyLocation.column != n-1  && move != .Left {
            
            var newState = startState
            
            // MAKE SWAP
            newState[emptyLocation.row][emptyLocation.column] = startState[emptyLocation.row][emptyLocation.column+1]
            newState[emptyLocation.row][emptyLocation.column+1] = startState[emptyLocation.row][emptyLocation.column]
            
            let tempChild = PuzzleState(n: n, startState: newState, previousState: self, move: .Right)
            
            possibleMoves.append(tempChild)
        }
    }
    
    /*
     Is Valid
     
     Checks to ensure the current state of the puzzle is valid
     
     Return - Bool
     */
    func isValid() -> Bool {
        
        let total = n*n
        
        var checkArray = [Int]()
        
        for i in 0 ..< total {
            checkArray.append(i)
        }
        
        for k in 0 ..< checkArray.count {
            
            var doesExist = false
            
            for i in 0 ..< n {
                for j in 0 ..< n {
                    if startState[i][j] == checkArray[k] {
                        doesExist = true
                    }
                }
            }
            
            if doesExist == false {
                return false
            }
        }
        return true
    }
    
    /**
     Compare with State
     
     Compares class's start state with another state
    */
    func compareWith(state: PuzzleState) -> Bool {

        for i in 0 ..< n {
            for j in 0 ..< n {
                if startState[i][j] == state.startState[i][j] {
                    return false
                }
            }
        }
        return true
        
    }
    
    /**
     Is Goal
     
     Compares class's start state with another state
     */
    func isGoal(goal: [[Int]]) -> Bool {
        
        for i in 0 ..< n {
            for j in 0 ..< n {
                if startState[i][j] != goal[i][j] {
                    return false
                }
            }
        }
        return true
        
    }
    
}
