//
//  RSSParser.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 14/08/2021.
//

import Foundation
import UIKit

class RSSParser: NSObject, XMLParserDelegate {
    var xmlParser: XMLParser!
    var currentElement = ""
    var foundCharacters = ""
    var currentData = [String:String]()
    var parsedData = [[String:String]]()
    var isHeader = true
    var downloadedData = Data()
    

    func startParsingWithData(downloadedData: Data, with completion: (Bool)->()) {
        let parser = XMLParser(data: downloadedData)
        parser.delegate = self
        let flag = parser.parse()
        if flag {
            parsedData.append(currentData)
            completion(flag)
        }
        
        parsedData.removeAll()
        parser.parse()
        parsedData.append(currentData)
    }
    

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attribudeDict: [String : String] = [:]) {
        currentElement = elementName
        
        //news items start at <item> tag, we're not interested in header
        if currentElement == "item" || currentElement == "entry" {
            // at this point we're working with n+1 entry
            if isHeader == false {
                parsedData.append(currentData)
            }
            isHeader = false
        }
        
        if isHeader == false {
            // header article thumnails
            if currentElement == "media:thumbnail" || currentElement == "media:content" {
                foundCharacters += attribudeDict["url"]!
            }
        }
    }
    
    // keep relevant tag content
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if isHeader == false {
            if currentElement == "title" || currentElement == "link" || currentElement == "description" || currentElement == "content" || currentElement == "pubDate" || currentElement == "author" || currentElement == "dc:creator" || currentElement == "content:endoded" {
                
                foundCharacters += string
                //foundCharacters = foundCharacters.deleteHTML(tags: ["a", "p", "div", "img"])
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if !foundCharacters.isEmpty {
            foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            currentData[currentElement] = foundCharacters
            foundCharacters = ""
        }
    }
    
    func returnParsedData() -> [[String:String]] {
        return parsedData
    }
}
