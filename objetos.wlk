// Este archivo puede ser borrado cuando empiecen 
// a desarrollar su trabajo
object player {
	var property position = game.center()
	var property tieneMate = false
	
	method image() = "player2.png"
}

class Muro {
	var property position
	method image() = "muro.png"
	
	method esAtravesable() = false
}

class Mate {
    var property position

    method image() = "mate.png"

    method esAtravesable() = true

	method interactuarCon(jugador) { 
        jugador.tieneMate = true 
        game.removeVisual(self) 
    } 
}

class Puerta {
    var property position
    var property leandroparedes

    method image() = "puerta.png"

    method esAtravesable() = leandroparedes.satisfecho
}

class LeandroParedes {
    var property position
    var property satisfecho = false

    method image() = "leandroparedes.png"

    method esAtravesable() = true

	method interactuarCon(jugador) {
        if (jugador.tieneMate) {
            self.satisfecho = true
        }
	}
}