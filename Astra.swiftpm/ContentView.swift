import SwiftUI

extension Color {
	static let Accent = Color(red: 0.2, green: 0.6, blue: 0.9)        // Blue accent
	static let Primary = Color(red: 0.3, green: 0.65, blue: 0.95)     // Lighter blue
	static let Secondary = Color(red: 0.5, green: 0.75, blue: 1.0)    // Sky blue
	static let Background = Color(red: 0.95, green: 0.97, blue: 1.0)  // Light blue-white
}

@available(iOS 26.0, *)
struct ContentView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	@Binding var universities: [University]
	@ObservedObject var profileManager: ProfileManager
	
	@State private var rankedUniversities: [UniversityMatchScore] = []
	@State private var showProfileSetup = false
	@State private var expandedCards: Set<UUID> = []
	@State private var showMoreInfo = false
	@State private var showReviews = false
	@State private var selectedUniversity: University?
	@State private var dragOffset: CGFloat = 0
	
	private let recommendationEngine = UniversityRecommendationEngine()
	
	var body: some View {
		ZStack {
			// Background gradient
			LinearGradient(
				colors: colorScheme == .dark ? [
					Color.black,
					Color(red: 0.1, green: 0.05, blue: 0.05)
				] : [
					Color.Background,
					Color.white
				],
				startPoint: .top,
				endPoint: .bottom
			)
			.ignoresSafeArea()
			
			// University cards (full screen scrolling)
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 0) {
					ForEach(rankedUniversities.indices, id: \.self) { index in
						universityCard(at: index)
					}
				}
			}
			.scrollTargetBehavior(.paging)
			.padding(.horizontal, 10)
			.ignoresSafeArea()
			
			// Header overlay (floating on top)
			VStack {
//				headerView
				Spacer()
			}
			
			// Bottom sheet overlay
			if showMoreInfo, let university = selectedUniversity {
				Color.black.opacity(0.3)
					.ignoresSafeArea()
					.onTapGesture {
						withAnimation(.spring()) {
							showMoreInfo = false
						}
					}
					.transition(.opacity)
				
				MoreInfoSheet(university: university, showMoreInfo: $showMoreInfo)
					.transition(.move(edge: .bottom))
					.offset(y: dragOffset)
					.gesture(
						DragGesture()
							.onChanged { value in
								if value.translation.height > 0 {
									dragOffset = value.translation.height
								}
							}
							.onEnded { value in
								if value.translation.height > 150 {
									withAnimation(.spring()) {
										showMoreInfo = false
										dragOffset = 0
									}
								} else {
									withAnimation(.spring()) {
										dragOffset = 0
									}
								}
							}
					)
			}
			
			if showReviews, let university = selectedUniversity {
				Color.black.opacity(0.3)
					.ignoresSafeArea()
					.onTapGesture {
						withAnimation(.spring()) {
							showReviews = false
						}
					}
					.transition(.opacity)
				
				ReviewsView(university: university, showReviews: $showReviews)
					.transition(.move(edge: .bottom))
					.offset(y: dragOffset)
					.gesture(
						DragGesture()
							.onChanged { value in
								if value.translation.height > 0 {
									dragOffset = value.translation.height
								}
							}
							.onEnded { value in
								if value.translation.height > 150 {
									withAnimation(.spring()) {
										showReviews = false
										dragOffset = 0
									}
								} else {
									withAnimation(.spring()) {
										dragOffset = 0
									}
								}
							}
					)
				
				
			}
		}
		.onAppear {
			rankUniversities()
		}
		.onChange(of: profileManager.profile) { _, _ in
			rankUniversities()
		}
		.sheet(isPresented: $showProfileSetup) {
			ProfileSetupView(profileManager: profileManager)
		}
	}
	
	// MARK: - Rank Universities
	
	private func rankUniversities() {
		rankedUniversities = recommendationEngine.rankUniversities(universities, profile: profileManager.profile)
	}
	
	// MARK: - University Card
	
	private func universityCard(at index: Int) -> some View {
		let matchScore = rankedUniversities[index]
		let university = matchScore.university
		let isExpanded = expandedCards.contains(university.id)
		
		if let uniIndex = universities.firstIndex(where: { $0.id == university.id }) {
			return AnyView(
				ZStack {
					// University Image with gradient overlay
					if let uiImage = UIImage(named: university.imageName) {
						Image(uiImage: uiImage)
							.resizable()
							.scaledToFill() // same as aspectRatio(.fill)
							.frame(
								width: UIScreen.main.bounds.width,
								height: UIScreen.main.bounds.height
							)
							.clipped() // crops anything outside the frame
							.ignoresSafeArea()
							.overlay(
								LinearGradient(
									colors: [
										.clear,
										.clear,
										.black.opacity(0.3),
										.black.opacity(0.7)
									],
									startPoint: .top,
									endPoint: .bottom
								)
							)
					}
					
					// University info (bottom)
					HStack {
						VStack {
							Spacer()
							
							VStack(alignment: .leading, spacing: 12) {
								// Match score badge
								HStack(spacing: 8) {
									HStack(spacing: 4) {
										Image(systemName: "sparkles")
											.font(.system(size: 14))
										Text("\(Int(matchScore.overallScore * 100))% Match")
											.font(.system(size: 15, weight: .bold))
									}
									.foregroundColor(.white)
									.padding(.horizontal, 12)
									.padding(.vertical, 6)
									.background(
										Capsule()
											.fill(
												LinearGradient(
													colors: [Color.Accent, Color.Primary],
													startPoint: .leading,
													endPoint: .trailing
												)
											)
											.shadow(color: Color.Accent.opacity(0.4), radius: 8, x: 0, y: 4)
									)
									
									// Category badge (Safety/Target/Reach)
									let category = recommendationEngine.classifyUniversity(matchScore, profile: profileManager.profile)
									Text(category)
										.font(.system(size: 15, weight: .bold))
										.foregroundColor(.white)
										.padding(.horizontal, 10)
										.padding(.vertical, 7)
										.background(
											Capsule()
												.fill(categoryColor(category).opacity(0.9))
										)
								}
								
								// Name and location
								VStack(alignment: .leading, spacing: 6) {
									Text(university.name)
										.font(.system(size: 34, weight: .bold, design: .rounded))
										.foregroundColor(.white)
										.lineLimit(2)
									
									HStack(spacing: 6) {
										Image(systemName: "mappin.circle.fill")
											.font(.system(size: 14))
										Text(university.location)
											.font(.system(size: 16, weight: .semibold))
									}
									.foregroundColor(.white.opacity(0.95))
									
									// Tap hint - shows when card is NOT expanded
									if !isExpanded {
										HStack(spacing: 4) {
											Text("Tap")
												.font(.system(size: 12, weight: .bold))
												.foregroundColor(Color.Accent)
											+ Text(" to learn more")
												.font(.system(size: 12, weight: .medium))
												.foregroundColor(.white.opacity(0.6))
										}
									}
								}
								
								// Expanded content
								if isExpanded {
									VStack(alignment: .leading, spacing: 12) {
										Divider()
											.background(Color.white.opacity(0.3))
											.padding(.vertical, 8)
										
										// Reasons for match
										VStack(alignment: .leading, spacing: 8) {
											Text("Why this match:")
												.font(.system(size: 16, weight: .bold))
												.foregroundColor(.white)
											
											ForEach(matchScore.reasonsForMatch.prefix(3), id: \.self) { reason in
												HStack(spacing: 8) {
													Image(systemName: "checkmark.circle.fill")
														.foregroundColor(.green)
														.font(.system(size: 14))
													Text(reason)
														.font(.system(size: 14, weight: .medium))
														.foregroundColor(.white.opacity(0.9))
												}
											}
										}
										
										// Considerations
										if !matchScore.reasonsAgainst.isEmpty {
											VStack(alignment: .leading, spacing: 8) {
												Text("Consider:")
													.font(.system(size: 16, weight: .bold))
													.foregroundColor(.white)
												
												ForEach(matchScore.reasonsAgainst.prefix(2), id: \.self) { reason in
													HStack(spacing: 8) {
														Image(systemName: "exclamationmark.circle.fill")
															.foregroundColor(.orange)
															.font(.system(size: 14))
														Text(reason)
															.font(.system(size: 14, weight: .medium))
															.foregroundColor(.white.opacity(0.9))
													}
												}
											}
										}
										
										// "View Details" button
										Button {
											selectedUniversity = university
											withAnimation(.spring()) {
												showMoreInfo = true
											}
										} label: {
											HStack {
												Image(systemName: "info.circle.fill")
												Text("View Full Details")
													.font(.system(size: 15, weight: .semibold))
											}
											.foregroundColor(.white)
											.frame(maxWidth: .infinity)
											.padding(.vertical, 12)
											.background(
												LinearGradient(
													colors: [Color.Accent, Color.Primary],
													startPoint: .leading,
													endPoint: .trailing
												)
											)
											.cornerRadius(12)
										}
										.padding(.top, 8)
									}
									.transition(.opacity.combined(with: .move(edge: .top)))
								}
								
								// Stats row
								HStack(spacing: 16) {
									// Rating
									HStack(spacing: 4) {
										Button(
											action: {
												selectedUniversity = university
												withAnimation(.spring()) {
													showReviews = true
												}
											},
											label: {
												HStack(spacing: 4) {
													Image(systemName: "star.fill")
														.font(.system(size: 14))
														.foregroundColor(.yellow)
													Text(String(format: "%.1f", university.overallRating))
														.font(.system(size: 15, weight: .semibold))
														.foregroundColor(.white)
													Image(systemName: "chevron.right")
														.font(.system(size: 12, weight: .semibold))
														.foregroundColor(.white.opacity(0.6))
												}
											}
										)
									}
									.padding(.horizontal, 12)
									.padding(.vertical, 6)
									.background(
										Capsule()
											.fill(.ultraThinMaterial)
									)
									
									// Subtitle
									Text(university.subtitle)
										.font(.system(size: 14, weight: .medium))
										.foregroundColor(.white.opacity(0.9))
										.padding(.horizontal, 12)
										.padding(.vertical, 6)
										.background(
											Capsule()
												.fill(.ultraThinMaterial)
										)
									
									Spacer()
								}
							}
							.padding(.horizontal, 24)
							.padding(.vertical, 24)
							.padding(.bottom, 80)
						}
						
						VStack(spacing: 12) {
							// Favorite button
							actionButton(
								icon: universities[uniIndex].isFavorite ? "heart.fill" : "heart",
								color: universities[uniIndex].isFavorite ? .red : Color.Accent,
								isActive: universities[uniIndex].isFavorite
							) {
								withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
									universities[uniIndex].isFavorite.toggle()
								}
							}
							
							// Add button
							actionButton(
								icon: universities[uniIndex].isSelected ? "checkmark.circle.fill" : "plus.circle",
								color: Color.Accent,
								isActive: universities[uniIndex].isSelected
							) {
								withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
									universities[uniIndex].isSelected.toggle()
								}
							}
						}
						.padding(.trailing, 20)
						.padding(.top, 500)
						.frame(width: 60)
					}
					.onTapGesture {
						withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
							if expandedCards.contains(university.id) {
								expandedCards.remove(university.id)
							} else {
								expandedCards.insert(university.id)
							}
						}
					}
					.background(isExpanded ? Color.black.opacity(0.6) : Color.clear)
				}
				.clipShape(RoundedRectangle(cornerRadius: 24))
				.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
				.containerRelativeFrame(.vertical)
				.scrollTargetLayout()
			)
		}
		
		return AnyView(EmptyView())
	}
	
	// MARK: - Action Button Component
	
	private func actionButton(icon: String, color: Color, isActive: Bool, action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Image(systemName: icon)
				.font(.system(size: 22, weight: .semibold))
				.foregroundStyle(isActive ? color : .white)
				.frame(width: 50, height: 50)
				.background(
					Circle()
						.fill(.ultraThinMaterial)
						.overlay(
							Circle()
								.stroke(isActive ? color : Color.white.opacity(0.3), lineWidth: 2)
						)
						.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
				)
		}
		.scaleEffect(isActive ? 1.05 : 1.0)
		.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)
	}
	
	private func categoryColor(_ category: String) -> Color {
		switch category {
		case "Safety":
			return .green
		case "Target":
			return .blue
		case "Reach":
			return .orange
		default:
			return .gray
		}
	}
}

