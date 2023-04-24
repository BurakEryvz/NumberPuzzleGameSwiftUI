import SwiftUI

struct PuzzlePiece: View {
    let text: String
    let bosMu: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: 100, height: 100)
                .foregroundColor(bosMu ? .clear : .white)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct ContentView: View {
    @State private var puzzleMatrix: [[String]] = [
        ["7", "5", "6"],
        ["1", "2", "3"],
        ["4", "8", ""]
    ]
    @State private var tamamlandiMi: Bool = false
    @State private var hareketSayisi: Int = 0

    func onTap(row: Int, col: Int) {
        guard !tamamlandiMi && puzzleMatrix[row][col] != "" else { return }
        let directions: [(Int, Int)] = [(0, -1), (0, 1), (-1, 0), (1, 0)]
        for (dx, dy) in directions {
            let newRow = row + dx
            let newCol = col + dy
            if newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && puzzleMatrix[newRow][newCol] == "" {
                puzzleMatrix[newRow][newCol] = puzzleMatrix[row][col]
                puzzleMatrix[row][col] = ""
                hareketSayisi += 1
                checkCompletion()
                break
            }
        }
    }

    func checkCompletion() {
        for row in 0..<3 {
            for col in 0..<3 {
                if puzzleMatrix[row][col] != "\(row * 3 + col + 1)" {
                    return
                }
            }
        }
        tamamlandiMi = true
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Hareket Sayısı: \(hareketSayisi)")
                .font(.title)
                .fontWeight(.bold)
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { col in
                        PuzzlePiece(text: puzzleMatrix[row][col], bosMu: puzzleMatrix[row][col] == "", onTap: {
                            onTap(row: row, col: col)
                        })
                    }
                }
            }
            if tamamlandiMi {
                Text("tebrikler!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

