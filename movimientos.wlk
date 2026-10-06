import configuracion.* 

object movimiento {
	method mover(personaje, direccion) {
		const nuevaPosicion = direccion.posicionSiguiente(personaje.position())
		const hayObstaculo = game.getObjectsIn(nuevaPosicion).any({ elemento => not elemento.esAtravesable() })
		
		if (not hayObstaculo) {
			personaje.position(nuevaPosicion)

			//movi estas lineas dentro del método mover() para que se ejecuten después de que el
			//personaje cambie de posición, por eso tiraba error
			const objetos = game.getObjectsIn(nuevaPosicion)

			objetos.forEach({ objeto =>
		    objeto.interactuarCon(personaje)
			})
		}
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

