//
//  File.swift
//  Rozenamah
//
//  Created by Dominik Majda on 05.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

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
        case .cardiologists: return "home.specialization.cardiologists".localized
        case .dentist: return "home.specialization.dentist".localized
        case .dermatology: return "home.specialization.dermatology".localized
        case .earDoctors: return "home.specialization.earDoctors".localized
        case .nutrition: return "home.specialization.nutrition".localized
        case .diabetics: return "home.specialization.diabetics".localized
        case .familiyPhsicians: return "home.specialization.familiyPhsicians".localized
        case .gastroenterologists: return "home.specialization.gastroenterologists".localized
        case .infertilitySpecialists: return "home.specialization.infertilitySpecialists".localized
        case .internists: return "home.specialization.internists".localized
        case .nephrologists: return "home.specialization.nephrologists".localized
        case .neurologists: return "home.specialization.neurologists".localized
        case .obgyn: return "home.specialization.obgyn".localized
        case .oncologists: return "home.specialization.oncologists".localized
        case .ophthalmologists: return "home.specialization.ophthalmologists".localized
        case .orthopedic: return "home.specialization.orthopedic".localized
        case .pediatrics: return "home.specialization.pediatrics".localized
        case .physicalTherapists: return "home.specialization.physicalTherapists".localized
        case .plasticSurgeons: return "home.specialization.plasticSurgeons".localized
        case .psychologists: return "home.specialization.psychologists".localized
        case .sportMedicine: return "home.specialization.sportMedicine".localized
        case .urologists: return "home.specialization.urologists".localized
        case .generalPractitioner: return "home.specialization.generalPractitioner".localized
        case .generalSurgery: return "home.specialization.generalSurgery".localized
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
        case .doctor: return "home.doctor".localized
        case .nurse: return "home.nurse".localized
        case .specialist: return "home.specialist".localized
        case .consultants: return "home.consultants".localized
        }
    }
}

enum Gender: String, Decodable {
    case male = "male"
    case female = "female"
    
    var title: String {
        switch self {
        case .male: return "session.doctor.male".localized
        case .female: return "session.doctor.female".localized
        }
    }
}
