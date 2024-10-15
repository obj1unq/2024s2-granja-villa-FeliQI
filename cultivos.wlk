import wollok.game.*



class Maiz {
	const property position = null
	var property esAdulta = false

	method position() {
		return position
	}
	method image() {
		return "corn_" + self.imagenEtapa() + ".png"
	}

	method imagenEtapa() {
		return if(esAdulta) {
			"adult"
		} else "baby"
	}

	method serRegado(terreno) {
		esAdulta = true
	}

	method estaCosechable() {
		return esAdulta
	}

	method serCosechado() {
		game.removeVisual(self)
	}

	method valor() {
		return 150
	}

}

class Trigo {
	var property etapa = 0
	const property position = null

	method image() {
		return "wheat_" + etapa + ".png"
	}

	method serRegado(terreno) {
		etapa = self.siguienteEtapa()
	}

	method siguienteEtapa() {
		return (etapa + 1).min(3)
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

}

class Tomaco {
	var property position = null

	method image() {
		return "tomaco_baby.png"
	}

	method puedeMover(terreno) {
		const nuevaPosicion = position.up(1)
		return not terreno.hayPlantaAqui(nuevaPosicion) and
			   nuevaPosicion.y() < game.height()
		
	}

	method serRegado(terreno) {
		if(self.puedeMover(terreno)){
			position = position.up(1)
		}
		
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

}
