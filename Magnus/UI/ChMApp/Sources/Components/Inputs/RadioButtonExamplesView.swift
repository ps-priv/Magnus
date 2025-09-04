import SwiftUI

struct RadioButtonExamplesView: View {
    @State private var selectedMedicationType: MedicationType?
    @State private var selectedGender: Gender?
    @State private var selectedDiabetesType: DiabetesType?
    @State private var selectedTimeOfDay: TimeOfDay?
    @State private var selectedExperience: ExperienceLevel?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Radio Button Examples")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("NovoNordiskBlue"))
                    
                    // Simple selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Basic Usage")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        NovoNordiskRadioButtonList(
                            title: "Rodzaj leku",
                            options: MedicationType.allCases,
                            selectedOption: $selectedMedicationType,
                            optionTitle: { $0.displayName },
                            style: .standard
                        )
                        
                        if let selected = selectedMedicationType {
                            Text("Wybrano: \(selected.displayName)")
                                .font(.caption)
                                .foregroundColor(Color("NovoNordiskBlue"))
                                .padding(.top, 5)
                        }
                    }
                    
                    Divider()
                    
                    // Compact style
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Compact Style")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 30) {
                            VStack(alignment: .leading) {
                                NovoNordiskRadioButtonList(
                                    title: "Płeć",
                                    options: Gender.allCases,
                                    selectedOption: $selectedGender,
                                    optionTitle: { $0.displayName },
                                    style: .compact
                                )
                            }
                            
                            VStack(alignment: .leading) {
                                NovoNordiskRadioButtonList(
                                    title: "Pora dnia",
                                    options: TimeOfDay.allCases,
                                    selectedOption: $selectedTimeOfDay,
                                    optionTitle: { $0.displayName },
                                    style: .compact
                                )
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Card style with descriptions
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Card Style with Descriptions")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        NovoNordiskRadioButtonList(
                            title: "Typ cukrzycy",
                            options: DiabetesType.allCases,
                            selectedOption: $selectedDiabetesType,
                            optionTitle: { $0.displayName },
                            optionSubtitle: { $0.description },
                            style: .card
                        )
                    }
                    
                    Divider()
                    
                    // Complex example with experience levels
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Experience Levels")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        NovoNordiskRadioButtonList(
                            title: "Poziom doświadczenia z insuliną",
                            options: ExperienceLevel.allCases,
                            selectedOption: $selectedExperience,
                            optionTitle: { $0.displayName },
                            optionSubtitle: { $0.description },
                            style: .card
                        )
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("Radio Buttons")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Sample Data Models

enum MedicationType: String, CaseIterable, Identifiable, Hashable {
    case longActing = "long_acting"
    case shortActing = "short_acting"
    case premixed = "premixed"
    case other = "other"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .longActing:
            return "Insulina długodziałająca"
        case .shortActing:
            return "Insulina krótkodziałająca"
        case .premixed:
            return "Mieszanka insulinowa"
        case .other:
            return "Inne"
        }
    }
}

enum Gender: String, CaseIterable, Identifiable, Hashable {
    case male = "male"
    case female = "female"
    case other = "other"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .male:
            return "Mężczyzna"
        case .female:
            return "Kobieta"
        case .other:
            return "Inna"
        }
    }
}

enum TimeOfDay: String, CaseIterable, Identifiable, Hashable {
    case morning = "morning"
    case noon = "noon"
    case evening = "evening"
    case night = "night"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .morning:
            return "Rano"
        case .noon:
            return "Południe"
        case .evening:
            return "Wieczór"
        case .night:
            return "Noc"
        }
    }
}

enum DiabetesType: String, CaseIterable, Identifiable, Hashable {
    case type1 = "type1"
    case type2 = "type2"
    case gestational = "gestational"
    case mody = "mody"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .type1:
            return "Cukrzyca typu 1"
        case .type2:
            return "Cukrzyca typu 2"
        case .gestational:
            return "Cukrzyca ciążowa"
        case .mody:
            return "MODY"
        }
    }
    
    var description: String {
        switch self {
        case .type1:
            return "Insulinozależna, zwykle rozwija się w młodym wieku"
        case .type2:
            return "Nieinsulinozależna, związana ze stylem życia"
        case .gestational:
            return "Występuje podczas ciąży"
        case .mody:
            return "Monogenowa cukrzyca młodych"
        }
    }
}

enum ExperienceLevel: String, CaseIterable, Identifiable, Hashable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .beginner:
            return "Początkujący"
        case .intermediate:
            return "Średniozaawansowany"
        case .advanced:
            return "Zaawansowany"
        case .expert:
            return "Ekspert"
        }
    }
    
    var description: String {
        switch self {
        case .beginner:
            return "Dopiero zaczynam stosować insulinę"
        case .intermediate:
            return "Używam insuliny od kilku miesięcy"
        case .advanced:
            return "Mam doświadczenie z różnymi typami insuliny"
        case .expert:
            return "Jestem ekspertem w zarządzaniu cukrzycą"
        }
    }
}

// MARK: - Preview
#Preview {
    RadioButtonExamplesView()
} 