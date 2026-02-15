import SwiftUI
import UniformTypeIdentifiers

// MARK: - Document Model

struct UserDocument: Identifiable, Codable {
	let id: UUID
	let type: DocumentType
	let fileName: String
	let fileSize: Int64
	let uploadDate: Date
	let fileData: Data?
	
	var fileSizeFormatted: String {
		let formatter = ByteCountFormatter()
		formatter.allowedUnits = [.useKB, .useMB]
		formatter.countStyle = .file
		return formatter.string(fromByteCount: fileSize)
	}
	
	var dateFormatted: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		return formatter.string(from: uploadDate)
	}
}

enum DocumentType: String, Codable, CaseIterable {
	case resume = "Resume/CV"
	case transcript = "Transcript"
	case diploma = "Diploma"
	case recommendation = "Recommendation Letter"
	case essay = "Personal Essay"
	case certificate = "Certificate"
	case other = "Other"
	
	var icon: String {
		switch self {
		case .resume: return "doc.text.fill"
		case .transcript: return "chart.bar.doc.horizontal.fill"
		case .diploma: return "graduationcap.fill"
		case .recommendation: return "envelope.fill"
		case .essay: return "doc.plaintext.fill"
		case .certificate: return "rosette"
		case .other: return "folder.fill"
		}
	}
	
	var color: Color {
		switch self {
		case .resume: return .blue
		case .transcript: return .purple
		case .diploma: return .green
		case .recommendation: return .orange
		case .essay: return .pink
		case .certificate: return .yellow
		case .other: return .gray
		}
	}
}

// MARK: - Main Document Upload View

struct SchoolInfo: View {
	@State private var documents: [UserDocument] = []
	@State private var showingDocumentPicker = false
	@State private var selectedDocumentType: DocumentType = .resume
	@State private var showingTypeSelector = false
	@State private var isDragging = false
	@State private var showingDeleteConfirmation = false
	@State private var documentToDelete: UserDocument?
	@State private var profileCompleteness: Double = 0.0
	
	@Environment(\.colorScheme) var colorScheme
	
	// Colors
	private let accentColor = Color(red: 0.2, green: 0.6, blue: 0.9)
	private let backgroundColor = Color(UIColor.systemBackground)
	private let cardColor = Color(UIColor.secondarySystemBackground)
	
	var body: some View {
		NavigationView {
			ZStack {
				// Background gradient
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
						
						// Profile Completeness
						profileCompletenessSection
						
						// Upload Area
						uploadDropZone
						
						// Document Type Grid
						documentTypeGrid
						
						// Uploaded Documents List
						if !documents.isEmpty {
							uploadedDocumentsSection
						}
						
						Spacer(minLength: 100)
					}
					.padding()
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.sheet(isPresented: $showingDocumentPicker) {
				DocumentPickerView(documentType: selectedDocumentType) { document in
					addDocument(document)
				}
			}
			.alert("Delete Document?", isPresented: $showingDeleteConfirmation) {
				Button("Cancel", role: .cancel) {}
				Button("Delete", role: .destructive) {
					if let doc = documentToDelete {
						deleteDocument(doc)
					}
				}
			} message: {
				Text("This action cannot be undone.")
			}
		}
		.onAppear {
			calculateProfileCompleteness()
		}
	}
	
	// MARK: - Header Section
	
