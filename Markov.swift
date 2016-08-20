//
//  Markov.swift
//  Markov Chains
//

import Foundation

class Markov {
    
    var display             : displayStrategy //usage message
    private var generator   : MarkovGenerator //does the generation itself
    
    // accessor
    func setGenerationStrategy(newStrat : MarkovGenerator) -> Void{
        self.generator = newStrat
    }
    
    // the arguements expected from the user in their position inthe CLI too
    enum Arguments : Int {
        case FileName = 1
        case SentenceNumber
        case Final
    }
    
    var numArgs : Int {
        get{
            return Arguments.Final.rawValue
        }
    }
    
    init(display: displayStrategy, generationStrategy: MarkovGenerator){
        self.display = display
        self.generator = generationStrategy

    }
    
    // does the text generation
    func generateFromText(sourceText: String, numSentences: Int) -> String{
        return generator.generate(generator.createMapFromText(sourceText), sentences: numSentences, endOfSentenceCharacterSet: NSCharacterSet(charactersInString: ".?!"))
    }
    

}
