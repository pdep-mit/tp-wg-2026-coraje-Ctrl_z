object player {
    var property position = game.center()
    var property gano = false
    const property inventario = [] 
    var property vestimenta = ropaComun

    method image() = vestimenta.imagenDelJugador()

    method ponerse(unaVestimenta) {
        vestimenta = unaVestimenta
    }

    method llevaPuesto(unaVestimenta) = vestimenta == unaVestimenta

    method agarrar(unItem) {
        inventario.add(unItem)
    }

    method removerItem(unItem) {
        inventario.remove(unItem)
    }

    method tieneItem(unItem) {
        return inventario.contains(unItem)
    }
} 

object ropaComun {
    method imagenDelJugador() = "player2.png"
}

object uniformeSancor {
    method nombre() = "uniforme de Sancor Seguros"
    method imagenDelJugador() = "disfraz.png"
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
    const property imagenDelJugador = "disfraz.png"

    override method interactuarCon(jugador) {
        super(jugador)
        jugador.ponerse(self)
        game.say(jugador, "¡Con esta ropa de Sancor Seguros puedo engañar al Chiqui Tapia!.")
    }
} 
class Impresora {
    var property position
    const property papel
    const property tinta
    const property itemImpreso
    var property imprimio = false

    method image() = "impresora.png"
    method esAtravesable() = false
    method esInteractuable() = true 
    method puedeMostrarse() = true

    method interactuarCon(jugador) {

        if (imprimio) {
            game.say(self, "La impresora ya fue utilizada.")
        } else if (jugador.tieneItem(papel) and jugador.tieneItem(tinta)) {
            jugador.removerItem(papel)
            jugador.removerItem(tinta)
            papel.recogido(true)
            tinta.recogido(true)

            jugador.agarrar(itemImpreso)

            imprimio = true
            game.say(jugador, "¡Imprimí la foto de Messi!")
        } else {
            game.say(self, "Necesitás papel y tinta para imprimir.")
        }
    }
}  

class Armario {
    var property position
    const property llave
    const property disfraz = uniformeSancor
    var property utilizado = false

    method image() = "armario.png"
    method esAtravesable() = false
    method esInteractuable() = true
    method puedeMostrarse() = true

    method interactuarCon(jugador) {
        if (utilizado) {
            game.say(self, "El armario ya está vacío.")
        } else if (jugador.tieneItem(llave)) {
            jugador.ponerse(disfraz)
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
    var property estado = estadoEsperando
    const property mensajeAgradecimiento = "¡Gracias por el " + itemDeseado.nombre() + "! Podés pasar."
    const property mensajeEspera = "Necesito un " + itemDeseado.nombre() + " para dejarte pasar..."
    const property mensajeSatisfecho = "Ya tengo lo que necesito, ¡andá!"

    method esAtravesable() = false
    method esInteractuable() = true
    method puedeMostrarse() = true

    method satisfecho() = estado.estaSatisfecho()

    method cumpleCondicion(jugador) = jugador.tieneItem(itemDeseado)

    method consumirItemDeseado(jugador) {
        jugador.removerItem(itemDeseado)
        itemDeseado.recogido(true)
    }

    method interactuarCon(jugador) {
        estado.interactuar(self, jugador)
    }

    method aceptar(jugador) {
        self.consumirItemDeseado(jugador)
        estado = estadoSatisfecho
        game.say(self, mensajeAgradecimiento)
        self.darRecompensa(jugador)
    }

    method rechazar(jugador) {
        game.say(self, mensajeEspera)
    }

    method darRecompensa(jugador) {}
}

object estadoEsperando {
    method estaSatisfecho() = false

    method interactuar(npc, jugador) {
        if (npc.cumpleCondicion(jugador)) {
            npc.aceptar(jugador)
        } else {
            npc.rechazar(jugador)
        }
    }
}

object estadoSatisfecho {
    method estaSatisfecho() = true

    method interactuar(npc, jugador) {
        game.say(npc, npc.mensajeSatisfecho())
    }
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

    override method cumpleCondicion(jugador) = jugador.llevaPuesto(itemDeseado)

    override method consumirItemDeseado(jugador) {}

    override method rechazar(jugador) {
        super(jugador)
        game.schedule(2000, { game.stop() })
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




