//
//  RecommendationEngine.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import Foundation

// MARK: - University Match Score

struct UniversityMatchScore {
	let university: University
	let overallScore: Double
	let acceptanceScore: Double
	let affordabilityScore: Double
	let programScore: Double
	let preferenceScore: Double
	let reasonsForMatch: [String]
	let reasonsAgainst: [String]
}

// MARK: - Smart Recommendation Engine

class UniversityRecommendationEngine {
	
	// MARK: - Main Ranking Function
	
	func rankUniversities(_ universities: [University], profile: UserProfile) -> [UniversityMatchScore] {
		return universities.map { university in
			let scores = calculateDetailedScore(university, profile: profile)
			return scores
		}
		.sorted { $0.overallScore > $1.overallScore }
	}
	
	// MARK: - Detailed Scoring
	
	private func calculateDetailedScore(_ university: University, profile: UserProfile) -> UniversityMatchScore {
		let acceptanceScore = calculateAcceptanceScore(university, profile)
		let affordabilityScore = calculateAffordabilityScore(university, profile)
		let programScore = calculateProgramMatch(university, profile)
		let preferenceScore = calculatePreferenceMatch(university, profile)
		
		// Weighted overall score
		let overallScore = (acceptanceScore * 0.35) +
						  (affordabilityScore * 0.30) +
						  (programScore * 0.25) +
						  (preferenceScore * 0.10)
		
		let reasons = generateMatchReasons(
			university,
			profile: profile,
			acceptance: acceptanceScore,
			affordability: affordabilityScore,
			program: programScore,
			preference: preferenceScore
		)
		
		return UniversityMatchScore(
			university: university,
			overallScore: overallScore,
			acceptanceScore: acceptanceScore,
			affordabilityScore: affordabilityScore,
			programScore: programScore,
			preferenceScore: preferenceScore,
			reasonsForMatch: reasons.positive,
			reasonsAgainst: reasons.negative
		)
	}
	
	// MARK: - Acceptance Likelihood (35% weight)
	
	private func calculateAcceptanceScore(_ uni: University, _ profile: UserProfile) -> Double {
		guard let acceptanceRate = uni.acceptanceRate,
			  let minGPA = uni.minGPA,
			  let minSAT = uni.minSAT else {
			return 0.5 // Default for missing data
		}
		
		// Calculate how much user exceeds requirements
		let gpaMargin = profile.gpa - minGPA
		let satMargin = Double(profile.sat - minSAT)
		
		// Base score from acceptance rate
		var score = acceptanceRate
		
		// Strong candidate - exceeds requirements significantly
		if gpaMargin >= 0.15 && satMargin >= 150 {
			score = min(score * 2.0, 0.95) // Very likely
		}
		// Meets requirements comfortably
		else if gpaMargin >= 0.05 && satMargin >= 50 {
			score = min(score * 1.5, 0.85) // Likely
		}
		// Just meets requirements
		else if gpaMargin >= 0 && satMargin >= 0 {
			score = min(score * 1.2, 0.70) // Possible
		}
		// Below requirements but not hopeless
		else if gpaMargin >= -0.1 && satMargin >= -100 {
			score = score * 0.6 // Reach school
		}
		// Significantly below
		else {
			score = score * 0.3 // Very reach
		}
		
		// First generation boost (many schools value this)
		if profile.isFirstGeneration {
			score = min(score * 1.1, 1.0)
		}
		
		
		
		return min(score, 1.0)
	}
	
	// MARK: - Affordability Score (30% weight)
	
	private func calculateAffordabilityScore(_ uni: University, _ profile: UserProfile) -> Double {
		let lowestTuition = uni.tuitionPrices.map { $0.amount }.min() ?? 100000
		let affordableMax = profile.maxBudget ?? 50000
		
		// If user requires scholarship and university has none, give very low score
		if profile.mustHaveScholarships && uni.scholarshipsAvailable.isEmpty {
			return 0.1
		}
		
		// Estimate financial aid
		let estimatedAid = estimateFinancialAid(
			tuition: lowestTuition,
			income: profile.householdIncome,
			hasScholarships: !uni.scholarshipsAvailable.isEmpty,
			mustHaveScholarships: profile.mustHaveScholarships
		)
		
		let effectiveCost = lowestTuition - estimatedAid
		
		var baseScore: Double
		if effectiveCost <= affordableMax * 0.5 {
			baseScore = 1.0
		} else if effectiveCost <= affordableMax * 0.7 {
			baseScore = 0.9
		} else if effectiveCost <= affordableMax {
			baseScore = 0.7
		} else if effectiveCost <= affordableMax * 1.2 {
			baseScore = 0.5
		} else if effectiveCost <= affordableMax * 1.5 {
			baseScore = 0.3
		} else {
			baseScore = 0.1
		}
		
		// Scholarship bonus when required
		if profile.mustHaveScholarships && !uni.scholarshipsAvailable.isEmpty {
			let hasFullRide = uni.scholarshipsAvailable.contains { $0.isFullRide }
			if hasFullRide {
				baseScore = min(baseScore * 1.5, 1.0)
			} else {
				baseScore = min(baseScore * 1.2, 1.0)
			}
		}
		
		return baseScore
	}
	
