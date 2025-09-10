//
//  Historic.swift
//  LayoutDayToken
//
//  Created by Adauto Oliveira on 09/09/25.
//

import SwiftUI

struct Historic: View {
    @State private var items: [StatusTimelineItem] = []

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                StatusTimeline(
                    title: item.title, titleColor: Color(hex: item.titleColorHex) ?? .green,
                    dateString: item.dateString,
                    statusColor: Color(hex: item.colorHex) ?? .blue,
                    isCurrent: item.isCurrent,
                    lineDirection: lineDirection(for: index, total: items.count)
                )
            }
        }
        .padding(.horizontal, 16)
        .task { await loadFromAPI() }
    }

    private func lineDirection(for index: Int, total: Int) -> StatusTimeline.LineDirection {
        guard total > 1 else { return .none }
        if index == 0 { return .bottom }
        if index == total - 1 { return .top }
        return .both
    }

    private func loadFromAPI() async {
        // Mock – troque pelo fetch real
        await MainActor.run {
            self.items = [
                .init(id: UUID(), title: "Pedido recebido",  dateString: "12/10/25", colorHex: "#007AFF", titleColorHex: "#007AFF", isCurrent: false),
                .init(id: UUID(), title: "Em processamento", dateString: "13/10/25", colorHex: "#007AFF", titleColorHex: "#007AFF", isCurrent: false),
                .init(id: UUID(), title: "Concluído",        dateString: "14/10/25", colorHex: "#007AFF", titleColorHex: "#007AFF", isCurrent: true),
            ]
        }
    }
}


struct Historic_Previews: PreviewProvider {
    static var previews: some View {
        Historic()
            .previewLayout(.sizeThatFits)
    }
}

