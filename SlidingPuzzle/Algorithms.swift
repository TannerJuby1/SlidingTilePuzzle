//
//  Algorithms.swift
//  SlidingPuzzle
//
//  Created by Tanner Juby on 2/12/17.
//  Copyright © 2017 Juby. All rights reserved.
//

import Foundation


/**
 Algorithms
 
 The Class of Algorithms
 */
class Algorithms {
    
    /**
     Algorithm A*, Hueristic 1
     
     Performs the A* Algorithm with Hueristic 1
    */
    func algoAStarH1(start: PuzzleState, goal: [[Int]]) -> [String] {
        
        var openSet : [Int] = [start.key]
        var closedSet : [Int] = []
        
        var states : Dictionary<Int, PuzzleState> = Dictionary()
        states[start.key] = start
        
        var gScore : Dictionary<Int, Int> = Dictionary()
        gScore[start.key] = 0
        
        var hScore : Dictionary<Int, Int> = Dictionary()
        hScore[start.key] = heuristicOne(state: start, goalState: goal)
        
        var fScore : Dictionary<Int, Int> = Dictionary()
        fScore[start.key] = hScore[start.key]
        
        while !openSet.isEmpty {
            aStar1StatesExamined += 1
            // Find lowest score in fScore
            let xKey = findFMin(fScore: fScore, openSet: openSet)!
            let x = states[xKey]!
            
            // Check if X is equal to the goal
            if (x.isGoal(goal: goal)) {
                
                return resconstructPath(state: x)
            }
            
            let openIndex = findIndexOf(array: openSet, value: (x.key))
            
            openSet.remove(at: openIndex!)
            closedSet.append((x.key))
            
            x.setMoves()
            aStar1NodesGenerated += x.possibleMoves.count
            
            for move in (x.possibleMoves) {
                states[move.key] = move

                if findIndexOf(array: closedSet, value: move.key) != nil {
                    continue
                }
                
                let tentativeGScore = resconstructPath(state: move).count
                
                if findIndexOf(array: openSet, value: move.key) == nil {
                    openSet.append(move.key)
                } else if tentativeGScore >= gScore[move.key]! {
                    continue
                }
                
                gScore[move.key] = tentativeGScore
                hScore[move.key] = heuristicOne(state: move, goalState: goal)
                fScore[move.key] = gScore[move.key]! + hScore[move.key]!
                
            }
        }
        return ["ERROR: Could Not Find Optimal Solution"]
    }
    
    
    /**
     Algorithm A*, Hueristic 2
     
     Performs the A* Algorithm with Hueristic 2
     */
    func algoAStarH2(start: PuzzleState, goal: [[Int]]) -> [String] {
        
        var openSet : [Int] = [start.key]
        var closedSet : [Int] = []
        
        var states : Dictionary<Int, PuzzleState> = Dictionary()
        states[start.key] = start
        
        var gScore : Dictionary<Int, Int> = Dictionary()
        gScore[start.key] = 0
        
        var hScore : Dictionary<Int, Int> = Dictionary()
        hScore[start.key] = heuristicTwo(state: start, goalState: goal)
        
        var fScore : Dictionary<Int, Int> = Dictionary()
        fScore[start.key] = hScore[start.key]
        
        while !openSet.isEmpty {
            aStar2StatesExamined += 1
            // Find lowest score in fScore
            let xKey = findFMin(fScore: fScore, openSet: openSet)!
            let x = states[xKey]!
            
            // Check if X is equal to the goal
            if (x.isGoal(goal: goal)) {
                return resconstructPath(state: x)
            }
            
            let openIndex = findIndexOf(array: openSet, value: (x.key))
            
            openSet.remove(at: openIndex!)
            closedSet.append((x.key))
            
            x.setMoves()
            aStar2NodesGenerated += x.possibleMoves.count
            
            for move in (x.possibleMoves) {
                states[move.key] = move
                
                if findIndexOf(array: closedSet, value: move.key) != nil {
                    continue
                }
                
                let tentativeGScore = resconstructPath(state: move).count
                
                if findIndexOf(array: openSet, value: move.key) == nil {
                    openSet.append(move.key)
                } else if tentativeGScore >= gScore[move.key]! {
                    continue
                }
                
                gScore[move.key] = tentativeGScore
                hScore[move.key] = heuristicTwo(state: move, goalState: goal)
                fScore[move.key] = gScore[move.key]! + hScore[move.key]!
            }
        }
        return ["ERROR: Could Not Find Optimal Solution"]
    }
    
