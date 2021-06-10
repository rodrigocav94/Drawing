//
//  ContentView.swift
//  Drawing
//
//  Created by Rodrigo Cavalcanti on 09/02/21.
//

import SwiftUI

struct Seta: Shape {
    var linha: CGFloat
    var animatableData: CGFloat {
        get { linha }
        set { self.linha = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x:rect.midX, y:0))
        path.addLine(to: CGPoint(x:rect.maxX, y:rect.midY))
        path.addLine(to: CGPoint(x:(rect.maxX - linha), y:rect.midY))
        path.addLine(to: CGPoint(x:(rect.maxX - linha), y:rect.maxY))
        path.addLine(to: CGPoint(x:(rect.minX + linha), y:rect.maxY))
        path.addLine(to: CGPoint(x:(rect.minX + linha), y:rect.midY))
        path.addLine(to: CGPoint(x:(rect.minX), y:rect.midY))
        path.addLine(to: CGPoint(x:rect.midX, y:0))
        
        return path
    }
    
    
}

struct Triangulo: InsettableShape {
    var insetAmount: CGFloat = 0
    func inset(by amount: CGFloat) -> some InsettableShape {
        var seta = self
        seta.insetAmount += amount
        return seta
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + CGFloat(insetAmount)))
        path.addLine(to: CGPoint(x: rect.maxX - CGFloat(insetAmount), y: rect.maxY - CGFloat(insetAmount)))
        path.addLine(to: CGPoint(x: rect.minX + CGFloat(insetAmount), y: rect.maxY - CGFloat(insetAmount)))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + CGFloat(insetAmount)))
        return path
    }
}

struct ColorCiclingTriangle: View {
    
    func arcoiris(camada: Double, luminosidade: Bool) -> Color {
        var camadaAparada = (camada/Double(self.camadas)) + self.corInicial
        if camadaAparada >= 1 {
            camadaAparada -= 1
        }
        if luminosidade {
            return Color(hue: camadaAparada, saturation: 1, brightness: 0.5)
        } else {
            return Color(hue: camadaAparada, saturation: 1, brightness: 1)
        }
    }
    
    let corInicial: Double
    let camadas: Int
    
    var body: some View {
        VStack{
            ZStack {
                ForEach(0 ..< camadas) { camada in
                    Triangulo()
                        .inset(by: CGFloat(camada))
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.arcoiris(camada: Double(camada), luminosidade: false), self.arcoiris(camada: Double(camada), luminosidade: true)]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var tamanhoDaLinha:CGFloat = 5.0
    @State private var corInicial: Double = 0
    
    var body: some View {
        VStack {
        Seta(linha: CGFloat(tamanhoDaLinha))
            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                withAnimation {
                    self.tamanhoDaLinha = CGFloat.random(in: 1...149)
                }
            }
            
            ColorCiclingTriangle(corInicial: corInicial, camadas: 100)
                .frame(width: 300, height: 300)
                .drawingGroup()
            Slider(value: $corInicial, in: 0...1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
