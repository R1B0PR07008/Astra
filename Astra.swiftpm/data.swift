//
//  data.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import Foundation
import SwiftUI

// MARK: - Sample Data

let sampleUniversities: [University] = [
	// 1. Harvard University
	University(
		id: UUID(),
		imageName: "1",
		name: "Harvard University",
		location: "Cambridge, MA, USA",
		subtitle: "Ivy League • Private",
		description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
		websiteURL: "https://www.harvard.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.95,
		minSAT: 1520,
		minACT: 34,
		acceptanceRate: 0.037,
		minRequirementText: "GPA 3.95+ • SAT 1520+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 54269, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.9,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Sarah M.",
				major: "Computer Science",
				graduationYear: 2024,
				summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Excepteur sint occaecat cupidatat non proident.",
				pros: ["Amazing faculty", "Great networking", "Cutting-edge research"],
				cons: ["Very competitive", "High cost of living"],
				date: Date()
			)
		],
		programs: ["Computer Science", "Business", "Medicine", "Law", "Engineering"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Presidential Scholarship",
				amount: 50000,
				currency: "USD",
				requirements: "GPA 4.0, SAT 1550+",
				deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 23000,
		campusSize: "Large",
		tags: ["Ivy League", "Research", "Urban", "Elite"]
	),
	
	// 2. Stanford University
	University(
		id: UUID(),
		imageName: "2",
		name: "Stanford University",
		location: "Stanford, CA, USA",
		subtitle: "Private • Research University",
		description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
		websiteURL: "https://www.stanford.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.96,
		minSAT: 1505,
		minACT: 34,
		acceptanceRate: 0.039,
		minRequirementText: "GPA 3.96+ • SAT 1505+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 57693, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.8,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "James K.",
				major: "Electrical Engineering",
				graduationYear: 2023,
				summary: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
				pros: ["Silicon Valley connections", "Beautiful campus", "Innovation culture"],
				cons: ["Intense workload", "Competitive admissions"],
				date: Date()
			)
		],
		programs: ["Computer Science", "Engineering", "Business", "Medicine", "Data Science"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Knight-Hennessy Scholars",
				amount: 75000,
				currency: "USD",
				requirements: "Leadership, Academic Excellence",
				deadline: Calendar.current.date(byAdding: .month, value: 8, to: Date()),
				isFullRide: true,
				isMeritBased: true
			)
		],
		studentPopulation: 17249,
		campusSize: "Large",
		tags: ["Tech Hub", "Research", "Innovation", "Elite"]
	),
	
	// 3. MIT
	University(
		id: UUID(),
		imageName: "3",
		name: "Massachusetts Institute of Technology",
		location: "Cambridge, MA, USA",
		subtitle: "Private • STEM Focus",
		description: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet.",
		websiteURL: "https://www.mit.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.95,
		minSAT: 1535,
		minACT: 35,
		acceptanceRate: 0.033,
		minRequirementText: "GPA 3.95+ • SAT 1535+ • ACT 35+",
		tuitionPrices: [
			TuitionPrice(amount: 57986, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.9,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Emily R.",
				major: "Aerospace Engineering",
				graduationYear: 2024,
				summary: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum.",
				pros: ["World-class labs", "Hands-on learning", "Brilliant peers"],
				cons: ["Very demanding", "Stressful environment"],
				date: Date()
			)
		],
		programs: ["Engineering", "Computer Science", "Physics", "Mathematics", "Robotics"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "MIT Excellence Award",
				amount: 45000,
				currency: "USD",
				requirements: "STEM Excellence, Research Experience",
				deadline: Calendar.current.date(byAdding: .month, value: 7, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 11520,
		campusSize: "Medium",
		tags: ["STEM", "Research", "Innovation", "Engineering"]
	),
	
	// 4. Oxford University
	University(
		id: UUID(),
		imageName: "4",
		name: "University of Oxford",
		location: "Oxford, England, UK",
		subtitle: "Public • Historic",
		description: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus.",
		websiteURL: "https://www.ox.ac.uk",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.90,
		minSAT: 1470,
		minACT: 32,
		acceptanceRate: 0.175,
		minRequirementText: "GPA 3.90+ • SAT 1470+ • ACT 32+",
		tuitionPrices: [
			TuitionPrice(amount: 9250, currency: "GBP", period: "per year", type: "UK Students", financialAidAvailable: true),
			TuitionPrice(amount: 28950, currency: "GBP", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.8,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Oliver T.",
				major: "Philosophy",
				graduationYear: 2023,
				summary: "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.",
				pros: ["Historic prestige", "Tutorial system", "Beautiful colleges"],
				cons: ["Traditional structure", "UK weather"],
				date: Date()
			)
		],
		programs: ["Philosophy", "Medicine", "Law", "History", "Literature"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Rhodes Scholarship",
				amount: 18000,
				currency: "GBP",
				requirements: "Academic Excellence, Leadership",
				deadline: Calendar.current.date(byAdding: .month, value: 5, to: Date()),
				isFullRide: true,
				isMeritBased: true
			)
		],
		studentPopulation: 24515,
		campusSize: "Large",
		tags: ["Historic", "Prestigious", "Research", "Liberal Arts"]
	),
	
	// 5. UC Berkeley
	University(
		id: UUID(),
		imageName: "5",
		name: "University of California, Berkeley",
		location: "Berkeley, CA, USA",
		subtitle: "Public • Research University",
		description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.",
		websiteURL: "https://www.berkeley.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.89,
		minSAT: 1405,
		minACT: 31,
		acceptanceRate: 0.145,
		minRequirementText: "GPA 3.89+ • SAT 1405+ • ACT 31+",
		tuitionPrices: [
			TuitionPrice(amount: 14312, currency: "USD", period: "per year", type: "In-State", financialAidAvailable: true),
			TuitionPrice(amount: 44066, currency: "USD", period: "per year", type: "Out-of-State", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 4,
				studentName: "Maria L.",
				major: "Environmental Science",
				graduationYear: 2024,
				summary: "Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis.",
				pros: ["Strong academics", "Diverse community", "Bay Area location"],
				cons: ["Large class sizes", "Competitive"],
				date: Date()
			)
		],
		programs: ["Computer Science", "Engineering", "Business", "Environmental Science", "Data Science"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Regents' and Chancellor's Scholarship",
				amount: 25000,
				currency: "USD",
				requirements: "Top 1% of applicants",
				deadline: Calendar.current.date(byAdding: .month, value: 4, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 45057,
		campusSize: "Very Large",
		tags: ["Public Ivy", "Research", "Liberal", "Urban"]
	),
	
	// 6. Cambridge University
	University(
		id: UUID(),
		imageName: "6",
		name: "University of Cambridge",
		location: "Cambridge, England, UK",
		subtitle: "Public • Historic",
		description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
		websiteURL: "https://www.cam.ac.uk",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.92,
		minSAT: 1480,
		minACT: 33,
		acceptanceRate: 0.21,
		minRequirementText: "GPA 3.92+ • SAT 1480+ • ACT 33+",
		tuitionPrices: [
			TuitionPrice(amount: 9250, currency: "GBP", period: "per year", type: "UK Students", financialAidAvailable: true),
			TuitionPrice(amount: 25734, currency: "GBP", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.9,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Henry W.",
				major: "Mathematics",
				graduationYear: 2023,
				summary: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores.",
				pros: ["Academic rigor", "Supervision system", "Rich history"],
				cons: ["Intense workload", "Formal traditions"],
				date: Date()
			)
		],
		programs: ["Mathematics", "Natural Sciences", "Engineering", "Computer Science", "Medicine"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Gates Cambridge Scholarship",
				amount: 20000,
				currency: "GBP",
				requirements: "Outstanding academic achievement",
				deadline: Calendar.current.date(byAdding: .month, value: 9, to: Date()),
				isFullRide: true,
				isMeritBased: true
			)
		],
		studentPopulation: 23247,
		campusSize: "Large",
		tags: ["Historic", "Prestigious", "Research", "Traditional"]
	),
	
	// 7. Yale University
	University(
		id: UUID(),
		imageName: "7",
		name: "Yale University",
		location: "New Haven, CT, USA",
		subtitle: "Ivy League • Private",
		description: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.",
		websiteURL: "https://www.yale.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.94,
		minSAT: 1515,
		minACT: 34,
		acceptanceRate: 0.047,
		minRequirementText: "GPA 3.94+ • SAT 1515+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 62250, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.8,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Isabella C.",
				major: "Political Science",
				graduationYear: 2024,
				summary: "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam.",
				pros: ["Strong humanities", "Residential colleges", "Beautiful campus"],
				cons: ["High pressure", "Expensive area"],
				date: Date()
			)
		],
		programs: ["Law", "Political Science", "History", "Drama", "Medicine"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Yale Scholarship",
				amount: 60000,
				currency: "USD",
				requirements: "Need-based, no merit component",
				deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
				isFullRide: false,
				isMeritBased: false
			)
		],
		studentPopulation: 14776,
		campusSize: "Medium",
		tags: ["Ivy League", "Liberal Arts", "Historic", "Prestigious"]
	),
	
	// 8. Princeton University
	University(
		id: UUID(),
		imageName: "8",
		name: "Princeton University",
		location: "Princeton, NJ, USA",
		subtitle: "Ivy League • Private",
		description: "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur.",
		websiteURL: "https://www.princeton.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.95,
		minSAT: 1510,
		minACT: 34,
		acceptanceRate: 0.042,
		minRequirementText: "GPA 3.95+ • SAT 1510+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 57410, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.9,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Michael P.",
				major: "Economics",
				graduationYear: 2023,
				summary: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti.",
				pros: ["Undergraduate focus", "Strong financial aid", "Small classes"],
				cons: ["Suburban location", "Limited graduate programs"],
				date: Date()
			)
		],
		programs: ["Economics", "Mathematics", "Physics", "Politics", "Engineering"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Princeton Grant",
				amount: 55000,
				currency: "USD",
				requirements: "Need-based financial aid",
				deadline: Calendar.current.date(byAdding: .month, value: 5, to: Date()),
				isFullRide: false,
				isMeritBased: false
			)
		],
		studentPopulation: 8842,
		campusSize: "Medium",
		tags: ["Ivy League", "Undergraduate Focus", "Elite", "Research"]
	),
	
	// 9. Columbia University
	University(
		id: UUID(),
		imageName: "9",
		name: "Columbia University",
		location: "New York, NY, USA",
		subtitle: "Ivy League • Private",
		description: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.",
		websiteURL: "https://www.columbia.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.93,
		minSAT: 1505,
		minACT: 34,
		acceptanceRate: 0.038,
		minRequirementText: "GPA 3.93+ • SAT 1505+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 65524, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 4,
				studentName: "Sophia N.",
				major: "Journalism",
				graduationYear: 2024,
				summary: "Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur.",
				pros: ["NYC location", "Core curriculum", "Media connections"],
				cons: ["Very expensive city", "Stressful environment"],
				date: Date()
			)
		],
		programs: ["Journalism", "Business", "Engineering", "International Relations", "Film"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "C. P. Davis Scholarship",
				amount: 40000,
				currency: "USD",
				requirements: "Academic merit and need",
				deadline: Calendar.current.date(byAdding: .month, value: 7, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 33413,
		campusSize: "Large",
		tags: ["Ivy League", "Urban", "Diverse", "Media"]
	),
	
	// 10. Caltech
	University(
		id: UUID(),
		imageName: "10",
		name: "California Institute of Technology",
		location: "Pasadena, CA, USA",
		subtitle: "Private • STEM Elite",
		description: "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.",
		websiteURL: "https://www.caltech.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.98,
		minSAT: 1545,
		minACT: 35,
		acceptanceRate: 0.034,
		minRequirementText: "GPA 3.98+ • SAT 1545+ • ACT 35+",
		tuitionPrices: [
			TuitionPrice(amount: 60864, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.9,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "David L.",
				major: "Physics",
				graduationYear: 2023,
				summary: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates.",
				pros: ["Small student body", "Top STEM programs", "Research opportunities"],
				cons: ["Very intense", "Limited social scene"],
				date: Date()
			)
		],
		programs: ["Physics", "Engineering", "Chemistry", "Computer Science", "Astronomy"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Caltech Merit Scholarship",
				amount: 50000,
				currency: "USD",
				requirements: "Exceptional STEM achievement",
				deadline: Calendar.current.date(byAdding: .month, value: 8, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 2397,
		campusSize: "Small",
		tags: ["STEM", "Elite", "Research", "Small"]
	),
	
	// 11. University of Chicago
	University(
		id: UUID(),
		imageName: "11",
		name: "University of Chicago",
		location: "Chicago, IL, USA",
		subtitle: "Private • Research University",
		description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae.",
		websiteURL: "https://www.uchicago.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.92,
		minSAT: 1520,
		minACT: 34,
		acceptanceRate: 0.056,
		minRequirementText: "GPA 3.92+ • SAT 1520+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 62940, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Rachel B.",
				major: "Economics",
				graduationYear: 2024,
				summary: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur.",
				pros: ["Intellectual culture", "Strong economics", "Core curriculum"],
				cons: ["Where fun goes to die", "Harsh winters"],
				date: Date()
			)
		],
		programs: ["Economics", "Law", "Business", "Political Science", "Sociology"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "University Scholarship",
				amount: 35000,
				currency: "USD",
				requirements: "Academic excellence",
				deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 18452,
		campusSize: "Medium",
		tags: ["Intellectual", "Economics", "Research", "Urban"]
	),
	
	// 12. Duke University
	University(
		id: UUID(),
		imageName: "12",
		name: "Duke University",
		location: "Durham, NC, USA",
		subtitle: "Private • Research University",
		description: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.",
		websiteURL: "https://www.duke.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.94,
		minSAT: 1510,
		minACT: 34,
		acceptanceRate: 0.058,
		minRequirementText: "GPA 3.94+ • SAT 1510+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 63054, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.8,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Andrew T.",
				major: "Biomedical Engineering",
				graduationYear: 2023,
				summary: "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid.",
				pros: ["Strong athletics", "Beautiful campus", "Great medical programs"],
				cons: ["Southern location", "Greek life dominant"],
				date: Date()
			)
		],
		programs: ["Biomedical Engineering", "Business", "Public Policy", "Medicine", "Law"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Robertson Scholars Leadership Program",
				amount: 70000,
				currency: "USD",
				requirements: "Leadership and academic excellence",
				deadline: Calendar.current.date(byAdding: .month, value: 9, to: Date()),
				isFullRide: true,
				isMeritBased: true
			)
		],
		studentPopulation: 17620,
		campusSize: "Large",
		tags: ["Sports", "Research", "Medical", "Beautiful Campus"]
	),
	
	// 13. Northwestern University
	University(
		id: UUID(),
		imageName: "13",
		name: "Northwestern University",
		location: "Evanston, IL, USA",
		subtitle: "Private • Research University",
		description: "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur.",
		websiteURL: "https://www.northwestern.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.92,
		minSAT: 1490,
		minACT: 33,
		acceptanceRate: 0.070,
		minRequirementText: "GPA 3.92+ • SAT 1490+ • ACT 33+",
		tuitionPrices: [
			TuitionPrice(amount: 63468, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.6,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 4,
				studentName: "Jennifer S.",
				major: "Journalism",
				graduationYear: 2024,
				summary: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti.",
				pros: ["Strong journalism", "Chicago access", "Great co-op programs"],
				cons: ["Cold winters", "Expensive"],
				date: Date()
			)
		],
		programs: ["Journalism", "Engineering", "Business", "Theater", "Communications"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Northwestern Scholarship",
				amount: 30000,
				currency: "USD",
				requirements: "Need and merit based",
				deadline: Calendar.current.date(byAdding: .month, value: 5, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 22603,
		campusSize: "Large",
		tags: ["Journalism", "Big Ten", "Urban", "Research"]
	),
	
	// 14. Cornell University
	University(
		id: UUID(),
		imageName: "14",
		name: "Cornell University",
		location: "Ithaca, NY, USA",
		subtitle: "Ivy League • Private",
		description: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus.",
		websiteURL: "https://www.cornell.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.90,
		minSAT: 1480,
		minACT: 33,
		acceptanceRate: 0.087,
		minRequirementText: "GPA 3.90+ • SAT 1480+ • ACT 33+",
		tuitionPrices: [
			TuitionPrice(amount: 63200, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.6,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 4,
				studentName: "Kevin M.",
				major: "Hotel Administration",
				graduationYear: 2023,
				summary: "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime.",
				pros: ["Diverse programs", "Beautiful gorges", "Strong alumni network"],
				cons: ["Isolated location", "Cold climate", "Competitive"],
				date: Date()
			)
		],
		programs: ["Engineering", "Hotel Administration", "Agriculture", "Architecture", "Veterinary"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Cornell Tradition Fellowship",
				amount: 25000,
				currency: "USD",
				requirements: "Work-study commitment",
				deadline: Calendar.current.date(byAdding: .month, value: 4, to: Date()),
				isFullRide: false,
				isMeritBased: false
			)
		],
		studentPopulation: 25898,
		campusSize: "Large",
		tags: ["Ivy League", "Diverse Programs", "Rural", "Beautiful"]
	),
	
	// 15. University of Pennsylvania
	University(
		id: UUID(),
		imageName: "15",
		name: "University of Pennsylvania",
		location: "Philadelphia, PA, USA",
		subtitle: "Ivy League • Private",
		description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.",
		websiteURL: "https://www.upenn.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.93,
		minSAT: 1510,
		minACT: 34,
		acceptanceRate: 0.053,
		minRequirementText: "GPA 3.93+ • SAT 1510+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 63452, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Amanda K.",
				major: "Business (Wharton)",
				graduationYear: 2024,
				summary: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
				pros: ["Wharton School", "Urban location", "Social ivy"],
				cons: ["Very pre-professional", "Competitive culture"],
				date: Date()
			)
		],
		programs: ["Business (Wharton)", "Engineering", "Medicine", "Nursing", "Law"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Benjamin Franklin Scholars",
				amount: 45000,
				currency: "USD",
				requirements: "Academic excellence",
				deadline: Calendar.current.date(byAdding: .month, value: 7, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 28201,
		campusSize: "Large",
		tags: ["Ivy League", "Business", "Urban", "Pre-professional"]
	),
	
	// 16. Johns Hopkins University
	University(
		id: UUID(),
		imageName: "16",
		name: "Johns Hopkins University",
		location: "Baltimore, MD, USA",
		subtitle: "Private • Research University",
		description: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
		websiteURL: "https://www.jhu.edu",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.93,
		minSAT: 1520,
		minACT: 34,
		acceptanceRate: 0.075,
		minRequirementText: "GPA 3.93+ • SAT 1520+ • ACT 34+",
		tuitionPrices: [
			TuitionPrice(amount: 60480, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Brian C.",
				major: "Public Health",
				graduationYear: 2023,
				summary: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.",
				pros: ["Top medical school", "Research funding", "Strong STEM"],
				cons: ["Pre-med culture intense", "Baltimore location"],
				date: Date()
			)
		],
		programs: ["Medicine", "Public Health", "Biomedical Engineering", "International Relations", "Neuroscience"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Hodson Trust Scholarship",
				amount: 60000,
				currency: "USD",
				requirements: "Top 1% of admitted students",
				deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
				isFullRide: true,
				isMeritBased: true
			)
		],
		studentPopulation: 26402,
		campusSize: "Large",
		tags: ["Medical", "Research", "STEM", "Pre-med"]
	)
]

