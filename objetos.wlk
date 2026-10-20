object player {
    var property position = game.center()
    var property gano = false
    const property inventario = [] 
    var property estaDisfrazado = false

    method image() = if (estaDisfrazado) "disfraz.png" else "player2.png"

    method agarrar(unItem) {
        inventario.add(unItem)
    }

    method removerItem(unItem) {
        inventario.remove(unItem)
    }

    method buscarItem(nombreItem) {
        return inventario.find({ item => item.nombre() == nombreItem })
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

class Disfraz inherits Item {

    override method interactuarCon(jugador) {
        super(jugador)
        jugador.estaDisfrazado(true)
        game.say(jugador, "¡Con esta ropa de Sancor Seguros puedo engañar al Chiqui Tapia!.")
    }
} 
class Impresora {
    var property position
    var property imprimio = false

    method image() = "impresora.png"
    method esAtravesable() = false

    method interactuarCon(jugador) {
        if (imprimio) {
            game.say(self, "La impresora ya fue utilizada.")
        } else if (jugador.tieneItem("papel") and jugador.tieneItem("tinta")) {
            const papel = jugador.buscarItem("papel")
            const tinta = jugador.buscarItem("tinta")
            jugador.removerItem(papel)
            jugador.removerItem(tinta)

            const fotoDeMessi = new Item(
                nombre = "foto de messi", 
                image = "foto_messi.png", 
                position = self.position()
            )
            jugador.agarrar(fotoDeMessi)
            
            imprimio = true
            game.say(jugador, "¡Imprimí la foto de Messi!")
        } else {
            game.say(self, "Necesitás papel y tinta para imprimir.")
        }
    }
}  
class Armario {
    var property position
    const property npcRequisito
    var property utilizado = false

    method image() = "armario.png"
    method esAtravesable() = false

    method interactuarCon(jugador) {
        if (utilizado) {
            game.say(self, "El armario ya está vacío.")
        } else if (npcRequisito.satisfecho()) {
            jugador.estaDisfrazado(true) // Cambia directamente el estado del player
            utilizado = true
            game.say(jugador, "¡Con este uniforme de Sancor Seguros puedo engañar al Chiqui Tapia!.")
        } else {
            game.say(self, "El armario está cerrado. De Paul necesita su foto primero.")
        }
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
class NPCJefe inherits NPC {

    override method interactuarCon(jugador) {
        if (not jugador.estaDisfrazado()) {
            game.say(self, "¡que haces aca pibe, vos no te quejaste de mi idea del SupermegaCampeonDeCampeones?")
            game.schedule(2000, { game.stop() })
        } else if (self.satisfecho()) {
            game.say(self, "¡todavia seguis aca ? anda rapido a preparar otro show de drones!")
        } else {
            satisfecho = true
            game.say(self, "¡sos mi Confiable amigo de Sancor Seguros podes pasar!")
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




