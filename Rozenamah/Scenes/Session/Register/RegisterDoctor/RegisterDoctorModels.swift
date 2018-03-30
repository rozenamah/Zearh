import UIKit

enum DoctorSpecialization: String, Decodable {
    case cardiologists = "cardiologists"
    case dentist = "dentist"
    case dermatology = "dermatology"
    case earDoctors = "earDoctors"
    case nutrition = "nutrition"
    case diabetics = "diabetics"
    case familiyPhsicians = "familiyPhsicians"
    case gastroenterologists = "gastroenterologists"
    case infertilitySpecialists = "infertilitySpecialists"
    case internists = "internists"
    case nephrologists = "nephrologists"
    case neurologists = "neurologists"
    case obgyn = "obgyn"
    case oncologists = "oncologists"
    case ophthalmologists = "ophthalmologists"
    case orthopedic = "orthopedic"
    case pediatrics = "pediatrics"
    case physicalTherapists = "physicalTherapists"
    case plasticSurgeons = "plasticSurgeons"
    case psychologists = "psychologists"
    case sportMedicine = "sportMedicine"
    case urologists = "urologists"
    case generalPractitioner = "generalPractitioner"
    case generalSurgery = "generalSurgery"
    
    static var all: [DoctorSpecialization] {
        return [.cardiologists, .dentist, .dermatology,
                .earDoctors, .nutrition, .diabetics,
                .familiyPhsicians, .gastroenterologists, .infertilitySpecialists,
                .internists, .nephrologists, .neurologists,
                .obgyn, .oncologists, .ophthalmologists,
                .orthopedic, .pediatrics, .physicalTherapists,
                .plasticSurgeons, .psychologists, .sportMedicine,
                .urologists, .generalPractitioner, .generalSurgery]
    }
    
    var title: String {
        switch self {
        case .cardiologists: return "Cardiologists"
        case .dentist: return "Dentist"
        case .dermatology: return "Dermatology"
        case .earDoctors: return "Ear. Nose & Throat Doctors"
        case .nutrition: return "Nutrition"
        case .diabetics: return "Diabetics & Endocrinologists"
        case .familiyPhsicians: return "Familty Phsicians"
        case .gastroenterologists: return "Gastroenterologists"
        case .infertilitySpecialists: return "Infertility Specialists"
        case .internists: return "Internists"
        case .nephrologists: return "Nephrologistis"
        case .neurologists: return "Neurologists"
        case .obgyn: return "OB-GYNs"
        case .oncologists: return "Oncologists"
        case .ophthalmologists: return "Ophthalmologists"
        case .orthopedic: return "Ortopedic"
        case .pediatrics: return "Pediatrics"
        case .physicalTherapists: return "Physical Therapists"
        case .plasticSurgeons: return "Plastic Surgeons"
        case .psychologists: return "Psychologists"
        case .sportMedicine: return "Sport Medicine Specialists"
        case .urologists: return "Urologists"
        case .generalPractitioner: return "General Practitioner"
        case .generalSurgery: return "General Surgery"
        }
    }
}

enum Classification: String, Decodable {
    case doctor = "doctor"
    case nurse = "nurse"
    case specialist = "specialist"
    case consultants = "consultants"
    
    static var all: [Classification] {
        return [.nurse, .doctor, .consultants, .specialist, ]
    }
    
    var title: String {
        switch self {
        case .doctor: return "General Doctor"
        case .nurse: return "Nurse"
        case .specialist: return "Specialist"
        case .consultants: return "Consultants"
        }
    }
}

enum Gender: String, Decodable {
    case male = "male"
    case female = "female"
    
    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

final class RegisterDoctorForm: RegisterForm {
    var classification: Classification?
    var specialization: DoctorSpecialization?
    var price: Int?
    var gender: Gender?
    var pdf: Data?
    
    override var toParams: [String: Any] {
        var params = super.toParams
        
        params["classification"] = classification!.rawValue
        params["specialization"] = specialization?.rawValue ?? NSNull()
        params["gender"] = gender!.rawValue
        params["price"] = price!
        params["type"] = "doctor"
        params["pdf"] = "data:application/pdf;base64,\(pdf!.base64EncodedString())"
        
        return params
    }
    
}
