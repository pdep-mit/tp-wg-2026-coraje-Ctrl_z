import wollok.game.*
import configuracion.* 
object movimiento {
    method mover(personaje, direccion) {
    const nuevaPosicion = direccion.posicionSiguiente(personaje.position())
    const objetosEnDestino = game.getObjectsIn(nuevaPosicion)

    const hayObstaculo = objetosEnDestino.any({ objeto =>
        not objeto.esAtravesable()
    })

    if (not hayObstaculo) {
        personaje.position(nuevaPosicion)
    }

    objetosEnDestino
        .filter({ objeto => objeto.esInteractuable() })
        .forEach({ objeto => objeto.interactuarCon(personaje) })
}
}

object haciaArriba {
	method posicionSiguiente(posicion) = posicion.up(1)
}

object haciaAbajo {
	method posicionSiguiente(posicion) = posicion.down(1)
}

object haciaLaDerecha {
	method posicionSiguiente(posicion) = posicion.right(1)
}

object haciaLaIzquierda {
	method posicionSiguiente(posicion) = posicion.left(1)
}