// MARK: - Helper Functions

extension Array where Element == University {
	func filtered(by preferences: UserPreferences) -> [University] {
		return self.filter { university in
			// Filter by max tuition
			if let maxTuition = preferences.maxTuition {
				let minPrice = university.tuitionPrices.map { $0.amount }.min() ?? 0
				if minPrice > maxTuition {
					return false
				}
			}
			
			// Filter by programs
			if !preferences.preferredPrograms.isEmpty {
				let hasProgram = university.programs.contains { program in
					preferences.preferredPrograms.contains(program)
				}
				if !hasProgram {
					return false
				}
			}
			
			// Filter by tags
			if !preferences.preferredTags.isEmpty {
				let hasTag = university.tags.contains { tag in
					preferences.preferredTags.contains(tag)
				}
				if !hasTag {
					return false
				}
			}
			
			return true
		}
	}
	
	func sortedByMatch(preferences: UserPreferences) -> [University] {
		return self.sorted { uni1, uni2 in
			let score1 = calculateMatchScore(university: uni1, preferences: preferences)
			let score2 = calculateMatchScore(university: uni2, preferences: preferences)
			return score1 > score2
		}
	}
	
	private func calculateMatchScore(university: University, preferences: UserPreferences) -> Int {
		var score = 0
		
		// Score based on program matches
		for program in university.programs {
			if preferences.preferredPrograms.contains(program) {
				score += 10
			}
		}
		
		// Score based on tag matches
		for tag in university.tags {
			if preferences.preferredTags.contains(tag) {
				score += 5
			}
		}
		
		// Score based on scholarships
		if preferences.mustHaveScholarships && !university.scholarshipsAvailable.isEmpty {
			score += 15
		}
		
		return score
	}
}

// MARK: - User Preferences

// Sample user preferences
let sampleUserPreferences = UserPreferences(
	preferredLocations: ["USA", "UK"],
	maxTuition: 50000,
	minAcceptanceRate: nil,
	maxAcceptanceRate: 0.10,
	preferredPrograms: ["Computer Science", "Engineering"],
	preferredTags: ["STEM", "Research", "Innovation"],
	campusSizePreference: "Large",
	mustHaveScholarships: true
)
