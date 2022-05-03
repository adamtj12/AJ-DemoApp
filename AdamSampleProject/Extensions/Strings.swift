//  Currencies.swift
//  AdamSampleProject

import Foundation

public struct RatesValuesRequesti {
    public let USD, EUR, JPY, GBP, AUD, CAD, CHF, CNY, SEK, NZD: String
}

public var currencyStrings = RatesValuesRequesti.init(USD: "USD", EUR: "EUR", JPY: "JPY", GBP: "GBP", AUD: "AUD", CAD: "CAD", CHF: "CHF", CNY: "CNY", SEK: "SEK", NZD: "NZD")


public let originalDateFormat = "yyyy-MM-dd"
public let newDateFormat = "dd/MM/yyyy"
public let NibNameValue = "VerticleTitleTwoSubTitleTableViewCell"

public let enableCompareString = "Enable Compare"
public let finishString = "Finish"


public let fieldCollectionViewCellString = "FieldCollectionViewCell"
public let fieldCellString = "FieldCell"
