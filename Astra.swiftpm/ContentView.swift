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
	
	@Binding var university: [University]
	
	@State private var expandedCards: Set<UUID> = []
	
	var body: some View {
		ZStack {
			// Background gradient - matching upload page
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
			
			// University cards (full screen scrolling)
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 0) {
					ForEach(university.indices, id: \.self) { index in
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
		}
	}
	
	// MARK: - Header View
	
	private var headerView: some View {
		VStack(spacing: 8) {
			HStack {
				VStack(alignment: .leading, spacing: 4) {
					Text("Discover")
						.font(.system(size: 38, weight: .bold, design: .rounded))
						.foregroundStyle(
							LinearGradient(
								colors: [Color.Accent, Color.Primary],
								startPoint: .leading,
								endPoint: .trailing
							)
						)
					
					Text("Find your perfect university match")
						.font(.system(size: 16, weight: .medium))
						.foregroundColor(.secondary)
				}
				
				Spacer()
			}
			.padding(.horizontal, 24)
			.padding(.top, -5)
			.padding(.bottom, 8)
		}
		.background(
			LinearGradient(
				colors: colorScheme == .dark ? [
					Color.black,
					Color.black.opacity(0.8),
					Color.clear
				] : [
					Color.white,
					Color.white.opacity(0.8),
					Color.clear
				],
				startPoint: .top,
				endPoint: .bottom
			)
		)
	}
	
	// MARK: - University Card
	
	private func universityCard(at index: Int) -> some View {
		let isExpanded = expandedCards.contains(university[index].id)
		
		return ZStack {
			// University Image with gradient overlay
			if let uiImage = UIImage(named: university[index].imageName) {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(
						maxWidth: .infinity,
						maxHeight: UIScreen.main.bounds.height
					)
					.clipped()
					.overlay(
						// Subtle dark overlay for better text contrast
						LinearGradient(
							colors: [
								Color.clear,
								Color.clear,
								Color.black.opacity(0.3),
								Color.black.opacity(0.7)
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
						// Name and location
						VStack(alignment: .leading, spacing: 6) {
							Text(university[index].name)
								.font(.system(size: 34, weight: .bold, design: .rounded))
								.foregroundColor(.white)
								.lineLimit(2)
							
							HStack(spacing: 6) {
								Image(systemName: "mappin.circle.fill")
									.font(.system(size: 14))
								Text(university[index].location)
									.font(.system(size: 16, weight: .semibold))
							}
							.foregroundColor(.white.opacity(0.95))
							
							HStack {
								Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
											.font(.system(size: 18, weight: .semibold))
											.foregroundColor(.white.opacity(0.7))
								
								Text(isExpanded ? "Tap again to close" : "Tap for more info.")
									.foregroundColor(.white.opacity(0.7))
							}
						}
						
						// Show extra content when expanded
						if isExpanded {
							Text(university[index].description)
								.font(.system(size: 16))
								.foregroundColor(.white)
								.transition(.opacity.combined(with: .move(edge: .top)))
							
							Text(university[index].websiteURL)
								.font(.system(size: 16))
								.foregroundColor(.white)
								.transition(.opacity.combined(with: .move(edge: .top)))
						}
						
						// Stats row
						HStack(spacing: 16) {
							// Rating
							HStack(spacing: 4) {
								Image(systemName: "star.fill")
									.font(.system(size: 14))
									.foregroundColor(.yellow)
								Text(String(format: "%.1f", university[index].overallRating))
									.font(.system(size: 15, weight: .semibold))
									.foregroundColor(.white)
							}
							.padding(.horizontal, 12)
							.padding(.vertical, 6)
							.background(
								Capsule()
									.fill(.ultraThinMaterial)
							)
							
							// Subtitle
							Text(university[index].subtitle)
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
						icon: university[index].isFavorite ? "heart.fill" : "heart",
						color: university[index].isFavorite ? .red : Color.Accent,
						isActive: university[index].isFavorite
					) {
						withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
							university[index].isFavorite.toggle()
						}
					}
					
					// Add button
					actionButton(
						icon: university[index].isSelected ? "checkmark.circle.fill" : "plus.circle",
						color: Color.Accent,
						isActive: university[index].isSelected
					) {
						withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
							university[index].isSelected.toggle()
						}
					}
				}
				.padding(.trailing, 20)
				.padding(.top, 500)
				.frame(width: 60)
			}
			.onTapGesture {
				withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
					if expandedCards.contains(university[index].id) {
						expandedCards.remove(university[index].id)
					} else {
						expandedCards.insert(university[index].id)
					}
				}
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 24))
		.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
		.containerRelativeFrame(.vertical)
		.scrollTargetLayout()
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
}

// MARK: - Tab View

@available(iOS 26.0, *)
struct TabView_: View {
	
	@State private var selectedTab = 0
	@State private var universities = sampleUniversities  // Add this state here
	
	var body: some View {
		TabView(selection: $selectedTab) {
			ContentView(university: $universities)  // Pass binding
				.tabItem {
					Label("Discover", systemImage: "sparkles")
				}
				.tag(0)
			
			MatchesView(universities: $universities)  // Pass binding
				.tabItem {
					Label("Matches", systemImage: "heart.fill")
				}
				.tag(1)
			
			SchoolInfo()
				.tabItem {
					Label("Documents", systemImage: "doc.fill")
				}
				.tag(2)
			
//			SearchView()
//				.tabItem {
//					Label("Search", systemImage: "magnifyingglass.circle.fill")
//				}
//				.tag(2)
		}
		.tint(Color.Accent)
	}
}

@available(iOS 26.0, *)
#Preview {
	TabView_()
}
