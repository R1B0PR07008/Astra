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
	
	// 6. Tecnológico de Costa Rica
	University(
		id: UUID(),
		imageName: "6",
		name: "Tecnológico de Costa Rica",
		location: "Cartago, Costa Rica",
		subtitle: "Public • Engineering Focus",
		description: "El TEC es la principal institución de educación superior tecnológica de Costa Rica. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Reconocido por su excelencia en ingeniería y ciencias aplicadas.",
		websiteURL: "https://www.tec.ac.cr",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.50,
		minSAT: 1150,
		minACT: 24,
		acceptanceRate: 0.45,
		minRequirementText: "GPA 3.50+ • SAT 1150+ • ACT 24+",
		tuitionPrices: [
			TuitionPrice(amount: 2500, currency: "USD", period: "per year", type: "Costa Rican Students", financialAidAvailable: true),
			TuitionPrice(amount: 6000, currency: "USD", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.6,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Carlos M.",
				major: "Computer Engineering",
				graduationYear: 2023,
				summary: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores.",
				pros: ["Excellent engineering", "Affordable", "Strong industry connections"],
				cons: ["Limited international recognition", "Smaller campus"],
				date: Date()
			)
		],
		programs: ["Engineering", "Computer Science", "Biotechnology", "Environmental Science", "Design"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Beca TEC",
				amount: 2000,
				currency: "USD",
				requirements: "Academic excellence",
				deadline: Calendar.current.date(byAdding: .month, value: 5, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 10000,
		campusSize: "Medium",
		tags: ["Engineering", "Technology", "Affordable", "Research"]
	),

	// (7) 9. UNAM (Universidad Nacional Autónoma de México)
	University(
		id: UUID(),
		imageName: "9",
		name: "Universidad Nacional Autónoma de México",
		location: "Mexico City, Mexico",
		subtitle: "Public • Research University",
		description: "La UNAM es una de las universidades más prestigiosas de América Latina. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Reconocida mundialmente por su excelencia académica y contribuciones a la investigación científica.",
		websiteURL: "https://www.unam.mx",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.60,
		minSAT: 1200,
		minACT: 26,
		acceptanceRate: 0.08,
		minRequirementText: "GPA 3.60+ • SAT 1200+ • ACT 26+",
		tuitionPrices: [
			TuitionPrice(amount: 500, currency: "USD", period: "per year", type: "Mexican Students", financialAidAvailable: true),
			TuitionPrice(amount: 8000, currency: "USD", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.8,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "María G.",
				major: "Engineering",
				graduationYear: 2024,
				summary: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates.",
				pros: ["Prestigious reputation", "Very affordable", "Strong research"],
				cons: ["Large class sizes", "Competitive entry"],
				date: Date()
			)
		],
		programs: ["Engineering", "Medicine", "Law", "Architecture", "Biology"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Beca UNAM",
				amount: 3000,
				currency: "USD",
				requirements: "Academic excellence",
				deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 356000,
		campusSize: "Very Large",
		tags: ["Public", "Research", "Historic", "Affordable"]
	),

	// (8) 10. Tecnológico de Monterrey
	University(
		id: UUID(),
		imageName: "10",
		name: "Instituto Tecnológico y de Estudios Superiores de Monterrey",
		location: "Monterrey, Nuevo León, Mexico",
		subtitle: "Private • Technology Focus",
		description: "El Tec de Monterrey es una institución líder en innovación y emprendimiento. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ofrece programas de clase mundial con enfoque empresarial y tecnológico.",
		websiteURL: "https://www.tec.mx",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.70,
		minSAT: 1300,
		minACT: 28,
		acceptanceRate: 0.36,
		minRequirementText: "GPA 3.70+ • SAT 1300+ • ACT 28+",
		tuitionPrices: [
			TuitionPrice(amount: 15000, currency: "USD", period: "per year", type: "Mexican Students", financialAidAvailable: true),
			TuitionPrice(amount: 18000, currency: "USD", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Roberto S.",
				major: "Business Administration",
				graduationYear: 2024,
				summary: "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat.",
				pros: ["Innovation focus", "Strong business programs", "Entrepreneurship culture"],
				cons: ["Higher tuition", "Competitive environment"],
				date: Date()
			)
		],
		programs: ["Engineering", "Business", "Computer Science", "Innovation", "Entrepreneurship"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Beca Excelencia",
				amount: 10000,
				currency: "USD",
				requirements: "Academic excellence, SAT 1400+",
				deadline: Calendar.current.date(byAdding: .month, value: 7, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 94000,
		campusSize: "Very Large",
		tags: ["Innovation", "Business", "Tech", "Entrepreneurship"]
	),

	// (9) 11. Universidad de Buenos Aires
	University(
		id: UUID(),
		imageName: "11",
		name: "Universidad de Buenos Aires",
		location: "Buenos Aires, Argentina",
		subtitle: "Public • Research University",
		description: "La UBA es una de las universidades más prestigiosas de América Latina. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium. Educación pública gratuita de alta calidad.",
		websiteURL: "https://www.uba.ar",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.40,
		minSAT: 1100,
		minACT: 23,
		acceptanceRate: 0.28,
		minRequirementText: "GPA 3.40+ • SAT 1100+ • ACT 23+",
		tuitionPrices: [
			TuitionPrice(amount: 0, currency: "USD", period: "per year", type: "All Students", financialAidAvailable: false)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Sofía L.",
				major: "Medicine",
				graduationYear: 2023,
				summary: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
				pros: ["Free tuition", "Strong academics", "Historic prestige"],
				cons: ["Very large", "Bureaucratic"],
				date: Date()
			)
		],
		programs: ["Medicine", "Law", "Economics", "Psychology", "Engineering"],
		scholarshipsAvailable: [],
		studentPopulation: 308000,
		campusSize: "Very Large",
		tags: ["Public", "Free Tuition", "Research", "Historic"]
	),

	// (10) 13. Pontificia Universidad Católica de Chile
	University(
		id: UUID(),
		imageName: "13",
		name: "Pontificia Universidad Católica de Chile",
		location: "Santiago, Chile",
		subtitle: "Private • Research University",
		description: "La UC es la universidad líder de Chile y una de las más prestigiosas de América Latina. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet. Excelencia académica reconocida internacionalmente.",
		websiteURL: "https://www.uc.cl",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.65,
		minSAT: 1250,
		minACT: 27,
		acceptanceRate: 0.20,
		minRequirementText: "GPA 3.65+ • SAT 1250+ • ACT 27+",
		tuitionPrices: [
			TuitionPrice(amount: 8500, currency: "USD", period: "per year", type: "Chilean Students", financialAidAvailable: true),
			TuitionPrice(amount: 12000, currency: "USD", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.7,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 5,
				studentName: "Diego P.",
				major: "Engineering",
				graduationYear: 2024,
				summary: "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur.",
				pros: ["Top in Chile", "Strong research", "International connections"],
				cons: ["Expensive for region", "Conservative culture"],
				date: Date()
			)
		],
		programs: ["Engineering", "Medicine", "Business", "Law", "Architecture"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Beca Excelencia Académica",
				amount: 5000,
				currency: "USD",
				requirements: "Top academic performance",
				deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
				isFullRide: false,
				isMeritBased: true
			)
		],
		studentPopulation: 30000,
		campusSize: "Large",
		tags: ["Catholic", "Research", "Prestigious", "Urban"]
	),

	// (11) 14. Universidad de los Andes
	University(
		id: UUID(),
		imageName: "14",
		name: "Universidad de los Andes",
		location: "Bogotá, Colombia",
		subtitle: "Private • Liberal Arts",
		description: "Los Andes es la universidad privada más prestigiosa de Colombia. Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse. Enfoque en formación integral y pensamiento crítico.",
		websiteURL: "https://www.uniandes.edu.co",
		isSelected: false,
		isFavorite: false,
		minGPA: 3.60,
		minSAT: 1220,
		minACT: 26,
		acceptanceRate: 0.30,
		minRequirementText: "GPA 3.60+ • SAT 1220+ • ACT 26+",
		tuitionPrices: [
			TuitionPrice(amount: 9000, currency: "USD", period: "per year", type: "Colombian Students", financialAidAvailable: true),
			TuitionPrice(amount: 13000, currency: "USD", period: "per year", type: "International", financialAidAvailable: true)
		],
		overallRating: 4.6,
		reviews: [
			UniversityReview(
				id: UUID(),
				stars: 4,
				studentName: "Camila R.",
				major: "Political Science",
				graduationYear: 2023,
				summary: "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime.",
				pros: ["Liberal arts focus", "Urban location", "International exchange programs"],
				cons: ["Expensive for Colombia", "Bogotá traffic"],
				date: Date()
			)
		],
		programs: ["Engineering", "Business", "Law", "Political Science", "Economics"],
		scholarshipsAvailable: [
			Scholarship(
				id: UUID(),
				name: "Beca Equidad",
				amount: 7000,
				currency: "USD",
				requirements: "Need and merit based",
				deadline: Calendar.current.date(byAdding: .month, value: 5, to: Date()),
				isFullRide: false,
				isMeritBased: false
			)
		],
		studentPopulation: 19000,
		campusSize: "Medium",
		tags: ["Liberal Arts", "Urban", "Research", "International"]
	),
	
	// (12) 15. University of Pennsylvania
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
	
	// (13) 16. Johns Hopkins University
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