// MARK: - More Info Bottom Sheet

@available(iOS 26.0, *)
struct MoreInfoSheet: View {
	let university: University
	@Binding var showMoreInfo: Bool
	
	var body: some View {
		VStack(spacing: 0) {
			Spacer()
			
			VStack(spacing: 0) {
				// Drag indicator
				Capsule()
					.fill(Color.gray.opacity(0.5))
					.frame(width: 40, height: 5)
					.padding(.top, 12)
					.padding(.bottom, 8)
				
				// Close button
				HStack {
					Spacer()
					Button {
						withAnimation(.spring()) {
							showMoreInfo = false
						}
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.system(size: 28))
							.foregroundColor(.gray)
					}
					.padding(.trailing, 20)
				}
				.padding(.bottom, 8)
				
				// Scrollable content
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						// University name header
						Text(university.name)
							.font(.system(size: 28, weight: .bold, design: .rounded))
							.foregroundStyle(
								LinearGradient(
									colors: [Color.Accent, Color.Primary],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
						
						// Description
						VStack(alignment: .leading, spacing: 8) {
							Text("University Description")
								.font(.system(size: 18, weight: .bold))
								.foregroundColor(.primary)
							
							Text(university.description)
								.font(.system(size: 15, weight: .regular))
								.foregroundColor(.secondary)
								.fixedSize(horizontal: false, vertical: true)
						}
						
						Divider()
						
						// Website
						VStack(alignment: .leading, spacing: 8) {
							Text("University Website")
								.font(.system(size: 18, weight: .bold))
								.foregroundColor(.primary)
							
							Link(university.websiteURL, destination: URL(string: university.websiteURL.hasPrefix("http") ? university.websiteURL : "https://\(university.websiteURL)")!)
								.font(.system(size: 15, weight: .medium))
								.foregroundColor(Color.Accent)
						}
						
						Divider()
						
						// Scholarships
						if !university.scholarshipsAvailable.isEmpty {
							VStack(alignment: .leading, spacing: 16) {
								Text("Scholarships Available")
									.font(.system(size: 18, weight: .bold))
									.foregroundColor(.primary)
								
								ForEach(Array(university.scholarshipsAvailable.enumerated()), id: \.element.id) { index, scholarship in
									VStack(alignment: .leading, spacing: 10) {
										// Scholarship name
										Text("\(index + 1). \(scholarship.name)")
											.font(.system(size: 16, weight: .semibold))
											.foregroundColor(.primary)
										
										// Deadline
										if let deadline = scholarship.deadline {
											HStack(spacing: 6) {
												Image(systemName: "calendar")
													.font(.system(size: 14))
													.foregroundColor(Color.Accent)
												Text("Deadline: \(formatDate(deadline))")
													.font(.system(size: 14, weight: .medium))
													.foregroundColor(.secondary)
											}
										}
										
										// Amount
										HStack(spacing: 6) {
											Image(systemName: "dollarsign.circle.fill")
												.font(.system(size: 14))
												.foregroundColor(.green)
											Text("Amount: $\(formatCurrency(scholarship.amount))")
												.font(.system(size: 14, weight: .medium))
												.foregroundColor(.secondary)
										}
										
										// Requirements
										VStack(alignment: .leading, spacing: 4) {
											Text("Requirements:")
												.font(.system(size: 14, weight: .semibold))
												.foregroundColor(.primary)
											Text(scholarship.requirements)
												.font(.system(size: 14, weight: .regular))
												.foregroundColor(.secondary)
												.fixedSize(horizontal: false, vertical: true)
										}
										
										if index < university.scholarshipsAvailable.count - 1 {
											Divider()
												.padding(.top, 8)
										}
									}
									.padding(.vertical, 4)
								}
							}
						}
						
						Spacer()
							.frame(height: 30)
					}
					.padding(.horizontal, 24)
					.padding(.vertical, 16)
					.padding(.bottom, 40)
				}
			}
			.frame(maxWidth: UIScreen.main.bounds.width)
			.frame(height: UIScreen.main.bounds.height * 0.75)
			.background(Color(uiColor: .systemBackground))
			.cornerRadius(20, corners: [.topLeft, .topRight])
		}
		.ignoresSafeArea()
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

// MARK: - Reviews View

struct ReviewsView: View {
	