	private func estimateFinancialAid(tuition: Double, income: Double, hasScholarships: Bool, mustHaveScholarships: Bool) -> Double {
		var aid: Double = 0
		
		// Need-based aid
		if income < 50000 {
			aid = tuition * 0.7
		} else if income < 75000 {
			aid = tuition * 0.5
		} else if income < 100000 {
			aid = tuition * 0.3
		} else if income < 150000 {
			aid = tuition * 0.15
		}
		
		// Merit scholarship boost
		if hasScholarships {
			if mustHaveScholarships {
				aid += tuition * 0.2  // Higher when required
			} else {
				aid += tuition * 0.1  // Standard
			}
		}
		
		return min(aid, tuition * 0.9)
	}
	// MARK: - Program Match (25% weight)
	
	private func calculateProgramMatch(_ uni: University, _ profile: UserProfile) -> Double {
		if profile.interestedPrograms.isEmpty {
			return 0.5 // Neutral if no preferences
		}
		
		let matchingPrograms = uni.programs.filter { program in
			profile.interestedPrograms.contains(program)
		}
		
		let matchCount = matchingPrograms.count
		let totalInterests = profile.interestedPrograms.count
		
		// Perfect match
		if matchCount == totalInterests && totalInterests > 0 {
			return 1.0
		}
		
		// Partial match
		let baseScore = Double(matchCount) / Double(totalInterests)
		
		// Bonus if university has strong reputation in those fields
		let hasTopProgram = uni.tags.contains("STEM") && profile.interestedPrograms.contains {
			["Computer Science", "Engineering", "Physics", "Mathematics"].contains($0)
		}
		
		if hasTopProgram {
			return min(baseScore * 1.2, 1.0)
		}
		
		return baseScore
	}
	
	// MARK: - Preference Match (10% weight)
	
	private func calculatePreferenceMatch(_ uni: University, _ profile: UserProfile) -> Double {
		var matchPoints = 0
		var totalPoints = 0
		
		// Location preference
		if !profile.preferredLocations.isEmpty {
			totalPoints += 2
			for location in profile.preferredLocations {
				if uni.location.contains(location) {
					matchPoints += 2
					break
				}
			}
		}
		
		// Campus size preference
		if let sizePreference = profile.campusSizePreference,
		   let campusSize = uni.campusSize {
			totalPoints += 1
			if sizePreference.contains(campusSize) || campusSize.contains(sizePreference.components(separatedBy: " ")[0]) {
				matchPoints += 1
			}
		}
		
		// Tags/characteristics match
		if !profile.preferredTags.isEmpty {
			totalPoints += 2
			let matchingTags = uni.tags.filter { profile.preferredTags.contains($0) }
			if matchingTags.count >= 2 {
				matchPoints += 2
			} else if matchingTags.count == 1 {
				matchPoints += 1
			}
		}
		
		if totalPoints == 0 {
			return 0.5 // Neutral if no preferences
		}
		
		return Double(matchPoints) / Double(totalPoints)
	}
	
	// MARK: - Generate Human-Readable Reasons
	
	private func generateMatchReasons(
		_ uni: University,
		profile: UserProfile,
		acceptance: Double,
		affordability: Double,
		program: Double,
		preference: Double
	) -> (positive: [String], negative: [String]) {
		
		var positive: [String] = []
		var negative: [String] = []
		
		// Acceptance reasons
		if acceptance >= 0.7 {
			positive.append("Strong acceptance chance (\(Int(acceptance * 100))%)")
		} else if acceptance >= 0.5 {
			positive.append("Good acceptance chance (\(Int(acceptance * 100))%)")
		} else if acceptance >= 0.3 {
			negative.append("Competitive admissions (\(Int(acceptance * 100))% chance)")
		} else {
			negative.append("Reach school - below typical admits")
		}
		
		// Affordability reasons
		if affordability >= 0.8 {
			positive.append("Very affordable with aid")
		} else if affordability >= 0.6 {
			positive.append("Within your budget")
		} else if affordability >= 0.4 {
			negative.append("May require loans")
		} else {
			negative.append("Above your target budget")
		}
		
		// Program reasons
		if program >= 0.8 {
			positive.append("Excellent program match")
		} else if program >= 0.5 {
			positive.append("Offers your programs")
		} else if program < 0.3 {
			negative.append("Limited programs in your interests")
		}
		
		// Preference reasons
		if !profile.preferredLocations.isEmpty {
			let inPreferredLocation = profile.preferredLocations.contains { uni.location.contains($0) }
			if inPreferredLocation {
				positive.append("In your preferred location")
			}
		}
		
		if !profile.preferredTags.isEmpty {
			let matchingTags = uni.tags.filter { profile.preferredTags.contains($0) }
			if matchingTags.count >= 2 {
				positive.append("Matches your interests: \(matchingTags.prefix(2).joined(separator: ", "))")
			}
		}
		
		// Scholarships
		if !uni.scholarshipsAvailable.isEmpty {
			let fullRideCount = uni.scholarshipsAvailable.filter { $0.isFullRide }.count
			
			if fullRideCount > 0 {
				positive.append("\(fullRideCount) full-ride scholarship(s) available!")
			} else {
				positive.append("\(uni.scholarshipsAvailable.count) scholarship(s) available")
			}
			
			if profile.mustHaveScholarships {
				positive.append("Meets your scholarship requirement ✓")
			}
		} else if profile.mustHaveScholarships {
			negative.append("No scholarships available (you require one)")
		}
		
		return (positive: positive, negative: negative)
	}
	
	// MARK: - Quick Category Classification
	
	func classifyUniversity(_ score: UniversityMatchScore, profile: UserProfile) -> String {
		let acceptance = score.acceptanceScore
		
		if acceptance >= 0.7 {
			return "Safety"
		} else if acceptance >= 0.4 {
			return "Target"
		} else {
			return "Reach"
		}
	}
}
