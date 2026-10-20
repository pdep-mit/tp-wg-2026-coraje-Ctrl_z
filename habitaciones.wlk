
import wollok.game.*
import objetos.*

class Habitacion {
    const property posicionInicial
    var property objetos = []

    method agregarObjeto(objeto) {
        objetos.add(objeto)
    }

    method agregarBordes() {
        (0..14).forEach({ x =>
            self.agregarObjeto(
                new Muro(position = game.at(x, 0))
            )
            self.agregarObjeto(
                new Muro(position = game.at(x, 14))
            )
        })

        (1..13).forEach({ y =>
            self.agregarObjeto(
                new Muro(position = game.at(0, y))
            )
            self.agregarObjeto(
                new Muro(position = game.at(14, y))
            )
        })
    }

    method cargar() {
        objetos.filter({ objeto => not player.inventario().contains(objeto) }).forEach({ objeto =>
            game.addVisual(objeto)
        })
    }

    method descargar() {
        objetos.filter({ objeto => game.getObjectsIn(objeto.position()).contains(objeto) }).forEach({ objeto =>
            game.removeVisual(objeto)
        })
    }

    method cambiarA(nuevaHabitacion) {
        self.descargar()
        nuevaHabitacion.cargar()
        player.position(nuevaHabitacion.posicionInicial())
    }
}

object niveles {
    const habitacion1 = new Habitacion(
        posicionInicial = game.at(1, 1)
    )

    const habitacion2 = new Habitacion(
        posicionInicial = game.at(1, 1)
    )

    method preparar() {
        self.prepararHabitacion1()
        self.prepararHabitacion2()
    }

    method prepararHabitacion1() {
        habitacion1.agregarBordes()

        const mate = new Item(
            nombre = "mate",
            image = "mate.png",
            position = game.at(5, 5)
        )

        const riquelme = new NPC(
            itemDeseado = "mate",
            image = "riquelme.png",
            position = game.at(8, 8)
        )

        const puerta = new Puerta(
            position = game.at(13, 13),
            npcsCondicion = [riquelme],
            habitacionActual = habitacion1,
            siguienteHabitacion = habitacion2
        )

        habitacion1.agregarObjeto(mate)
        habitacion1.agregarObjeto(riquelme)
        habitacion1.agregarObjeto(puerta)
    }

    method prepararHabitacion2() {
        habitacion2.agregarBordes()

        const foto = new Item(
            nombre = "foto de messi",
            image = "foto_messi.png",
            position = game.at(3, 3)
        )

        const dePaul = new NPC(
            itemDeseado = "foto de messi",
            image = "depaul.png",
            position = game.at(10, 10)
        )

        habitacion2.agregarObjeto(foto)
        habitacion2.agregarObjeto(dePaul)
        habitacion2.agregarObjeto(new Puerta(
            position = game.at(13, 13),
            npcsCondicion = [dePaul]
        ))
    }

    method iniciar() {
        self.preparar()
        habitacion1.cargar()
        player.position(habitacion1.posicionInicial())
    }
}
