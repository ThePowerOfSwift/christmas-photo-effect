

import UIKit

class StickersDataSource {
    
    var stickers: [Sticker] = []
     var immutableStickers: [Sticker] = []
    
    var count: Int {
        return stickers.count
    }
    
    
    
    // MARK: Public
    
    init() {
        stickers = loadStickers(stickerType!)
        immutableStickers = stickers
    }
    
    
    func indexPathForNewRandomPaper(_ new_stickers: [Sticker], newIndex: Int) -> IndexPath {
        let index = Int(newIndex)
        let stickerToCopy = new_stickers[index]
        let newSticker = Sticker(copying: stickerToCopy)
        stickers.append(newSticker)
        //stickers.sortInPlace { $0.index < $1.index }
        return indexPathForPaper(newSticker)
    }
    
    func indexPathForPaper(_ sticker: Sticker) -> IndexPath {
        
        return IndexPath(item: 0, section: 0)
    }
    
    func stickerForItemAtIndexPath(_ indexPath: IndexPath) -> Sticker? {
        
            return stickers[(indexPath as NSIndexPath).item]
    }
    
    func stickerAtIndex(index: Int) -> Sticker {
        return stickers[index]
    }
    
    func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
        var indexes: [Int] = []
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newStickers: [Sticker] = []
        for (index, sticker) in stickers.enumerated() {
            if !indexes.contains(index) {
                newStickers.append(sticker)
            }
        }
        stickers = newStickers
    }
    
    func numberOfPapersInSection(_ index: Int) -> Int {
        return stickers.count
    }
    

    // MARK: Private
    
    fileprivate func absoluteIndexForIndexPath(_ indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<(indexPath as NSIndexPath).section {
            index += numberOfPapersInSection(i)
        }
        index += (indexPath as NSIndexPath).item
        return index
    }
    
    func loadStickers(_ type: String) -> [Sticker] {
        var packname: String
        
        
        if(type == "sticker" ){
            packname = "sticker"
        }
        else if(type == "emoji" ){
            packname = "emoji"
        }
        else if(type == "facemask" ){
            packname = "facemask"
        }
        else if(type == "se" ){
            packname = "special_effects"
        }
        else{
            packname = "sticker"
        }
        
        
        if let path = Bundle.main.path(forResource: packname, ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                var stickers: [Sticker] = []
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let imageName = dict["imageName"] as! String
                        let type = dict["type"] as! String
                        let isLocked = dict["locked"] as! Bool
                        let sticker = Sticker(imageName: imageName, type: type, isLocked: isLocked)
                        
                        stickers.append(sticker)
                    }
                }
                return stickers
            }
        }
        return []
    }
    
    
    
    
    
}

