//
//  GenerationStrategies.swift
//  Markov Chains
//

import Foundation

//---------
protocol MarkovGenerator {
    func generate(map: [String:[String]], sentences: Int, endOfSentenceCharacterSet: NSCharacterSet) -> String
    func createMapFromText(text: String) -> [String: [String]]
}

//-------
internal class AbstractGen: MarkovGenerator{
    
    func generate(map: [String:[String]], sentences: Int, endOfSentenceCharacterSet: NSCharacterSet) -> String {
        return "Unimplemented"
    }
    
    func createMapFromText(text: String) -> [String : [String]] {
        return ["Unimplemented" : ["Unimplemented"]]
    }
    
    // get random number in range
    func getRandom(inRange: Int) -> Int {
        return Int(arc4random_uniform(UInt32(inRange)))
    }
    
    // turn the text passed in into an array, also removing"
    // leading and trailing whitespace
    // newlines
    // empty array items
    func textIntoArray(text: String) -> [String] {
        return text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            .stringByReplacingOccurrencesOfString("\n", withString: " ")
            .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            .filter{ !$0.isEmpty }
    }
}


//-------
class FirstOrderGenerator: AbstractGen{
    
    // generate markov text of desired length
    override func generate(map: [String:[String]], sentences: Int, endOfSentenceCharacterSet: NSCharacterSet) -> String {
        
        var sentence = [String]()
        let seedIndex = getRandom(map.keys.count)
        var word = [String](map.keys)[seedIndex]
        
        repeat{
            sentence.append(word)
            
            // get next word from current word options
            if let opts = map[word]{
                word = opts[getRandom(opts.count)]
            }
            else{
                // if last word of the text file is the new key there will not be a kvp set
                // so generate a new one randomly
                word = [String](map.keys)[getRandom(map.keys.count)]
                
            }
        }while sentence.filter { $0.rangeOfCharacterFromSet(endOfSentenceCharacterSet) != nil }.count < sentences
        
        return "First Order:\n" + sentence.joinWithSeparator(" ")
    }
    
    // make the map!
    override func createMapFromText(text: String) -> [String : [String]] {
        
        var map = [String: [String]]()
        let textAsArray = super.textIntoArray(text)
        let lenText = textAsArray.count
        
        for (ind, word) in textAsArray.enumerate(){
            
            //dont go over the end of the array so use - 1
            if ind < lenText - 1 {
                let value = textAsArray[ind + 1]
                
                if (map[word] == nil){
                    map[word] = [String]()
                }
                
                // iflet above ensures the kvp is present in the map
                map[word]!.append(value)
            }
        }
        
        return map
    }
}

//-------
class SecondOrderGenerator: AbstractGen{
    
    // generate markov text of desired length
    override func generate(map: [String:[String]], sentences: Int, endOfSentenceCharacterSet: NSCharacterSet) -> String {
        
        //nexted function!
        func getNextWord(key:String) -> String{
            var word : String
            
            if let opts = map[key]{
                word = opts[getRandom(opts.count)]
            }
            else{
                let newSeed = getRandom(map.keys.count)
                word = [String](map.keys)[newSeed].componentsSeparatedByString(" ").first!
            }
            
            return word
        }
        
        var sentence = [String]()
        let seedIndex = getRandom(map.keys.count)
        var word = [String](map.keys)[seedIndex]
        
        //need to do it once before iterating over arrays
        sentence += word.componentsSeparatedByString(" ")
        word = getNextWord(word)
        
        repeat{
            sentence.append(word)
        
            // get lastest two items from array and create new key
            // endindex is actually one past the end of the array becasue it's shitty
            let key = [String](arrayLiteral: sentence[sentence.endIndex.advancedBy(-2)], sentence[sentence.endIndex.advancedBy(-1)]).joinWithSeparator(" ")
            
            word = getNextWord(key)
            
        }while sentence.filter { $0.rangeOfCharacterFromSet(endOfSentenceCharacterSet) != nil }.count < sentences
        
        return "Second Order:\n" + sentence.joinWithSeparator(" ")
    }
    
    // make map!
    override func createMapFromText(text: String) -> [String : [String]] {
        
        var map = [String: [String]]()
        let textAsArray = textIntoArray(text)
        let lenText = textAsArray.count
        
        for (ind, word) in textAsArray.enumerate(){
            
            //dont go over the end of the array so use - 2
            if ind < lenText - 2 {
                
                let key = [String](arrayLiteral: word, textAsArray[ind + 1]).joinWithSeparator(" ")
                let value = textAsArray[ind + 2]
                
                if (map[key] == nil){
                    map[key] = [String]()
                }
                
                // iflet above ensures the kvp is present in the map
                map[key]!.append(value)
            }
            
        }
        return map
    }
}
