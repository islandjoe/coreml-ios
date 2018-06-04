import Foundation


class EntryFilter {
  
  let entryCollection: EntryCollection?
  var filteredEntries: [String] = []
  var wordSets: [String: Set<String>] = [:]
  var languages: [String: String] = [:]
    
  var searchString = "" {
    didSet {
      if searchString == "" {
        filteredEntries = self.entryCollection!.entries!
      } else {
        extractWordSetsAndLanguages()
        filterEntries()
      }
    }
  }

  init(entryCollection: EntryCollection?) {
    self.entryCollection = entryCollection
  }
  
  fileprivate func setOfWords(string: String, language: inout String?) -> Set<String> {
    var wordSet: Set<String> = []
    
    string.enumerateSubstrings(in: string.startIndex ..< string.endIndex, options: .byWords)
    { (word, _, _, _) in
      
      guard let word = word else { return }
      wordSet.insert( word.lowercased() )
    }
  
    return wordSet
  }
    
    fileprivate func extractWordSetsAndLanguages() {
        var newWordSets = [String: Set<String>]()
        var newLanguages = [String: String]()
      
        if let entries = entryCollection?.entries {
          for entry in entries {
            if let wordSet = wordSets[entry] {
              newWordSets[entry]  = wordSet
              newLanguages[entry] = languages[entry]
            } else {
              var language: String?
              let wordSet = setOfWords(string: entry, language: &language)
              newWordSets[entry]  = wordSet
              newLanguages[entry] = language
            }
          }
        }
        
        wordSets  = newWordSets
        languages = newLanguages
    }
    
    fileprivate func filterEntries() {
      var language: String?
      var filterSet = setOfWords(string: searchString, language: &language)
        
      for existingLanguage in Set<String>(languages.values) {
        language = existingLanguage
        filterSet = filterSet.union(setOfWords(string: searchString, language: &language))
      }
        
      filteredEntries.removeAll()
        
      if let entries = entryCollection?.entries {
        if filterSet.isEmpty {
          filteredEntries.append(contentsOf: entries)
        } else {
          for entry in entries {
            guard let wordSet = wordSets[entry],
                                !wordSet.intersection(filterSet)
                                  .isEmpty else { continue }
            filteredEntries.append(entry)
          }
        }
      }

    }
    
}