    /**
     Graph Search
     
     Implementation of the graph search algorithm
     */
    func graphSearch(root: PuzzleState, goal: [[Int]]) -> [String] {
        
        var openSet : [Int] = []
        var queue = Queue<Int>()
        
        var states : Dictionary<Int, PuzzleState> = Dictionary()
        states[root.key] = root
        
        queue.enqueue(root.key)
        
        while !queue.isEmpty {
            graphSearchStatesExamined += 1
            let xKey = queue.dequeue()!
            let x = states[xKey]!
            
            if (x.isGoal(goal: goal)) {
                return resconstructPath(state: x)
            }
            
            for move in x.possibleMoves {
                if findIndexOf(array: openSet, value: move.key) == nil {
                    openSet.append(move.key)
                    queue.enqueue(move.key)
                    states[move.key] = move
                }
            }
        }
        
        return ["ERROR: Could Not Find Optimal Solution"]
    }
    
    // Variables for backtracking algorithm
    var backtrackSolution = 0
    var moves : [Int : PuzzleState] = [:]
    
    /**
     Start Backtracking
     
     Calls backtracking algorithm and handles the solution
    */
    func startbacktracking(node: PuzzleState, goal: [[Int]]) -> [String] {
        
        if backtracking(node: node, goal: goal) {
            let solution = moves[backtrackSolution]
            return resconstructPath(state: solution!)
        } else {
            return ["ERROR: Could Not Find Optimal Solution"]
        }
    }
    
    /**
     Backtracking
     
     The backtracking algorithm
    */
    func backtracking(node: PuzzleState, goal: [[Int]]) -> Bool {
        backtrackingStatesExamined += 1
        backtrackingNodesGenerated += 1

        moves[node.key] = node
        
        if node.possibleMoves.count == 0 {
            if node.isGoal(goal: goal) {
                backtrackSolution = node.key
                return true
            } else {
                return false
            }
        } else {
            for move in node.possibleMoves {
                if backtracking(node: move, goal: goal) {
                    return true
                }
            }
            return false
        }
    }
}


/**
 A* Algorithms Extension
 
 Helper Functions for the A* Algorithms
 */
extension Algorithms {
    
    /**
     Reconstruct Path
     
     Gets the path of state to start state
    */
    func resconstructPath(state: PuzzleState) -> [String] {
    
        var returnArray : [String] = []
        
        var tempState = state
        
        while tempState.previousState != nil {
            
            switch tempState.move {
            case .Up:
                returnArray.append("UP")
            case .Down:
                returnArray.append("DOWN")
            case .Right:
                returnArray.append("RIGHT")
            case .Left:
                returnArray.append("LEFT")
            case.None:
                returnArray.append("COMPLETE")
            }
            
            if tempState.previousState != nil {
                tempState = tempState.previousState!
            } else {
                return returnArray
            }
        }
        return returnArray
    }
    
    /**
     Heuristic One
 
     Counts the number of out of place tiles
    */
    func heuristicOne(state: PuzzleState, goalState: [[Int]]) -> Int {
        var outOfPlaceCount = 0
        
        for i in 0 ..< state.n {
            for j in 0 ..< state.n {
                if goalState[i][j] != state.startState[i][j] && goalState[i][j] != 0 && state.startState[i][j] != 0 {
                    outOfPlaceCount += 1
                }
            }
        }
        
        return outOfPlaceCount
    }
    
    /**
     Heuristic Two
     
     Counts the Manhatten Distance of the graph
     */
    func heuristicTwo(state: PuzzleState, goalState: [[Int]]) -> Int {
        
        var distance = 0
        
        for i in 0 ..< state.n {
            for j in 0 ..< state.n {
                let value = state.startState[i][j]
                if goalState[i][j] != state.startState[i][j] && goalState[i][j] != 0 && state.startState[i][j] != 0 {
                    
                    let targetX = (value - 1) / state.n
                    let targetY = (value - 1) % state.n
                    let dx = i - targetX
                    let dy = j - targetY
                    distance += abs(dx) + abs(dy)
                }
            }
        }
        
        return distance
    }
    
    /**
     Find FScore Min Va;ue
 
     Finds the node that has the lowest F Score
    */
    func findFMin(fScore: Dictionary<Int, Int>, openSet: [Int]) -> Int? {
        
        var openFScore : Dictionary<Int, Int> = Dictionary()
        
        for key in openSet {
            openFScore[key] = fScore[key]
        }
        
        for (key, value) in openFScore {
            if value == openFScore.values.min() {
                return key
            }
        }
        
        return nil
    }
    
