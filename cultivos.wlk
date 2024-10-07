import wollok.game.*



class Maiz {
	var property position = null
	var image = "corn_baby.png"

	method position() {
		return position
	}
	method image() {
		return image
	}

	method serRegado(terreno) {
		image = "corn_adult.png"
		game.removeVisual(self)
		game.addVisual(self)
	}

	method estaCosechable() {
		return image == "corn_adult.png"
	}

	method serCosechado() {
		game.removeVisual(self)
	}

	method valor() {
		return 150
	}

	method estaEnPosicion(positionAspersor) {
		return position.x() <= (positionAspersor.x() + 1) and
			   position.x() >= (positionAspersor.x() - 1) and
			   position.y() <= (positionAspersor.y() + 1) and
			   position.y() >= (positionAspersor.y() - 1)
	}

}

class Trigo {
	var property etapa = 0
	var property position = null
	var image = "wheat_" + etapa + ".png"

	method image() {
		return image
	}

	method serRegado(terreno) {
		etapa = (etapa + 1).min(3)
		image = "wheat_" + etapa + ".png"
		game.removeVisual(self)
		game.addVisual(self)
	}

	method estaCosechable() {
		return etapa >= 2
	}

	method serCosechado() {
		game.removeVisual(self)
	}

	method valor() {
		return (etapa - 1) * 100
	}

	method estaEnPosicion(positionAspersor) {
		return position.x() <= (positionAspersor.x() + 1) and
			   position.x() >= (positionAspersor.x() - 1) and
			   position.y() <= (positionAspersor.y() + 1) and
			   position.y() >= (positionAspersor.y() - 1)
	}
}

class Tomaco {
	var property position = null

	method image() {
		return "tomaco_baby.png"
	}

	method validarRegado(terreno) {
		if(terreno.hayUnaPlantaArriba(position)) {
			self.error("El tomaco no se puede regar ya que hay una planta
			en la posicion a la que se debe mover")
		}
	}

	method serRegado(terreno) {
		self.validarRegado(terreno)
		position = position.up(1)
	}

	method estaCosechable() {
		return true
	}

	method serCosechado() {
		game.removeVisual(self)
	}

	method valor() {
		return 80
	}

	method estaEnPosicion(positionAspersor) {
		return position.x() <= (positionAspersor.x() + 1) and
			   position.x() >= (positionAspersor.x() - 1) and
			   position.y() <= (positionAspersor.y() + 1) and
			   position.y() >= (positionAspersor.y() - 1)
	}
}
