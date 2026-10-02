import objetos.* 
import movimientos.* 
object configuracion {
  method configurarAcciones() {
    keyboard.up().onPressDo({ movimiento.mover(player, haciaArriba) })
    keyboard.down().onPressDo({ movimiento.mover(player, haciaAbajo) })
    keyboard.left().onPressDo({ movimiento.mover(player, haciaLaIzquierda) })
    keyboard.right().onPressDo({ movimiento.mover(player, haciaLaDerecha) })
  }
}