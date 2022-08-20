//
//  FilterBar.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

import SwiftUI

// MARK: - Filter bar
struct FilterBar: View {
    private let onFilterSelected: (TaxiPartyFilter) -> Void

    private let filters: [TaxiPartyFilter] = [EmptyFilter(), PohangFilter(), PostechFilter()]
    @Binding private var showCalendarModal: Bool
    @State private var selectedIndex: Int = 0
    @State private var cgRects: [CGRect] = Array(repeating: .zero, count: 3)

    init(_ showCalendarModal: Binding<Bool>, onFilterSelected: @escaping (TaxiPartyFilter) -> Void) {
        self._showCalendarModal = showCalendarModal
        self.onFilterSelected = onFilterSelected
    }
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Spacer().frame(width: 16)
            ForEach(0..<3) { index in
                Button {
                    withAnimation(.interactiveSpring()) {
                        selectedIndex = index
                        onFilterSelected(filters[index])
                    }
                } label: {
                    Text(filters[index].filterName)
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
                .background(GeometryReader { proxy in
                    Color.clear.onAppear {
                        cgRects[index] = proxy.frame(in: .named("FilterSection"))
                    }
                })
            }
            Spacer()
            dateSelector
            Spacer().frame(width: 16)
        }
        .foregroundColor(.customBlack)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.lightGray)
                .frame(height: 1)
                .overlay {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: cgRects[selectedIndex].width, height: 2)
                        .position(x: cgRects[selectedIndex].midX)
                }
        }
        .coordinateSpace(name: "FilterSection")
    }
}

// MARK: - Calendar Modal
private extension FilterBar {
    var dateSelector: some View {
        Button {
            withAnimation {
                showCalendarModal = true
            }
        } label: {
            Text("날짜선택")
                .font(.system(size: 12))
                .foregroundColor(.customBlack)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.selectYellow))
                .offset(x: 0, y: -2)

        }
        .buttonStyle(.plain)
    }
}
// MARK: - Preview
struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar(.constant(true)) { _ in }
    }
}
