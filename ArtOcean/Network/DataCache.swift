//
//  DataCache.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation

protocol DataDictCache{
    subscript( _ url:URL) -> Data? {get set}
}

struct DataCache:DataDictCache{
    
    private var cache:NSCache<NSURL,NSData> = .init()
    
    static var shared = DataCache()
    
    public subscript(_ url: URL) -> Data? {
        get{
            return self.cache.object(forKey: url as NSURL) as? Data
        }
        
        set{
            if let data = newValue as? NSData{
                if let _ = self.cache.object(forKey: url as NSURL){
                    self.cache.removeObject(forKey: url as NSURL)
                }
                self.cache.setObject(data, forKey: url as NSURL)
            }
            
        }
    }
}
