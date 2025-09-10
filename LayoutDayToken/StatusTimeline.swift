//
//  StatusTimeline.swift
//  LayoutDayToken
//
//  Created by Adauto Oliveira on 09/09/25.
//

import SwiftUI

struct StatusTimelineItem: Identifiable, Decodable {
    let id: UUID
    let title: String
    let dateString: String
    let colorHex: String
    let titleColorHex: String
    let isCurrent: Bool
}


import SwiftUI

public struct StatusTimeline: View {
    public enum LineDirection { case top, bottom, both, none }

    let title: String
    let titleColor: Color
    let dateString: String
    let statusColor: Color
    let isCurrent: Bool
    let lineDirection: LineDirection

    // Layout
    private let lineThickness: CGFloat = 2
    private let leftInset: CGFloat = 24           // distância da margem esquerda até o CENTRO da timeline
    private let timelineColumnWidth: CGFloat = 24  // largura fixa da coluna (independe do diâmetro)
    private let spacing: CGFloat = 12
    private let rowHeight: CGFloat = 50

    public var body: some View {
        let circleDiameter: CGFloat = isCurrent ? 12 : 8

        HStack(spacing: spacing) {
            ZStack {
                VStack(spacing: 0) {
                    if lineDirection == .top || lineDirection == .both {
                        Rectangle()
                            .fill(Color(hex: "#ADD8E6") ?? .black)
                            .frame(width: lineThickness)
                            .frame(maxHeight: .infinity)
                    } else {
                        Spacer().frame(maxHeight: .infinity)
                    }

                    // gap exatamente do tamanho do círculo
                    Spacer().frame(height: circleDiameter)

                    if lineDirection == .bottom || lineDirection == .both {
                        Rectangle()
                            .fill(Color(hex: "#ADD8E6") ?? .black)
                            .frame(width: lineThickness)
                            .frame(maxHeight: .infinity)
                    } else {
                        Spacer().frame(maxHeight: .infinity)
                    }
                }

                
                Circle()
                    .fill(statusColor)
                    .frame(width: circleDiameter, height: circleDiameter)
            }
            .frame(width: timelineColumnWidth, height: rowHeight)
            // move a COLUNA para que seu centro fique a `leftInset` da borda esquerda
            .padding(.leading, leftInset - timelineColumnWidth / 2)

            // Título
            Text(title)
                .foregroundColor(titleColor)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Data
            Text(dateString)
                .foregroundColor(.gray)
                .font(.body)
                .frame(alignment: .trailing)
        }
        .frame(height: rowHeight)
    }

    public init(
        title: String,
        titleColor: Color,
        dateString: String,
        statusColor: Color,
        isCurrent: Bool,
        lineDirection: LineDirection
    ) {
        self.title = title
        self.titleColor = titleColor
        self.dateString = dateString
        self.statusColor = statusColor
        self.isCurrent = isCurrent
        self.lineDirection = lineDirection
    }
}


extension Color {
    init?(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var value: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&value) else { return nil }

        switch s.count {
        case 6: // RRGGBB
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >>  8) & 0xFF) / 255.0
            let b = Double( value        & 0xFF) / 255.0
            self = Color(red: r, green: g, blue: b)
        case 8: // AARRGGBB
            let a = Double((value >> 24) & 0xFF) / 255.0
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >>  8) & 0xFF) / 255.0
            let b = Double( value        & 0xFF) / 255.0
            self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
        default:
            return nil
        }
    }
}



// MARK: - Exemplo de uso / Preview
struct StatusTimeline_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            StatusTimeline(
                title: "Pedido recebido",
                titleColor: .gray,
                dateString: "12/10/25",
                statusColor: Color(hex: "#007AFF") ?? .blue,
                isCurrent: true,
                lineDirection: .bottom 
            )
        }
        .previewLayout(.sizeThatFits)
    }
}

