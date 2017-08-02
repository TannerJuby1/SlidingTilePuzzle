//
//  main.swift
//  SlidingPuzzle
//
//  Created by Tanner Juby on 2/12/17.
//  Copyright © 2017 Juby. All rights reserved.
//

import Foundation

let basePath = "/Users/TannerJuby/Dropbox/School/AI/PA1/PA1/"

var totalNodes = 0

var backtrackingNodesGenerated = 0
var graphSearchNodesGenerated = 0
var aStar1NodesGenerated = 0
var aStar2NodesGenerated = 0

var backtrackingStatesExamined = 0
var graphSearchStatesExamined = 0
var aStar1StatesExamined = 0
var aStar2StatesExamined = 0

// MARK - Retrieve the start states to be tested

/*
 Retrieve the Start State
 
 Gets start state from JSON file and creates the starting node.
 Calls the different algortihms to solve the puzzle
 */
let startStates = ["trivial.json", "1-move.json", "2-moves.json", "3-moves.json", "4-moves.json", "5-moves.json", "10-moves.json", "15-moves.json", "20-moves.json", "25-moves.json", "15-puzzle.json"]

for ss in startStates {
    
    let path = basePath + ss
    
    if let jsonData = NSData(contentsOfFile: path) {
        do {
            let object = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                
                totalNodes = 0
                let startState = PuzzleState(dictionary: dictionary)
                
                backtrackingNodesGenerated = 0
                graphSearchNodesGenerated = 0
                aStar1NodesGenerated = 1
                aStar2NodesGenerated = 1
                
                backtrackingStatesExamined = 0
                graphSearchStatesExamined = 0
                aStar1StatesExamined = 0
                aStar2StatesExamined = 0
                
                print("--------------------\n")
                
                if startState.isValid() {
                    print("SOLUTIONS TO START STATE: \(ss)\n")
                    
                    print("Start State is Valid\n")
                    
                    print("START STATE")
                    startState.printState()
                    
                    print("GOAL STATE")
                    startState.printGoal(goal: dictionary["goal"] as! [[Int]])
                    
                    var algorithms = Algorithms.init()
                    
                    // Run the A* Heuristic 1 Algorithm
                    let AStarH1Solution : [String] = algorithms.algoAStarH1(start: startState, goal: dictionary["goal"] as! [[Int]])
                    
                    // Run the A* Heuristic 2 Algorithm
                    totalNodes = 0
                    let AStarH2Solution : [String] = algorithms.algoAStarH2(start: startState, goal: dictionary["goal"] as! [[Int]])
                    
                    // Run the Backtracking Algorithm
                    totalNodes = 0
                    
                    let treeRootBacktrack = algorithms.buildTree(root: startState, currentDepth: 0, maxDepth: AStarH2Solution.count)
                    
                    let backtrackSolution : [String] = algorithms.startbacktracking(node: treeRootBacktrack, goal: dictionary["goal"] as! [[Int]])
                    
                    // Run the Graph Search Algorithm
                    totalNodes = 0
                    let treeRootGraph = algorithms.buildTree(root: startState, currentDepth: 0, maxDepth: AStarH2Solution.count)
                    
                    let graphSearchSolution : [String] = algorithms.graphSearch(root: treeRootGraph, goal: dictionary["goal"] as! [[Int]])
                    
                    // Print the results
                    algorithms.printBacktrackingResult(solution: backtrackSolution)
                    algorithms.printGraphSearchResult(solution: graphSearchSolution)
                    algorithms.printA1Result(solution: AStarH1Solution)
                    algorithms.printA2Result(solution: AStarH2Solution)
                    
                    print("--------------------\n")
                    
                    
                } else {
                    print("ERROR: Start State is invalid")
                }
            }
        } catch {
            print("ERROR: Could not serialize the data from file")
        }
    } else {
        print("ERROR: Could not get data from file")
    }
}

