//
//  Post.swift
//  Battlebucks
//
//  Created by Abid on 10/22/2025.

import Foundation

struct Post: Identifiable, Codable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

