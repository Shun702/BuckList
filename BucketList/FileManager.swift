//
//  FileManager.swift
//  BucketList
//
//  Created by Shun Le Yi Mon on 02/09/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
