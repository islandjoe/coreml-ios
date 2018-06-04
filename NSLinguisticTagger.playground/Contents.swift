import UIKit

let str = "Tim Cook is the CEO of Apple Inc. He was recently sighted in Cupertino."
let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.nameType], options: 0)

tagger.string = str

let range = NSMakeRange(0, str.utf16.count)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]

var names:         [String] = []
var places:        [String] = []
var organizations: [String] = []

tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) {
  (tag, tokenRange, stop)  in

  guard let tag = tag else { return }
  let token = (str as NSString).substring(with: tokenRange)

  switch tag {
  case .personalName:
    names.append(token)
  case .placeName:
    places.append(token)
  case .organizationName:
    organizations.append(token)
  default:
    break
  }
}