	private var headerSection: some View {
		VStack(spacing: 8) {
			Image(systemName: "doc.badge.plus")
				.font(.system(size: 50, weight: .light))
				.foregroundStyle(
					LinearGradient(
						colors: [accentColor, accentColor.opacity(0.6)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
			
			Text("Your Application Documents")
				.font(.system(size: 32, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
			
			Text("Build your profile to match with universities and scholarships")
				.font(.system(size: 16, weight: .regular))
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
		}
		.padding(.top, 20)
	}
	
	// MARK: - Profile Completeness
	
	private var profileCompletenessSection: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack {
				Text("Profile Strength")
					.font(.system(size: 18, weight: .semibold))
				
				Spacer()
				
				Text("\(Int(profileCompleteness * 100))%")
					.font(.system(size: 16, weight: .bold))
					.foregroundColor(accentColor)
			}
			
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 12)
					.fill(cardColor)
					.frame(height: 12)
				
				RoundedRectangle(cornerRadius: 12)
					.fill(
						LinearGradient(
							colors: profileCompleteness < 0.3 ? [.red, .orange] :
									 profileCompleteness < 0.7 ? [.orange, .yellow] :
									 [.green, accentColor],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.frame(width: max(0, UIScreen.main.bounds.width - 64) * profileCompleteness, height: 12)
					.animation(.spring(response: 0.6, dampingFraction: 0.7), value: profileCompleteness)
			}
			
			Text(profileCompletenessMessage)
				.font(.system(size: 14))
				.foregroundColor(.secondary)
		}
		.padding(20)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(.ultraThinMaterial)
				.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
		)
	}
	
	private var profileCompletenessMessage: String {
		if profileCompleteness < 0.3 {
			return "Add more documents to increase your chances"
		} else if profileCompleteness < 0.7 {
			return "Good progress! Keep adding documents"
		} else {
			return "Excellent! Your profile is looking strong"
		}
	}
	
	// MARK: - Upload Drop Zone
	
	private var uploadDropZone: some View {
		VStack(spacing: 16) {
			Image(systemName: isDragging ? "arrow.down.doc.fill" : "plus.circle.fill")
				.font(.system(size: 60, weight: .light))
				.foregroundColor(accentColor)
				.scaleEffect(isDragging ? 1.1 : 1.0)
				.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
			
			Text(isDragging ? "Drop your document here" : "Upload Documents")
				.font(.system(size: 22, weight: .semibold))
			
			Text("PDF, DOC, DOCX, or Images (Max 10MB)")
				.font(.system(size: 14))
				.foregroundColor(.secondary)
			
			Button(action: {
				showingTypeSelector = true
			}) {
				HStack {
					Image(systemName: "plus")
					Text("Choose File")
				}
				.font(.system(size: 16, weight: .semibold))
				.foregroundColor(.white)
				.padding(.horizontal, 30)
				.padding(.vertical, 14)
				.background(
					LinearGradient(
						colors: [accentColor, accentColor.opacity(0.8)],
						startPoint: .leading,
						endPoint: .trailing
					)
				)
				.cornerRadius(12)
				.shadow(color: accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
			}
		}
		.frame(maxWidth: .infinity)
		.padding(40)
		.background(
			RoundedRectangle(cornerRadius: 24)
				.strokeBorder(
					isDragging ? accentColor : Color.gray.opacity(0.3),
					style: StrokeStyle(lineWidth: 2, dash: [10])
				)
				.background(
					RoundedRectangle(cornerRadius: 24)
						.fill(.ultraThinMaterial)
				)
		)
		.confirmationDialog("Select Document Type", isPresented: $showingTypeSelector) {
			ForEach(DocumentType.allCases, id: \.self) { type in
				Button(type.rawValue) {
					selectedDocumentType = type
					showingDocumentPicker = true
				}
			}
			Button("Cancel", role: .cancel) {}
		}
	}
	
	// MARK: - Document Type Grid
	
	private var documentTypeGrid: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text("Quick Upload")
				.font(.system(size: 20, weight: .semibold))
				.padding(.horizontal, 4)
			
			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible()),
				GridItem(.flexible())
			], spacing: 16) {
				ForEach(DocumentType.allCases, id: \.self) { type in
					DocumentTypeCard(
						type: type,
						count: documents.filter { $0.type == type }.count
					) {
						selectedDocumentType = type
						showingDocumentPicker = true
					}
				}
			}
		}
	}
	
	// MARK: - Uploaded Documents Section
	
	private var uploadedDocumentsSection: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack {
				Text("Uploaded Documents")
					.font(.system(size: 20, weight: .semibold))
				
				Spacer()
				
				Text("\(documents.count)")
					.font(.system(size: 16, weight: .bold))
					.foregroundColor(.white)
					.padding(.horizontal, 12)
					.padding(.vertical, 6)
					.background(accentColor)
					.cornerRadius(20)
			}
			.padding(.horizontal, 4)
			
			ForEach(documents) { document in
				DocumentRow(document: document) {
					documentToDelete = document
					showingDeleteConfirmation = true
				}
			}
		}
	}
	
	// MARK: - Helper Functions
	
	private func addDocument(_ document: UserDocument) {
		withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
			documents.append(document)
			calculateProfileCompleteness()
		}
	}
	
	private func deleteDocument(_ document: UserDocument) {
		withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
			documents.removeAll { $0.id == document.id }
			calculateProfileCompleteness()
		}
	}
	
	private func calculateProfileCompleteness() {
		// Calculate based on document types present
		let essentialTypes: Set<DocumentType> = [.resume, .transcript, .diploma]
		let presentEssentialTypes = Set(documents.map { $0.type }).intersection(essentialTypes)
		
		let essentialScore = Double(presentEssentialTypes.count) / Double(essentialTypes.count) * 0.7
		let additionalScore = min(Double(documents.count) / 10.0, 1.0) * 0.3
		
		profileCompleteness = min(essentialScore + additionalScore, 1.0)
	}
}

// MARK: - Document Type Card

