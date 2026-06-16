//
//  data.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import Foundation
import SwiftUI

struct University: Identifiable, Codable, Hashable {
	let id: UUID
	let imageName: String  // Name of image in Assets
	let name: String
	let location: String  // e.g., "Cambridge, MA, USA"
	let subtitle: String  // e.g., "Ivy League • Private"
	let description: String
	let websiteURL: String
	
	// User interaction states
	var isSelected: Bool = false
	var isFavorite: Bool = false
	
	// Requirements & Info
	let minGPA: Double?
	let minSAT: Int?
	let minACT: Int?
	let acceptanceRate: Double?  // e.g., 0.05 for 5%
	let minRequirementText: String  // Human-readable summary
	
	// Pricing
	let tuitionPrices: [TuitionPrice]
	
	// Reviews & Ratings
	let overallRating: Double  // e.g., 4.5
	let reviews: [UniversityReview]
	
	// Additional useful info
	let programs: [String]  // ["Engineering", "Computer Science", "Business"]
	let scholarshipsAvailable: [Scholarship]
	let studentPopulation: Int?
	let campusSize: String?  // e.g., "Large (20,000+ students)"
	let tags: [String]  // ["STEM", "Research", "Urban", "Sports"]
}

struct TuitionPrice: Codable, Hashable {
	let amount: Double
	let currency: String  // "USD", "EUR", etc.
	let period: String  // "per year", "per semester"
	let type: String  // "In-State", "Out-of-State", "International"
	let financialAidAvailable: Bool
}

struct UniversityReview: Identifiable, Codable, Hashable {
	let id: UUID
	let stars: Int  // 1-5
	let studentName: String?  // Optional for privacy
	let major: String?
	let graduationYear: Int?
	let summary: String
	let pros: [String]
	let cons: [String]
	let date: Date
}

struct Scholarship: Identifiable, Codable, Hashable {
	let id: UUID
	let name: String
	let amount: Double
	let currency: String
	let requirements: String
	let deadline: Date?
	let isFullRide: Bool
	let isMeritBased: Bool
}


