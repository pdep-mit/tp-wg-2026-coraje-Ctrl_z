
import wollok.game.*
import objetos.*

class Habitacion { 
    var property fondo  = "habitacion1.jpeg"
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
        game.boardGround("habitacion.png")

    objetos.filter({ objeto => objeto.puedeMostrarse() })
        .forEach({ objeto => game.addVisual(objeto) })
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

    const habitacion3 = new Habitacion(
        posicionInicial = game.at(1, 1) 
    )

    method preparar() {
        self.prepararHabitacion1()
        self.prepararHabitacion2()
        self.prepararHabitacion3()
    }

    method prepararHabitacion1() {
        habitacion1.agregarBordes() 
        

        const mate = new Item(
            nombre = "mate",
            image = "mate.png",
            position = game.at(5, 5)
        )

        const riquelme = new NPC(
            itemDeseado = mate,
            image = "riquelme.png",
            position = game.at(8, 8)
        )

        const puerta = new Puerta(
            position = game.at(13, 7),
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


        const papel = new Item(nombre = "papel", image = "papel.png", position = game.at(2, 2))
        const tinta = new Item(nombre = "tinta", image = "tinta.png", position = game.at(4, 2))

        const fotoDeMessi = new Item(
            nombre = "foto de messi",
            image = "foto_messi.png",
            position = game.at(5, 5)
        )

        const impresora = new Impresora(
            position = game.at(5, 5),
            papel = papel,
            tinta = tinta,
            itemImpreso = fotoDeMessi
        )
        const llaveArmario = new Item(
            nombre = "llave de armario",
            image = "llave.png",
            position = game.at(8, 7)
        )

        const dePaul = new NPCConRecompensa(
            itemDeseado = fotoDeMessi,
            image = "depaul.png",
            position = game.at(8, 8),
            itemRecompensa = llaveArmario,
            habitacion = habitacion2,
            mensajeAgradecimiento = "¡Qué grande el Capitán! Te dejo la llave acá al lado."
        )

        const armario = new Armario(
            position = game.at(2, 8),
            llave = llaveArmario
        )

        const puerta2 = new Puerta(
            position = game.at(13, 7),
            npcsCondicion = [dePaul],
            habitacionActual = habitacion2,
            siguienteHabitacion = habitacion3
        )

        habitacion2.agregarObjeto(papel)
        habitacion2.agregarObjeto(tinta)
        habitacion2.agregarObjeto(impresora)
        habitacion2.agregarObjeto(dePaul)
        habitacion2.agregarObjeto(armario)
        habitacion2.agregarObjeto(puerta2)
    }
    
    method prepararHabitacion3() {
        habitacion3.agregarBordes()
        const chiquiTapia = new NPCJefe(
            itemDeseado = uniformeSancor,
            image = "chiqui.png", 
            position = game.at(7, 7),
            mensajeEspera = "¡que haces aca pibe, vos no te quejaste de mi idea del SupermegaCampeonDeCampeones?",
            mensajeAgradecimiento = "¡sos mi Confiable amigo de Sancor Seguros podes pasar!",
            mensajeSatisfecho = "¡todavia seguis aca ? anda rapido a preparar otro show de drones!"
        )

        const puertaFinal = new Puerta(
            position = game.at(13, 7),
            npcsCondicion = [chiquiTapia],
            habitacionActual = habitacion3,
            siguienteHabitacion = null
        )

        habitacion3.agregarObjeto(chiquiTapia)
        habitacion3.agregarObjeto(puertaFinal)
    }

    method iniciar() {
        self.preparar()
        habitacion1.cargar()
        player.position(habitacion1.posicionInicial())
    }
}