	let university: University
	@Binding var showReviews: Bool
	
	@State private var Height = UIScreen.main.bounds.height * 0.7
	
	private func formatDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd, yyyy"
		return formatter.string(from: date)
	}
	
	var body: some View {
		VStack(spacing: 0) {
			Spacer()
			
			VStack(spacing: 0) {
				// Drag indicator
				Capsule()
					.fill(Color.gray.opacity(0.5))
					.frame(width: 40, height: 5)
					.padding(.top, 12)
					.padding(.bottom, 8)
				
				// Close button
				HStack {
					Spacer()
					Button {
						withAnimation(.spring()) {
							showReviews = false
							Height = 0
						}
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.system(size: 28))
							.foregroundColor(.gray)
					}
					.padding(.trailing, 20)
				}
				.padding(.bottom, 8)
				
				// Scrollable content
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						// University name header
						
						Text("Reviews for: " + university.name)
							.font(.system(size: 28, weight: .bold, design: .rounded))
							.foregroundStyle(
								LinearGradient(
									colors: [Color.Accent, Color.Primary],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
						
						ForEach(Array(university.reviews.enumerated()), id: \.element.id) { index, review in
							VStack(alignment: .leading, spacing: 12) {
								// Header row
								HStack {
									VStack(alignment: .leading, spacing: 4) {
										HStack(spacing: 8) {
											Text(review.studentName ?? "Anonymous")
												.font(.system(size: 16, weight: .bold))
											
											// Star rating inline
											HStack(spacing: 2) {
												ForEach(0..<review.stars, id: \.self) { _ in
													Image(systemName: "star.fill")
														.font(.system(size: 11))
														.foregroundColor(.yellow)
												}
											}
										}
										
										if let major = review.major, !major.isEmpty {
											Text(major + (review.graduationYear != nil ? " • '\(String(review.graduationYear! % 100))" : ""))
												.font(.system(size: 13, weight: .medium))
												.foregroundColor(.secondary)
										}
									}
									
									Spacer()
									
									Text(review.date, style: .date)
										.font(.system(size: 11, weight: .medium))
										.foregroundColor(.secondary)
								}
								
								// Summary
								Text(review.summary)
									.font(.system(size: 14, weight: .medium))
									.foregroundColor(.primary)
									.lineSpacing(3)
								
								// Pros & Cons in columns
								HStack(alignment: .top, spacing: 16) {
									if !review.pros.isEmpty {
										VStack(alignment: .leading, spacing: 6) {
											HStack(spacing: 4) {
												Image(systemName: "checkmark.circle.fill")
													.font(.system(size: 12))
													.foregroundColor(.green)
												Text("Pros")
													.font(.system(size: 12, weight: .bold))
													.foregroundColor(.green)
											}
											
											ForEach(review.pros.prefix(2), id: \.self) { pro in
												Text("• " + pro)
													.font(.system(size: 12, weight: .medium))
													.foregroundColor(.secondary)
											}
										}
										.frame(maxWidth: .infinity, alignment: .leading)
									}
									
									if !review.cons.isEmpty {
										VStack(alignment: .leading, spacing: 6) {
											HStack(spacing: 4) {
												Image(systemName: "xmark.circle.fill")
													.font(.system(size: 12))
													.foregroundColor(.orange)
												Text("Cons")
													.font(.system(size: 12, weight: .bold))
													.foregroundColor(.orange)
											}
											
											ForEach(review.cons.prefix(2), id: \.self) { con in
												Text("• " + con)
													.font(.system(size: 12, weight: .medium))
													.foregroundColor(.secondary)
											}
										}
										.frame(maxWidth: .infinity, alignment: .leading)
									}
								}
							}
							.padding(16)
							.background(
								RoundedRectangle(cornerRadius: 14)
									.fill(.ultraThinMaterial)
							)
						}
						
						
						Spacer()
							.frame(height: 30)
					}
					.padding(.horizontal, 24)
					.padding(.vertical, 16)
					.padding(.bottom, 40)
				}
			}
			.frame(maxWidth: UIScreen.main.bounds.width)
			.frame(height: Height)
			.background(Color(uiColor: .systemBackground))
			.cornerRadius(20, corners: [.topLeft, .topRight])
		}
		.ignoresSafeArea()
	}
}