    /**
     Find Array Element
 
     Find the index of an array entry
    */
    func findIndexOf(array: [Int], value: Int) -> Int? {
        
        for i in 0 ..< array.count {
            if array[i] == value {
                return i
            }
        }
        return nil
    }
}


/**
 Backtracking Algorithm Extension
 
 Helper functions for the Backtracking algorithm
 */

var totalCount = 0

extension Algorithms {
    
    func buildTree(root: PuzzleState, currentDepth: Int, maxDepth: Int) -> PuzzleState {
        totalCount += 1
        graphSearchNodesGenerated += 1
        
        if currentDepth == maxDepth {
            return root
        } else {
            root.setMoves()
            
            var newMoves : [PuzzleState] = []
            
            for move in root.possibleMoves {
                let newMove = buildTree(root: move, currentDepth: currentDepth+1, maxDepth: maxDepth)
                newMoves.append(newMove)
            }
            root.possibleMoves = newMoves
            return root
        }
    }
}


/**
 Print Results Extension
 
 Helper Function for printing out results
 */
extension Algorithms {
    
    func printA1Result(solution: [String]) {
        
        if solution.count == 0 {
            
            print("A STAR ALGORITHM WITH HEURISTIC ONE SOLUTION: ")
            print("Start State is the Goal State. No Solution")
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(aStar1NodesGenerated)")
            print("TOTAL STATES EXAMINED: \(aStar1StatesExamined)")
            print()
            
        } else {
            
            var AStar1Print = ""
            for move in solution {
                AStar1Print += "\(move) "
            }

            print("A STAR ALGORITHM WITH HEURISTIC ONE SOLUTION: ")
            print(AStar1Print)
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(aStar1NodesGenerated)")
            print("TOTAL STATES EXAMINED: \(aStar1StatesExamined)")
            print()
        }
    }
    
    func printA2Result(solution: [String]) {
        
        if solution.count == 0 {
            
            print("A STAR ALGORITHM WITH HEURISTIC ONE SOLUTION: ")
            print("Start State is the Goal State. No Solution")
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(aStar2NodesGenerated)")
            print("TOTAL STATES EXAMINED: \(aStar2StatesExamined)")
            print()
            
        } else {
        
            var AStar2Print = ""
            for move in solution {
                AStar2Print += "\(move) "
            }
            
            print("A STAR ALGORITHM WITH HEURISTIC TWO SOLUTION: ")
            print(AStar2Print)
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(aStar2NodesGenerated)")
            print("TOTAL STATES EXAMINED: \(aStar2StatesExamined)")
            print()
        }
    }
    
    func printBacktrackingResult(solution: [String]) {
        
        if solution.count == 0 {
            
            print("BACKTRACKING ALGORITHM SOLUTION: ")
            print("Start State is the Goal State. No Solution")
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(backtrackingNodesGenerated)")
            print("TOTAL STATES EXAMINED: \(backtrackingStatesExamined)")
            print()
            
        } else {
        
            var backtrackingPrint = ""
            for move in solution {
                backtrackingPrint += "\(move) "
            }
            
            print("BACKTRACKING ALGORITHM SOLUTION: ")
            print(backtrackingPrint)
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(backtrackingNodesGenerated)")
            print("TOTAL STATES EXAMINED: \(backtrackingStatesExamined)")
            print()
        }
    }
    
    func printGraphSearchResult(solution: [String]) {
        
        if solution.count == 0 {
            
            print("GRAPH SEARCH ALGORITHM SOLUTION: ")
            print("Start State is the Goal State. No Solution")
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(graphSearchNodesGenerated)")
            print("TOTAL STATES EXAMINED: \(graphSearchStatesExamined)")
            print()
            
        } else {
        
            var graphSearchPrint = ""
            for move in solution {
                graphSearchPrint += "\(move) "
            }
            
            print("GRAPH SEARCH ALGORITHM SOLUTION: ")
            print(graphSearchPrint)
            print("TOTAL MOVES: \(solution.count)")
            print("TOTAL NODES GENERATED: \(graphSearchNodesGenerated)")
            print("TOTAL STATES EXAMINED: \(graphSearchStatesExamined)")
            print()
        }
    }
    
}
