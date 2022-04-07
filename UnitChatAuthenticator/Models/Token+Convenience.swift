//
//  Token+Convenience.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import CoreData

extension Token {
    convenience init(value: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.value = value
    }
}
