//
//  matches.swift
//  Astra
//

import SwiftUI

@available(iOS 26.0, *)
struct MatchesView: View {
	
	@Environment(\.colorScheme) var colorScheme
	@Binding var universities: [University]
	@ObservedObject var profileManager: ProfileManager  // ADD THIS
	
	@State private var selectedFilter: FilterType = .all
	@State private var showingDetail: University? = nil
	
	// ADD THIS - recommendation engine for sorting
	private let recommendationEngine = UniversityRecommendationEngine()
	
	enum FilterType: String, CaseIterable {
		case all = "All"
		case favorites = "Favorites"
		case added = "Added"
	}
	
	// Sorted by match score, highest first
	var rankedFilteredUniversities: [University] {
		let ranked = recommendationEngine.rankUniversities(universities, profile: profileManager.profile)
		
		switch selectedFilter {
		case .all:
			return ranked
				.filter { $0.university.isFavorite || $0.university.isSelected }
				.map { $0.university }
		case .favorites:
			return ranked
				.filter { $0.university.isFavorite }
				.map { $0.university }
		case .added:
			return ranked
				.filter { $0.university.isSelected }
				.map { $0.university }
		}
	}
	
	// Keep this for empty state and filter counts
	var filteredUniversities: [University] {
		switch selectedFilter {
		case .all:
			return universities.filter { $0.isFavorite || $0.isSelected }
		case .favorites:
			return universities.filter { $0.isFavorite }
		case .added:
			return universities.filter { $0.isSelected }
		}
	}
	