// MARK: - Corner Radius Helper

extension View {
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}

struct RoundedCorner: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius)
		)
		return Path(path.cgPath)
	}
}

@available(iOS 26.0, *)
struct TabView_: View {
	
	@State private var selectedTab = 0
	@State private var universities = sampleUniversities
	@StateObject private var profileManager = ProfileManager()
	@StateObject private var tourManager = AppTourManager()
	@State private var showProfileSetup = false
	
	var body: some View {
		ZStack {
			TabView(selection: $selectedTab) {
				ContentView(universities: $universities, profileManager: profileManager)
					.tabItem {
						Label("Discover", systemImage: "sparkles")
					}
					.tag(0)
				
				MatchesView(universities: $universities, profileManager: profileManager)
					.tabItem {
						Label("Matches", systemImage: "heart.fill")
					}
					.tag(1)
				
				SchoolInfo()
					.tabItem {
						Label("Documents", systemImage: "doc.fill")
					}
					.tag(2)
				
				AccountView(
					profileManager: profileManager,
					tourManager: tourManager,
					selectedTab: $selectedTab
				)
					.tabItem {
						Label("Account", systemImage: "person.circle.fill")
					}
					.tag(3)
			}
			.tint(Color.Accent)
		}
		.appTour(tourManager)
		.onAppear {
			if !profileManager.hasCompletedProfile {
				showProfileSetup = true
			} else if !tourManager.hasCompletedTour {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					tourManager.startTour()
				}
			}
		}
		.sheet(isPresented: $showProfileSetup) {
			ProfileSetupView(profileManager: profileManager)
				.onDisappear {
					if !tourManager.hasCompletedTour {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							tourManager.startTour()
						}
					}
				}
		}
	}
}

@available(iOS 26.0, *)
#Preview {
	ContentView(universities: .constant(sampleUniversities), profileManager: ProfileManager())
}
