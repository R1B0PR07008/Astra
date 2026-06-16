//
//  account.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import SwiftUI

@available(iOS 26.0, *)
struct AccountView: View {
	
	@ObservedObject var profileManager: ProfileManager
	@ObservedObject var tourManager: AppTourManager
	@Environment(\.colorScheme) var colorScheme
	
	@Binding var selectedTab: Int
	
	@State private var showProfileSetup = false
	
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
			
			ScrollView {
				VStack(spacing: 24) {
					// Header
					headerSection
					
					// Profile Summary
					profileSummarySection
					
					// Quick Actions
					quickActionsSection
					
					// Settings
					settingsSection
					
					// About
					aboutSection
					
					Spacer(minLength: 100)
				}
				.padding(.horizontal, 24)
				.padding(.top, 20)
			}
		}
		.sheet(isPresented: $showProfileSetup) {
			ProfileSetupView(profileManager: profileManager)
		}
	}
	
	// MARK: - Header
	
	private var headerSection: some View {
		VStack(spacing: 8) {
			// Profile icon
			ZStack {
				Circle()
					.fill(
						LinearGradient(
							colors: [Color.Accent.opacity(0.3), Color.Primary.opacity(0.2)],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.frame(width: 100, height: 100)
				
				Image(systemName: "person.fill")
					.font(.system(size: 50))
					.foregroundStyle(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
			}
			
			Text("Your Profile")
				.font(.system(size: 32, weight: .bold, design: .rounded))
				.foregroundStyle(
					LinearGradient(
						colors: [Color.Accent, Color.Primary],
						startPoint: .leading,
						endPoint: .trailing
					)
				)
			
			Text("Manage your preferences")
				.font(.system(size: 16, weight: .medium))
				.foregroundColor(.secondary)
		}
		.padding(.vertical, 20)
	}
	
	// MARK: - Profile Summary
	
	private var profileSummarySection: some View {
		VStack(spacing: 16) {
			SectionHeader(icon: "person.circle.fill", title: "Academic Profile")
			
			VStack(spacing: 12) {
				ProfileStatRow(icon: "chart.line.uptrend.xyaxis", label: "GPA", value: String(format: "%.2f", profileManager.profile.gpa))
				ProfileStatRow(icon: "doc.text.fill", label: "SAT", value: "\(profileManager.profile.sat)")
				ProfileStatRow(icon: "doc.text.fill", label: "ACT", value: "\(profileManager.profile.act)")
				
				if !profileManager.profile.interestedPrograms.isEmpty {
					VStack(alignment: .leading, spacing: 8) {
						HStack {
							Image(systemName: "book.fill")
								.foregroundColor(Color.Accent)
							Text("Interested Programs")
								.font(.system(size: 14, weight: .semibold))
						}
						
						FlowLayout(spacing: 8) {
							ForEach(profileManager.profile.interestedPrograms, id: \.self) { program in
								Text(program)
									.font(.system(size: 13, weight: .medium))
									.padding(.horizontal, 12)
									.padding(.vertical, 6)
									.background(
										Capsule()
											.fill(Color.Accent.opacity(0.15))
									)
									.foregroundColor(Color.Accent)
							}
						}
					}
					.padding(.top, 8)
				}
			}
			.padding(20)
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(.ultraThinMaterial)
			)
		}
	}
	
	// MARK: - Quick Actions
	
	private var quickActionsSection: some View {
			VStack(spacing: 16) {
				SectionHeader(icon: "bolt.fill", title: "Quick Actions")
				
				VStack(spacing: 12) {
					ActionButton(
						icon: "pencil.circle.fill",
						title: "Edit Profile",
						subtitle: "Update your information",
						color: Color.Accent
					) {
						showProfileSetup = true
					}
					
					ActionButton(
						icon: "arrow.clockwise.circle.fill",
						title: "Replay Tour",
						subtitle: "See the app tour again",
						color: Color.Primary
					) {
						// Navigate to Discover tab
						selectedTab = 0
						// Start tour after a short delay
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							tourManager.resetTour()
							tourManager.startTour()
						}
					}
				}
			}
		}
	
	// MARK: - Settings
	
	private var settingsSection: some View {
		VStack(spacing: 16) {
			SectionHeader(icon: "gearshape.fill", title: "Settings")
			
			VStack(spacing: 12) {
				SettingRow(
					icon: "dollarsign.circle.fill",
					title: "Budget",
					value: profileManager.profile.maxBudget != nil ? "$\(Int(profileManager.profile.maxBudget!))" : "Not set",
					color: .green
				)
				
				SettingRow(
					icon: "mappin.circle.fill",
					title: "Preferred Locations",
					value: profileManager.profile.preferredLocations.isEmpty ? "Any" : "\(profileManager.profile.preferredLocations.count) selected",
					color: .orange
				)
				
				SettingRow(
					icon: "building.2.fill",
					title: "Campus Size",
					value: profileManager.profile.campusSizePreference ?? "No preference",
					color: .purple
				)
			}
			.padding(20)
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(.ultraThinMaterial)
			)
		}
	}
	
	// MARK: - About
	
	private var aboutSection: some View {
		VStack(spacing: 16) {
			SectionHeader(icon: "info.circle.fill", title: "About")
			
			VStack(alignment: .leading, spacing: 16) {
				Text("Astra")
					.font(.system(size: 24, weight: .bold))
					.foregroundStyle(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
				
				Text("Built by Matias Riboldi for the Apple Swift Student Challenge 2026")
					.font(.system(size: 14, weight: .medium))
					.foregroundColor(.secondary)
					.lineSpacing(4)
				
				Divider()
					.padding(.vertical, 8)
				
				VStack(alignment: .leading, spacing: 8) {
					Text("Why I Built This")
						.font(.system(size: 16, weight: .bold))
					
					Text("As an 18-year-old about to finish high school, choosing a university felt overwhelming. There were so many options, and I didn't know which ones I could actually get into or afford. I built Astra to help students like me make this life-changing decision with confidence.")
						.font(.system(size: 14, weight: .medium))
						.foregroundColor(.secondary)
						.lineSpacing(4)
				}
				
				Text("Version 1.0")
					.font(.system(size: 12, weight: .medium))
					.foregroundColor(.secondary)
					.padding(.top, 8)
			}
			.padding(20)
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(.ultraThinMaterial)
			)
		}
	}
}

