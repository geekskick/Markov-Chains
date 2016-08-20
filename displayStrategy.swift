//
//  displayStrategy.swift
//  Markov Chains
//


import Foundation

protocol displayStrategy {
    func printUsage() -> Void
}


class MarkovDisplayStrategy : displayStrategy{
    
    func printUsage() -> Void{
        if let execName = Process.arguments.first{
            print("Usage: \(execName) <input file name> <number of output sentences>");
        }
    }
}