	var body: some View {
		ZStack {
			// Background
			LinearGradient(
				colors: colorScheme == .dark ? [
					Color.black,
					Color(red: 0.05, green: 0.1, blue: 0.15),
					Color.black
				] : [
					Color(red: 0.95, green: 0.97, blue: 1.0),
					Color.white,
					Color(red: 0.90, green: 0.95, blue: 1.0)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			
			VStack(spacing: 0) {
				// Header
				headerView
				
				// Filter tabs
				filterTabs
				
				// Content
				if filteredUniversities.isEmpty {
					emptyStateView
				} else {
					matchesListView
				}
			}
		}
		.sheet(item: $showingDetail) { university in
			UniversityDetailView(university: university)
		}
	}
	
	// MARK: - Header
	
	private var headerView: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				VStack(alignment: .leading, spacing: 4) {
					Text("Your Matches")
						.font(.system(size: 40, weight: .bold, design: .rounded))
						.foregroundStyle(
							LinearGradient(
								colors: [Color.Accent, Color.Primary],
								startPoint: .leading,
								endPoint: .trailing
							)
						)
					
					Text("\(filteredUniversities.count) \(filteredUniversities.count == 1 ? "university" : "universities")")
						.font(.system(size: 16, weight: .medium))
						.foregroundColor(.secondary)
				}
				
				Spacer()
				
				// Sort indicator badge
				HStack(spacing: 4) {
					Image(systemName: "arrow.down.circle.fill")
						.font(.system(size: 12))
					Text("Best Match")
						.font(.system(size: 12, weight: .semibold))
				}
				.foregroundColor(Color.Accent)
				.padding(.horizontal, 10)
				.padding(.vertical, 5)
				.background(
					Capsule()
						.fill(Color.Accent.opacity(0.12))
				)
			}
			.padding(.horizontal, 24)
			.padding(.top, 20)
			.padding(.bottom, 16)
		}
	}
	
	// MARK: - Filter Tabs
	
	private var filterTabs: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(FilterType.allCases, id: \.self) { filter in
					FilterChip(
						title: filter.rawValue,
						count: countForFilter(filter),
						isSelected: selectedFilter == filter
					) {
						withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
							selectedFilter = filter
						}
					}
				}
			}
			.padding(.horizontal, 24)
			.padding(.vertical, 12)
		}
		.background(.ultraThinMaterial)
	}
	
	private func countForFilter(_ filter: FilterType) -> Int {
		switch filter {
		case .all:
			return universities.filter { $0.isFavorite || $0.isSelected }.count
		case .favorites:
			return universities.filter { $0.isFavorite }.count
		case .added:
			return universities.filter { $0.isSelected }.count
		}
	}
	
	// MARK: - Matches List (now uses rankedFilteredUniversities)
	
	private var matchesListView: some View {
		ScrollView {
			LazyVStack(spacing: 16) {
				ForEach(rankedFilteredUniversities) { university in
					if let index = universities.firstIndex(where: { $0.id == university.id }) {
						
						// Get this university's match score for display
						let matchScore = recommendationEngine
							.rankUniversities([university], profile: profileManager.profile)
							.first?.overallScore ?? 0
						
						UniversityMatchCard(
							university: university,
							matchScore: matchScore,  // Pass score to card
							onFavorite: {
								withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
									universities[index].isFavorite.toggle()
								}
							},
							onAdd: {
								withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
									universities[index].isSelected.toggle()
								}
							},
							onTap: {
								showingDetail = university
							}
						)
						.transition(.asymmetric(
							insertion: .scale.combined(with: .opacity),
							removal: .opacity
						))
					}
				}
			}
			.padding(.horizontal, 20)
			.padding(.vertical, 16)
		}
	}
	
	// MARK: - Empty State
	
	private var emptyStateView: some View {
		VStack(spacing: 24) {
			Spacer()
			
			ZStack {
				Circle()
					.fill(
						LinearGradient(
							colors: [Color.Accent.opacity(0.2), Color.Primary.opacity(0.1)],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.frame(width: 120, height: 120)
				
				Image(systemName: emptyStateIcon)
					.font(.system(size: 50, weight: .light))
					.foregroundStyle(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
			}
			
			VStack(spacing: 8) {
				Text(emptyStateTitle)
					.font(.system(size: 24, weight: .bold, design: .rounded))
					.foregroundColor(.primary)
				
				Text(emptyStateMessage)
					.font(.system(size: 16, weight: .medium))
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 40)
			}
			
			Spacer()
		}
	}
	
	private var emptyStateIcon: String {
		switch selectedFilter {
		case .all: return "heart.slash"
		case .favorites: return "heart"
		case .added: return "plus.circle"
		}
	}
	
	private var emptyStateTitle: String {
		switch selectedFilter {
		case .all: return "No Matches Yet"
		case .favorites: return "No Favorites"
		case .added: return "Nothing Added"
		}
	}
	
	private var emptyStateMessage: String {
		switch selectedFilter {
		case .all: return "Start exploring universities and add your favorites to see them here"
		case .favorites: return "Tap the heart icon on universities you love to save them here"
		case .added: return "Tap the plus icon to add universities to your list"
		}
	}
}

// MARK: - University Match Card (updated with matchScore)

struct UniversityMatchCard: View {
	let university: University
	let matchScore: Double          // ADD THIS
	let onFavorite: () -> Void
	let onAdd: () -> Void
	let onTap: () -> Void
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		Button(action: onTap) {
			HStack(spacing: 16) {
				// University image
				if let uiImage = UIImage(named: university.imageName) {
					Image(uiImage: uiImage)
						.resizable()
						.scaledToFill()
						.frame(width: 100, height: 120)
						.clipShape(RoundedRectangle(cornerRadius: 16))
				} else {
					RoundedRectangle(cornerRadius: 16)
						.fill(
							LinearGradient(
								colors: [Color.Accent.opacity(0.3), Color.Primary.opacity(0.2)],
								startPoint: .topLeading,
								endPoint: .bottomTrailing
							)
						)
						.frame(width: 100, height: 120)
						.overlay(
							Image(systemName: "building.columns.fill")
								.font(.system(size: 30))
								.foregroundColor(.white.opacity(0.5))
						)
				}
				
				// Info
				VStack(alignment: .leading, spacing: 8) {
					Text(university.name)
						.font(.system(size: 18, weight: .bold, design: .rounded))
						.foregroundColor(.primary)
						.lineLimit(2)
						.multilineTextAlignment(.leading)
					
					HStack(spacing: 4) {
						Image(systemName: "mappin.circle.fill")
							.font(.system(size: 12))
						Text(university.location)
							.font(.system(size: 14, weight: .medium))
							.lineLimit(1)
					}
					.foregroundColor(.secondary)
					
					HStack(spacing: 8) {
						// Rating badge
						HStack(spacing: 3) {
							Image(systemName: "star.fill")
								.font(.system(size: 10))
								.foregroundColor(.yellow)
							Text(String(format: "%.1f", university.overallRating))
								.font(.system(size: 12, weight: .semibold))
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(
							Capsule()
								.fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
						)
						
						// Acceptance rate
						if let acceptanceRate = university.acceptanceRate {
							Text("\(Int(acceptanceRate * 100))% acceptance")
								.font(.system(size: 11, weight: .medium))
								.foregroundColor(.secondary)
						}
					}
					
					// Match score badge  ← NEW
					HStack(spacing: 4) {
						Image(systemName: "sparkles")
							.font(.system(size: 10))
						Text("\(Int(matchScore * 100))% Match")
							.font(.system(size: 12, weight: .bold))
					}
					.foregroundColor(.white)
					.padding(.horizontal, 10)
					.padding(.vertical, 4)
					.background(
						Capsule()
							.fill(
								LinearGradient(
									colors: [Color.Accent, Color.Primary],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
					)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				
				// Action buttons
				VStack(spacing: 8) {
					Button(action: onFavorite) {
						Image(systemName: university.isFavorite ? "heart.fill" : "heart")
							.font(.system(size: 18, weight: .semibold))
							.foregroundStyle(university.isFavorite ? Color.red : Color.gray)
							.frame(width: 40, height: 40)
							.background(
								Circle()
									.fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
							)
					}
					
					Button(action: onAdd) {
						Image(systemName: university.isSelected ? "checkmark.circle.fill" : "plus.circle")
							.font(.system(size: 18, weight: .semibold))
							.foregroundStyle(university.isSelected ? Color.Accent : Color.gray)
							.frame(width: 40, height: 40)
							.background(
								Circle()
									.fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
							)
					}
				}
			}
			.padding(12)
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(.ultraThinMaterial)
					.shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
			)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

// MARK: - Rest of file unchanged below this point

struct UniversityDetailView: View {
	let university: University
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					// Hero image
					if let uiImage = UIImage(named: university.imageName) {
						Image(uiImage: uiImage)
							.resizable()
							.scaledToFill()
							.frame(width: UIScreen.main.bounds.width,height: 300)
							.clipped()
					}
					
					VStack(alignment: .leading, spacing: 16) {
						VStack(alignment: .leading, spacing: 8) {
							Text(university.name)
								.font(.system(size: 32, weight: .bold, design: .rounded))
							
							HStack {
								Image(systemName: "mappin.circle.fill")
								Text(university.location)
									.font(.system(size: 16, weight: .medium))
							}
							.foregroundColor(.secondary)
						}
						
						HStack(spacing: 16) {
							StatPill(icon: "star.fill", value: String(format: "%.1f", university.overallRating), label: "Rating", color: .yellow)
							
							if let acceptanceRate = university.acceptanceRate {
								StatPill(icon: "checkmark.circle.fill", value: "\(Int(acceptanceRate * 100))%", label: "Acceptance", color: .green)
							}
							
							if let population = university.studentPopulation {
								StatPill(icon: "person.2.fill", value: "\(population / 1000)K", label: "Students", color: .blue)
							}
						}
						
						VStack(alignment: .leading, spacing: 8) {
							Text("About")
								.font(.system(size: 20, weight: .bold))
							
							Text(university.description)
								.font(.system(size: 16))
								.foregroundColor(.secondary)
						}
						
						// Website
						VStack(alignment: .leading, spacing: 8) {
							Text("University Website")
								.font(.system(size: 18, weight: .bold))
								.foregroundColor(.primary)
							
							Link(university.websiteURL, destination: URL(string: university.websiteURL.hasPrefix("http") ? university.websiteURL : "https://\(university.websiteURL)")!)
								.font(.system(size: 15, weight: .medium))
								.foregroundColor(Color.Accent)
						}
						
						if !university.scholarshipsAvailable.isEmpty {
							Text("Scholarships")
								.font(.system(size: 20, weight: .bold))
							
							MoreInfo(university: university)
						}
						
						if !university.programs.isEmpty {
							VStack(alignment: .leading, spacing: 12) {
								Text("Programs")
									.font(.system(size: 20, weight: .bold))
								
								FlowLayout(spacing: 8) {
									ForEach(university.programs, id: \.self) { program in
										Text(program)
											.font(.system(size: 14, weight: .medium))
											.padding(.horizontal, 12)
											.padding(.vertical, 6)
											.background(Capsule().fill(Color.Accent.opacity(0.15)))
											.foregroundColor(Color.Accent)
									}
								}
							}
						}
						
						VStack(alignment: .leading, spacing: 8) {
							Text("Requirements")
								.font(.system(size: 20, weight: .bold))
							
							Text(university.minRequirementText)
								.font(.system(size: 16))
								.foregroundColor(.secondary)
						}
					}
					.padding(.horizontal, 20)
					.padding(.bottom, 40)
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Close") { dismiss() }
				}
			}
		}
	}
	
	private func MoreInfo(university: University) -> some View {
		return AnyView(
			VStack(alignment: .leading, spacing: 8) {
				ForEach(Array(university.scholarshipsAvailable.enumerated()), id: \.element.id) { index, scholarship in
					VStack(alignment: .leading, spacing: 4) {
						Text("\(index + 1)) \(scholarship.name)")
							.font(.system(size: 20, weight: .bold))
						
						if let deadline = scholarship.deadline {
							Text("Deadline: \(formatDate(deadline))")
								.font(.system(size: 14, weight: .medium))
								.foregroundColor(.secondary)
						}
						
						Text("- Scholarship Amount: \(formatCurrency(scholarship.amount))")
							.font(.system(size: 14, weight: .medium))
							.foregroundColor(.secondary)
						
						Text("- Requirements: \(scholarship.requirements)")
							.font(.system(size: 14, weight: .medium))
							.foregroundColor(.secondary)
					}
				}
			}
			.padding(.horizontal, 24)
		)
	}
	
	private func formatDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd/yyyy"
		return formatter.string(from: date)
	}
	
	private func formatCurrency(_ amount: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		return formatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
	}
}

// MARK: - Stat Pill Component

struct StatPill: View {
	let icon: String
	let value: String
	let label: String
	let color: Color
	
	var body: some View {
		VStack(spacing: 4) {
			HStack(spacing: 4) {
				Image(systemName: icon)
					.font(.system(size: 12))
					.foregroundColor(color)
				Text(value)
					.font(.system(size: 16, weight: .bold))
			}
			
			Text(label)
				.font(.system(size: 11, weight: .medium))
				.foregroundColor(.secondary)
		}
		.frame(maxWidth: .infinity)
		.padding(.vertical, 12)
		.background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
	}
}

// MARK: - Filter Chip Component

struct FilterChip: View {
	let title: String
	let count: Int
	let isSelected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack(spacing: 6) {
				Text(title)
					.font(.system(size: 15, weight: .semibold))
				
				Text("\(count)")
					.font(.system(size: 13, weight: .bold))
					.foregroundColor(isSelected ? .white.opacity(0.9) : Color.Accent)
					.padding(.horizontal, 8)
					.padding(.vertical, 2)
					.background(
						Capsule()
							.fill(isSelected ? Color.white.opacity(0.2) : Color.Accent.opacity(0.15))
					)
			}
			.foregroundColor(isSelected ? .white : .primary)
			.padding(.horizontal, 16)
			.padding(.vertical, 10)
			.background(
				Capsule()
					.fill(isSelected ?
						  LinearGradient(colors: [Color.Accent, Color.Primary], startPoint: .leading, endPoint: .trailing) :
							LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
					)
			)
			.shadow(color: isSelected ? Color.Accent.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
		}
		.buttonStyle(ScaleButtonStyle())
	}
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
	var spacing: CGFloat = 8
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
		return result.size
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
		for (index, subview) in subviews.enumerated() {
			subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
		}
	}
	
	struct FlowResult {
		var frames: [CGRect] = []
		var size: CGSize = .zero
		
		init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
			var currentX: CGFloat = 0
			var currentY: CGFloat = 0
			var lineHeight: CGFloat = 0
			
			for subview in subviews {
				let size = subview.sizeThatFits(.unspecified)
				
				if currentX + size.width > maxWidth && currentX > 0 {
					currentX = 0
					currentY += lineHeight + spacing
					lineHeight = 0
				}
				
				frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
				currentX += size.width + spacing
				lineHeight = max(lineHeight, size.height)
			}
			
			self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
		}
	}
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview {
	MatchesView(universities: .constant(sampleUniversities), profileManager: ProfileManager())
}
