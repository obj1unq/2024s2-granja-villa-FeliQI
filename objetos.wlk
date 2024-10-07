import cultivos.*
import hector.*
import wollok.game.*


object granja {
	const property cultivosSembrados = []

	method registrarSembrado(cultivo) {
		cultivosSembrados.add(cultivo)
	}

	method hayUnaPlantaAqui(position) {
		return cultivosSembrados.any({cosa => cosa.position().equals(position)})
	}

	method cultivoQueEstaAqui(position) {
		return cultivosSembrados.find({cosa => cosa.position().equals(position)})
	}

	method cultivosAlrededorDe(position) {
		return cultivosSembrados.filter({cosa => cosa.estaEnPosicion(position)})
	}

	method hayUnaPlantaArriba(position) {
		return cultivosSembrados.any({cosa => (cosa.position().y()).equals(position.y()+1) and 
											  (cosa.position().x()).equals(position.x())})
	}
}


/*class Mercado {
    var fondos = null
    const property mercaderia = []
    var property position = null

    method comprar(mercaderia) {

    }
}*/

class Aspersor {
	var property position = null
	const terreno = granja
	const property image = "aspersor.png"

	method empezarARegar() {
		game.onTick(1000, self, {self.regar()})
	}

	method regar() {
		terreno.cultivosAlrededorDe(position).forEach({cosa => cosa.serRegado(terreno)})
	}

}