struct DocumentTypeCard: View {
	let type: DocumentType
	let count: Int
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(spacing: 12) {
				ZStack(alignment: .topTrailing) {
					Image(systemName: type.icon)
						.font(.system(size: 28))
						.foregroundColor(type.color)
					
					if count > 0 {
						Text("\(count)")
							.font(.system(size: 10, weight: .bold))
							.foregroundColor(.white)
							.padding(4)
							.background(Circle().fill(type.color))
							.offset(x: 8, y: -8)
					}
				}
				
				Text(type.rawValue)
					.font(.system(size: 12, weight: .medium))
					.multilineTextAlignment(.center)
					.foregroundColor(.primary)
					.lineLimit(2)
					.minimumScaleFactor(0.8)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 20)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(.ultraThinMaterial)
					.shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
			)
		}
		.buttonStyle(ScaleButtonStyle())
	}
}

// MARK: - Document Row

struct DocumentRow: View {
	let document: UserDocument
	let onDelete: () -> Void
	
	@State private var isExpanded = false
	
	var body: some View {
		VStack(spacing: 0) {
			Button(action: {
				withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
					isExpanded.toggle()
				}
			}) {
				HStack(spacing: 16) {
					// Icon
					ZStack {
						Circle()
							.fill(document.type.color.opacity(0.2))
							.frame(width: 50, height: 50)
						
						Image(systemName: document.type.icon)
							.font(.system(size: 22))
							.foregroundColor(document.type.color)
					}
					
					// Info
					VStack(alignment: .leading, spacing: 4) {
						Text(document.fileName)
							.font(.system(size: 16, weight: .semibold))
							.lineLimit(1)
						
						HStack(spacing: 8) {
							Text(document.type.rawValue)
								.font(.system(size: 13))
								.foregroundColor(.secondary)
							
							Circle()
								.fill(Color.secondary)
								.frame(width: 3, height: 3)
							
							Text(document.fileSizeFormatted)
								.font(.system(size: 13))
								.foregroundColor(.secondary)
						}
					}
					
					Spacer()
					
					// Expand indicator
					Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
						.font(.system(size: 14, weight: .semibold))
						.foregroundColor(.secondary)
						.rotationEffect(.degrees(isExpanded ? 180 : 0))
				}
				.padding(16)
			}
			.buttonStyle(PlainButtonStyle())
			
			// Expanded content
			if isExpanded {
				VStack(spacing: 12) {
					Divider()
					
					HStack {
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Image(systemName: "calendar")
									.font(.system(size: 12))
									.foregroundColor(.secondary)
								Text("Uploaded: \(document.dateFormatted)")
									.font(.system(size: 13))
									.foregroundColor(.secondary)
							}
							
							HStack {
								Image(systemName: "checkmark.circle.fill")
									.font(.system(size: 12))
									.foregroundColor(.green)
								Text("Verified")
									.font(.system(size: 13))
									.foregroundColor(.secondary)
							}
						}
						
						Spacer()
						
						Button(action: onDelete) {
							HStack {
								Image(systemName: "trash")
								Text("Delete")
							}
							.font(.system(size: 14, weight: .medium))
							.foregroundColor(.red)
							.padding(.horizontal, 16)
							.padding(.vertical, 8)
							.background(
								RoundedRectangle(cornerRadius: 8)
									.fill(Color.red.opacity(0.1))
							)
						}
					}
					.padding(.horizontal, 16)
					.padding(.bottom, 12)
				}
				.transition(.opacity.combined(with: .move(edge: .top)))
			}
		}
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(.ultraThinMaterial)
				.shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
		)
	}
}

// MARK: - Document Picker (Simulated)

struct DocumentPickerView: View {
	let documentType: DocumentType
	let onDocumentSelected: (UserDocument) -> Void
	
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				Text("Select a \(documentType.rawValue)")
					.font(.system(size: 20, weight: .semibold))
				
				Text("In a real app, this would open the system document picker")
					.font(.system(size: 14))
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
					.padding()
				
				// Simulated document selection
				Button("Select Sample Document") {
					let sampleDocument = UserDocument(
						id: UUID(),
						type: documentType,
						fileName: "Sample_\(documentType.rawValue).pdf",
						fileSize: Int64.random(in: 100_000...5_000_000),
						uploadDate: Date(),
						fileData: nil
					)
					onDocumentSelected(sampleDocument)
					dismiss()
				}
				.font(.system(size: 16, weight: .semibold))
				.foregroundColor(.white)
				.padding(.horizontal, 30)
				.padding(.vertical, 14)
				.background(Color.blue)
				.cornerRadius(12)
				
				Spacer()
			}
			.padding()
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
		}
	}
}

// MARK: - Button Styles

struct ScaleButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
			.animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
	}
}

// MARK: - Preview

#Preview {
	SchoolInfo()
}
