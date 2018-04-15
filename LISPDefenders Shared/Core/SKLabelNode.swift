/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Modified
 */

import SpriteKit

extension SKLabelNode {
    var font: SKFont? {
        guard let fontName = fontName else {
            return nil
        }
        
        return SKFont(name: fontName, size: fontSize)!
    }
    
    func multilined() -> SKNode {
        assert(text != nil, "Can't create multiline string without text.")
        assert(font != nil, "Can't create multiline string without a font.")
        
        let bounds = (text! as NSString).size(withAttributes: [.font: self.font!])
        let substrings: [String] = text!.components(separatedBy: "\n")
        
        let res = SKNode()
        var labels = [] as [SKLabelNode]
        var curStr: String = ""
        for substring in substrings {
            if !substring.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty {
                let label = SKLabelNode(fontNamed: self.fontName)
                label.text = substring
                label.fontColor = self.fontColor
                label.fontSize = self.fontSize
                label.position = self.position
                label.horizontalAlignmentMode = .left
                label.verticalAlignmentMode = .bottom
                let whitespace = substring.prefix(while: { $0 == " " || $0 == "\t" })
                let whitespaceOffset = (whitespace as NSString).size(withAttributes: [.font: self.font!]).width
                let curHeight = (curStr as NSString).size(withAttributes: [.font: self.font!]).height
                label.position = CGPoint(x: whitespaceOffset, y: -curHeight)
                switch self.horizontalAlignmentMode {
                case .left:
                    break
                case .center:
                    label.position.x -= bounds.width / 2
                case .right:
                    label.position.x -= bounds.width
                }
                switch self.verticalAlignmentMode {
                case .top:
                    break
                case .center:
                    label.position.y += bounds.height / 2
                case .bottom, .baseline:
                    label.position.y += bounds.height
                }
                res.addChild(label)
                labels.append(label)
            }
            curStr += substring + "\n"
        }
        
        return res
    }
}
