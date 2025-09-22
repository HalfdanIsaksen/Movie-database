//
//  MosaicGrid.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 18/09/2025.
//

import SwiftUI

struct MosaicGrid<Movie: Identifiable, Cell: View>: View {
    let movies: [Movie]
    var smallHeight: CGFloat = 170         // tweak to taste / aspect ratio
    var hSpacing: CGFloat = 8
    var vSpacing: CGFloat = 8
    @ViewBuilder let cell: (Movie) -> Cell

    private var cycleSize: Int { 6 }       // 3 small + (1 large + 2 small) = 6 per pattern

    var body: some View {
        Grid(horizontalSpacing: hSpacing, verticalSpacing: vSpacing) {
            // Process in groups of 6 so the pattern repeats
            ForEach(Array(movies.chunked(into: cycleSize)).indices, id: \.self) { idx in
                let group = movies.chunked(into: cycleSize)[idx]

                // Row A: up to 3 small posters
                GridRow {
                    ForEach(0..<3, id: \.self) { i in
                        if i < group.count {
                            SizedCell(height: smallHeight) { cell(group[i]) }
                        } else {
                            Color.clear.frame(height: smallHeight)
                        }
                    }
                }

                // Row B: mosaic (1 large spanning two columns + two stacked smalls)
                if group.count > 3 {
                    let large = group[3]
                    let rightSmalls = Array(group.dropFirst(4).prefix(2))

                    GridRow {
                        // Large poster: width = 2 columns, height = ~2 smalls + spacing
                        SizedCell(height: smallHeight * 2 + vSpacing) { cell(large) }
                            .gridCellColumns(2)

                        VStack(spacing: vSpacing) {
                            if rightSmalls.indices.contains(0) {
                                SizedCell(height: smallHeight) { cell(rightSmalls[0]) }
                            } else {
                                Color.clear.frame(height: smallHeight)
                            }
                            if rightSmalls.indices.contains(1) {
                                SizedCell(height: smallHeight) { cell(rightSmalls[1]) }
                            } else {
                                Color.clear.frame(height: smallHeight)
                            }
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
