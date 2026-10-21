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
    var property recogido = false

    method esAtravesable() = true
    method esInteractuable() = true
    method puedeMostrarse() = not recogido

    method interactuarCon(jugador) {
      if (not recogido) {
        jugador.agarrar(self)
        recogido = true
        game.removeVisual(self)
        game.say(jugador, "Agarré " + nombre)
      }
    }
}

class Disfraz inherits Item {

    override method interactuarCon(jugador) {
        super.interactuarCon(jugador)
        jugador.estaDisfrazado(true)
        game.say(jugador, "¡Con esta ropa de Sancor Seguros puedo engañar al Chiqui Tapia!.")
    }
} 
class Impresora {
    var property position
    var property imprimio = false

    method image() = "impresora.png"
    method esAtravesable() = false
    method esInteractuable() = true 
    method puedeMostrarse() = true

    method interactuarCon(jugador) {

        if (imprimio) {
            game.say(self, "La impresora ya fue utilizada.")
        } else if (jugador.tieneItem("papel") and jugador.tieneItem("tinta")) {
            const papel = jugador.buscarItem("papel")
            const tinta = jugador.buscarItem("tinta")
            jugador.removerItem(papel)
            jugador.removerItem(tinta)
            papel.recogido(true)
            tinta.recogido(true)

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
    var property utilizado = false

    method image() = "armario.png"
    method esAtravesable() = false
    method esInteractuable() = true
    method puedeMostrarse() = true

    method interactuarCon(jugador) {
        if (utilizado) {
            game.say(self, "El armario ya está vacío.")
        } else if (jugador.tieneItem("llave de armario")) {
            jugador.estaDisfrazado(true)
            utilizado = true
            game.say(jugador, "¡Con este uniforme de Sancor Seguros puedo engañar al Chiqui Tapia!")
        } else {
            game.say(self, "El armario está bajo llave. Necesitás conseguir la llave.")
        }
    }
}

class NPC {
    var property position
    const property image
    const property itemDeseado
    var property satisfecho = false
    const property mensajeAgradecimiento = "¡Gracias por el " + itemDeseado + "! Podés pasar."
    const property mensajeEspera = "Necesito un " + itemDeseado + " para dejarte pasar..."
    const property mensajeSatisfecho = "Ya tengo lo que necesito, ¡andá!"

    method esAtravesable() = false
    method esInteractuable() = true
    method puedeMostrarse() = true

    method consumirItemDeseado(jugador) {

     if (itemDeseado != "") {
        const itemAConsumir = jugador.buscarItem(itemDeseado)
        jugador.removerItem(itemAConsumir)
        itemAConsumir.recogido(true)
     }
    }

    method interactuarCon(jugador) {
        if (self.satisfecho()) {
            game.say(self, mensajeSatisfecho)
        } else if (jugador.tieneItem(itemDeseado)) {
            self.consumirItemDeseado(jugador)
            satisfecho = true
            game.say(self, mensajeAgradecimiento)
            self.darRecompensa(jugador)
        } else {
            game.say(self, mensajeEspera)
        }
    }
    method darRecompensa(jugador) {}
}

class NPCConRecompensa inherits NPC {
    const property itemRecompensa
    var property habitacion = null

    override method darRecompensa(jugador) {
    if (habitacion != null) {
        habitacion.agregarObjeto(itemRecompensa)
    }

    game.addVisual(itemRecompensa)
    game.say(self, "¡Ahí te dejé la " + itemRecompensa.nombre() + " en el piso!")
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
    method esInteractuable() = false
    method puedeMostrarse() = true
    method interactuarCon(jugador) {}
}


class Puerta {
    var property position
    const property npcsCondicion
    const property habitacionActual = null
    const property siguienteHabitacion = null

    method image() = "puerta.png"
    method esInteractuable() = true
    method puedeMostrarse() = true

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




