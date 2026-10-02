// Este archivo puede ser borrado cuando empiecen 
// a desarrollar su trabajo
object player {
	var property position = game.center()
	method image() = "player2.png"
} 

class Muro {
	var property position
	method image() = "muro.png"
	
	method esAtravesable() = false
}