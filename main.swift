//
//  main.swift
//  Markov Chains
//


import Foundation

let m = Markov(display: MarkovDisplayStrategy(), generationStrategy: SecondOrderGenerator())
let con = Console(expectedArgs: m.numArgs, display: m.display)

// ensure all conditions met before trying to do it
guard let numSentencesAsString = con.getArg(Markov.Arguments.SentenceNumber.rawValue),
    
    //convert string user entered into an int
    let numSentences = Int(numSentencesAsString),
    
    //get filename
    let filename = con.getArg(Markov.Arguments.FileName.rawValue),
    
    // get file contents
    let fileContents = try? String(contentsOfFile: filename, encoding: NSUTF8StringEncoding) else{
        
    exit(EXIT_FAILURE)
        
}
print("-------")
//second order
print(m.generateFromText(fileContents, numSentences: numSentences))

print("-------")

//change to first order for comparison
m.setGenerationStrategy(FirstOrderGenerator())
print(m.generateFromText(fileContents, numSentences: numSentences))



