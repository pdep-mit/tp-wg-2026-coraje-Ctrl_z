object player {
    var property position = game.center()
    var property gano = false
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
    const property npcsCondicion
    const property habitacionActual = null
    const property siguienteHabitacion = null

    method image() = "puerta.png"

    method esAtravesable() =
        npcsCondicion.all({ npc => npc.satisfecho() })

    method interactuarCon(jugador) {
        if (self.esAtravesable() and not jugador.gano()) {
            if (siguienteHabitacion == null) {
                jugador.gano(true)
                game.say(jugador, "¡Escapaste de la AFA! ¡GANASTE!")
                game.schedule(2000, {
                    game.stop()
                })
            } else {
                habitacionActual.cambiarA(siguienteHabitacion)
            }
        } else if (not jugador.gano()) {
            game.say(self,
                "La puerta está trabada. Necesitás cumplir los requisitos.")
        }
    }
}




