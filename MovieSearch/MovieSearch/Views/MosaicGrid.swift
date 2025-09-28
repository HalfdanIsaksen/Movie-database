//
//  MosaicGrid.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 18/09/2025.
//

import SwiftUI

struct MosaicGrid<Movie: Identifiable, Cell: View>: View {
    let movies: [Movie]
    var smallHeight: CGFloat = 170
    var hSpacing: CGFloat = 8
    var vSpacing: CGFloat = 8
    @ViewBuilder let cell: (Movie) -> Cell

    private var cycleSize: Int { 6 } // 3 small + 3 mosaic slots

    var body: some View {
        let groups = movies.chunked(into: cycleSize)

        Grid(horizontalSpacing: hSpacing, verticalSpacing: vSpacing) {
            ForEach(groups.indices, id: \.self) { groupIdx in
                let group = groups[groupIdx]

                // Row 1: up to 3 small posters
                GridRow {
                    ForEach(0..<3, id: \.self) { i in
                        if i < group.count {
                            SizedCell(height: smallHeight) { cell(group[i]) }
                        } else {
                            Color.clear.frame(height: smallHeight)
                        }
                    }
                }

                // Row 2: alternate the mosaic side each cycle
                if group.count > 3 {
                    // slots: [3] is the "large" candidate, [4], [5] are smalls if available
                    let large = group[3]
                    let small4 = group.indices.contains(4) ? group[4] : nil
                    let small5 = group.indices.contains(5) ? group[5] : nil

                    let isEvenCycle = groupIdx % 2 == 0

                    GridRow {
                        if isEvenCycle {
                            // Large LEFT, two smalls stacked RIGHT
                            SizedCell(height: smallHeight * 2 + vSpacing) { cell(large) }
                                .gridCellColumns(2)

                            VStack(spacing: vSpacing) {
                                if let s4 = small4 {
                                    SizedCell(height: smallHeight) { cell(s4) }
                                } else {
                                    Color.clear.frame(height: smallHeight)
                                }
                                if let s5 = small5 {
                                    SizedCell(height: smallHeight) { cell(s5) }
                                } else {
                                    Color.clear.frame(height: smallHeight)
                                }
                            }
                        } else {
                            // Two smalls stacked LEFT, Large RIGHT
                            VStack(spacing: vSpacing) {
                                if let s4 = small4 {
                                    SizedCell(height: smallHeight) { cell(s4) }
                                } else {
                                    Color.clear.frame(height: smallHeight)
                                }
                                if let s5 = small5 {
                                    SizedCell(height: smallHeight) { cell(s5) }
                                } else {
                                    Color.clear.frame(height: smallHeight)
                                }
                            }

                            SizedCell(height: smallHeight * 2 + vSpacing) { cell(large) }
                                .gridCellColumns(2)
                        }
                    }
                }
            }
        }
    }
}

// Helper that fixes a cell’s height while letting it expand horizontally in the grid.
private struct SizedCell<Content: View>: View {
    let height: CGFloat
    @ViewBuilder var content: Content
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// Handy chunking util
private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var result: [[Element]] = []
        result.reserveCapacity((count + size - 1)/size)
        var i = 0
        while i < count {
            result.append(Array(self[i..<Swift.min(i+size, count)]))
            i += size
        }
        return result
    }
}
