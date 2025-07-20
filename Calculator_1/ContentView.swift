//
//  ContentView.swift
//  calculator
//
//  Created by Saaral Varunie on 31/01/25.
//

import SwiftUI

enum CalcButton: String {
    case one = "1", two = "2", three = "3"
    case four = "4", five = "5", six = "6"
    case seven = "7", eight = "8", nine = "9"
    case zero = "0", add = "+", subtract = "-"
    case divide = "/", multiply = "x", equal = "="
    case clear = "AC", decimal = ".", percent = "%"
    case negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .divide, .multiply, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1))
        }
    }
}

struct ContentView: View {
    
    @State private var value = "0"
    @State private var currentOperation: CalcButton? = nil
    @State private var firstNumber: Double? = nil
    @State private var isTypingNumber = false

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Display
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding()

                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item) / 2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func didTap(button: CalcButton) {
        switch button {
        case .clear:
            value = "0"
            firstNumber = nil
            currentOperation = nil
            isTypingNumber = false
            
        case .decimal:
            if !value.contains(".") {
                value += "."
                isTypingNumber = true
            }

        case .negative:
            if let num = Double(value) {
                value = String(num * -1)
            }

        case .percent:
            if let num = Double(value) {
                value = String(num / 100)
            }

        case .add, .subtract, .multiply, .divide:
            firstNumber = Double(value)
            currentOperation = button
            isTypingNumber = false

        case .equal:
            if let firstNumber = firstNumber, let secondNumber = Double(value), let operation = currentOperation {
                switch operation {
                case .add:
                    value = String(firstNumber + secondNumber)
                case .subtract:
                    value = String(firstNumber - secondNumber)
                case .multiply:
                    value = String(firstNumber * secondNumber)
                case .divide:
                    value = secondNumber == 0 ? "Error" : String(firstNumber / secondNumber)
                default:
                    break
                }
            }
            currentOperation = nil
            isTypingNumber = false

        default:
            if isTypingNumber {
                value += button.rawValue
            } else {
                value = button.rawValue
                isTypingNumber = true
            }
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return (UIScreen.main.bounds.width - (4 * 12)) / 4 * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

#Preview {
    ContentView()
}
