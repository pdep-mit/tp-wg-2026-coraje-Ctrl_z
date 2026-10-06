// Este archivo puede ser borrado cuando empiecen 
// a desarrollar su trabajo
object player {
    var property position = game.center()
    const property inventario = [] 
    method image() = "player2.png"
    method agarrar(unItem) {
        inventario.add(unItem)
    }

    method tieneItem(nombreItem) {
        return inventario.any({ item => item.nombre() == nombreItem })
    }
}

class Item {
    var property position
    const property nombre
    const property image

    method esAtravesable() = true

    method interactuarCon(jugador) {
        jugador.agarrar(self)
        game.removeVisual(self)
        game.say(jugador, "Agarré " + nombre)
    }
}

class NPC {
    var property position
    const property image
    const property itemDeseado
    var property satisfecho = false
    method esAtravesable() = false

    method interactuarCon(jugador) {
        if (self.satisfecho()) {
            game.say(self, "")//esto es para cuando tengamos otros NPC
        } else if (jugador.tieneItem(itemDeseado)) {
            satisfecho = true
            game.say(self, "¡Gracias por el " + itemDeseado + "! Podés pasar.")
        } else {
            game.say(self, "Necesito un " + itemDeseado + " para dejarte pasar...")
        }
    }
}
class Muro {
    var property position
    method image() = "muro.png"
    
    method esAtravesable() = false
    method interactuarCon(jugador) {}
}

class Puerta {
    var property position
    var property npcCondicion 

    method image() = "puerta.png"
    method esAtravesable() = npcCondicion.satisfecho()

   method interactuarCon(jugador) {
        if (self.esAtravesable()) {
            game.say(jugador, "¡Escapaste de la AFA! ¡GANASTE!")           
            game.schedule(2000, {
                game.stop()
            })
        } else {
            game.say(self, "La puerta está trabada. Necesitás la aprobación de Riquelme.")
        }
    }
}



