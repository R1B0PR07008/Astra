//
//  userProfile.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import Foundation
import SwiftUI

// MARK: - User Profile Model

struct UserProfile: Codable, Equatable {
	var gpa: Double
	var sat: Int
	var act: Int
	var householdIncome: Double
	var maxBudget: Double?
	var isFirstGeneration: Bool
	var interestedPrograms: [String]
	var preferredLocations: [String]
	var preferredTags: [String]
	var campusSizePreference: String?
	var mustHaveScholarships: Bool
	
	// Default profile for first-time users
	static let `default` = UserProfile(
		gpa: 3.5,
		sat: 1200,
		act: 25,
		householdIncome: 75000,
		maxBudget: 50000,
		isFirstGeneration: false,
		interestedPrograms: [],
		preferredLocations: [],
		preferredTags: [],
		campusSizePreference: nil,
		mustHaveScholarships: true
	)
}

// MARK: - Profile Storage Helper

class ProfileManager: ObservableObject {
	@Published var profile: UserProfile {
		didSet {
			saveProfile()
		}
	}
	
	private let profileKey = "userProfile"
	
	init() {
		if let data = UserDefaults.standard.data(forKey: profileKey),
		   let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
			self.profile = decoded
		} else {
			self.profile = .default
		}
	}
	
	private func saveProfile() {
		if let encoded = try? JSONEncoder().encode(profile) {
			UserDefaults.standard.set(encoded, forKey: profileKey)
		}
	}
	
	func resetProfile() {
		profile = .default
	}
	
	var hasCompletedProfile: Bool {
		return !profile.interestedPrograms.isEmpty
	}
}

// MARK: - Available Options for Profile Setup

struct ProfileOptions {
	static let programs = [
		"Computer Science",
		"Engineering",
		"Business",
		"Medicine",
		"Law",
		"Biology",
		"Chemistry",
		"Physics",
		"Mathematics",
		"Psychology",
		"Economics",
		"Political Science",
		"History",
		"English",
		"Art & Design",
		"Music",
		"Architecture",
		"Environmental Science",
		"Data Science",
		"Nursing"
	]
	
	static let locations = [
		"United States",
		"California",
		"Massachusetts",
		"New York",
		"Mexico",
		"Mexico City",
		"Monterrey",
		"Costa Rica",
		"Cartago, Costa Rica",
		"Chile",
		"Santiago, Chile",
		"Colombia",
		"Bogotá, Colombia",
		"Argentina",
		"Buenos Aires",
		"England (UK)",
		"Latin America",
		"International"
	]
	
	static let tags = [
		"STEM",
		"Research",
		"Liberal Arts",
		"Urban",
		"Rural",
		"Small Classes",
		"Big Sports",
		"Diverse",
		"International",
		"Tech Hub",
		"Historic",
		"Innovation",
		"Arts",
		"Greek Life",
		"Environmental"
	]
	
	static let campusSizes = [
		"Small (< 5,000 students)",
		"Medium (5,000 - 15,000)",
		"Large (15,000 - 30,000)",
		"Very Large (30,000+)"
	]
}
