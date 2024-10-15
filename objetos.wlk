import cultivos.*
import hector.*
import wollok.game.*


object granja {
	const property cultivosSembrados = []
	const property aspersores = #{}
	const property mercados = #{}

	method registrarSembrado(cultivo) {
		cultivosSembrados.add(cultivo)
	}

	method hayPlantaAqui(position) {
		return cultivosSembrados.any({cosa => cosa.position().equals(position)})
	}

	method cultivoQueEstaAqui(position) {
		return cultivosSembrados.find({cosa => cosa.position().equals(position)})
	}

	method empezarARegar() {
		game.onTick(1000, self, {aspersores.forEach({cosa => cosa.regar()})})
	}

	method hayMercado(position) {
		return mercados.any({cosa => cosa.position() == position})
	}

	method mercadoAqui(position) {
		return mercados.find({cosa => cosa.position() == position})
	}

	method hayAspersor(position) {
		return aspersores.any({cosa => cosa.position() == position})
	}
}


class Mercado {
    var fondos = null
	const property image = "market.png"
    const property mercaderia = #{}
    var property position = null

    method comprarMercaderia(cliente) {
		self.restarFondos(cliente)
		mercaderia.addAll(cliente.cultivosAlmacenados())
    }

	method restarFondos(cliente) {
		fondos -= cliente.valorTotal()
	}

	method sumarFondos() {
		fondos += self.costoTotal()
	}

	method puedeComprar(valor) {
		return fondos > valor
	}

	method puedeVender() {
		return not mercaderia.isEmpty()
	}

	method costoTotal() {
		return mercaderia.sum({cosa => cosa.valor()})
	}

	method venderMercaderia() {
		self.sumarFondos()
		mercaderia.clear()
	}
}

class Aspersor {
	var property position = null
	const terreno = granja
	const property image = "aspersor.png"

	method estaCerca(cultivo) {
		return cultivo.position().x() <= (position.x() + 1) and
			   cultivo.position().x() >= (position.x() - 1) and
			   cultivo.position().y() <= (position.y() + 1) and
			   cultivo.position().y() >= (position.y() - 1)
	}

	method cultivosCercanos() {
		return terreno.cultivosSembrados().filter({cosa => self.estaCerca(cosa)})
	}

	method regar() {
		self.cultivosCercanos().forEach({cosa => cosa.serRegado(terreno)})
	}

}

object mercadoFactory {

	method construir(position) {
		return new Mercado(fondos = randomizer.fondos(), position = position)
	}

}

object mercadoAdmin {
	const terreno = granja
	const factory = mercadoFactory
	const creados = #{}

	method nuevoMercado() {
		if(self.hayEspacio()){
			const mercado = factory.construir(randomizer.position())
			creados.add(mercado)
			terreno.mercados().add(mercado)
			game.addVisual(mercado)
		}
		
	}

	method hayEspacio() {
		return creados.size() < 3
	}
}


object randomizer {

	method position() {
		return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(0 .. game.height() - 1 ).anyOne()
		) 
	}

	method fondos() {
		return (1000 .. 2000).anyOne()
	}
}