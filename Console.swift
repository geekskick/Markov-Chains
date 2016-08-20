//
//  Console.swift
//  Markov Chains
//


import Foundation

// handles the console IO for the most part
class Console {
    
    private let m_args : [String]
    
    // get an arguement passed in
    func getArg(num:Int) -> String?{
        return num >= m_args.count ? nil : m_args[num]
        
    }
    
    init(expectedArgs: Int, display: displayStrategy){
        m_args = Process.arguments
        
        //add one to account for the application name
        if m_args.count != expectedArgs {
            display.printUsage()
        }
    }
    
}