// MARK: - Supporting Views

struct SectionHeader: View {
	let icon: String
	let title: String
	
	var body: some View {
		HStack {
			Image(systemName: icon)
				.foregroundStyle(
					LinearGradient(
						colors: [Color.Accent, Color.Primary],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
			Text(title)
				.font(.system(size: 20, weight: .bold))
			Spacer()
		}
	}
}

struct ProfileStatRow: View {
	let icon: String
	let label: String
	let value: String
	
	var body: some View {
		HStack {
			Image(systemName: icon)
				.foregroundColor(Color.Accent)
				.frame(width: 24)
			
			Text(label)
				.font(.system(size: 15, weight: .medium))
			
			Spacer()
			
			Text(value)
				.font(.system(size: 15, weight: .bold))
				.foregroundColor(Color.Accent)
		}
	}
}

struct ActionButton: View {
	let icon: String
	let title: String
	let subtitle: String
	let color: Color
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack(spacing: 16) {
				Image(systemName: icon)
					.font(.system(size: 28))
					.foregroundColor(color)
					.frame(width: 50, height: 50)
					.background(
						Circle()
							.fill(color.opacity(0.15))
					)
				
				VStack(alignment: .leading, spacing: 4) {
					Text(title)
						.font(.system(size: 16, weight: .semibold))
						.foregroundColor(.primary)
					
					Text(subtitle)
						.font(.system(size: 13, weight: .medium))
						.foregroundColor(.secondary)
				}
				
				Spacer()
				
				Image(systemName: "chevron.right")
					.foregroundColor(.secondary)
			}
			.padding(16)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(.ultraThinMaterial)
			)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct SettingRow: View {
	let icon: String
	let title: String
	let value: String
	let color: Color
	
	var body: some View {
		HStack {
			Image(systemName: icon)
				.foregroundColor(color)
				.frame(width: 24)
			
			Text(title)
				.font(.system(size: 15, weight: .medium))
			
			Spacer()
			
			Text(value)
				.font(.system(size: 14, weight: .medium))
				.foregroundColor(.secondary)
		}
	}
}

//@available(iOS 26.0, *)
//#Preview {
//	AccountView(profileManager: ProfileManager(), tourManager: AppTourManager())
//}
