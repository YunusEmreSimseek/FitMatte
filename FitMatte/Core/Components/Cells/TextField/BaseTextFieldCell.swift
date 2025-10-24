//
//  TextFieldCell.swift
//  FitMatte
//
//  Created by Emre Simsek on 8.10.2025.
//
import UIKit

typealias BaseTextFieldRow = DataSectionRow<BaseTextFieldCell>
final class BaseTextFieldCell: BaseTableCell<BaseTextField> {}

typealias TextFieldRow = DataSectionRow<TextFieldCell>
final class TextFieldCell: BaseTableCell<UITextField> {}
