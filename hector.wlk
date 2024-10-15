import wollok.game.*
import cultivos.*
import objetos.*
import posiciones.*

object hector {
	var property position = game.origin()
	const property image = "player.png"
	const terreno = granja
	const property cultivosAlmacenados = []
	var property ahorros = 0

	method mover(direccion) {
		if(direccion.esValida(position)){
			position = direccion.siguiente(position)
		}
		
	}

	method validarSembrar(cultivo) {
		if(terreno.hayPlantaAqui(position)){
			self.error("Ya hay un cultivo sembrado en esta parcela")
		}
	}

	method sembrar(cultivo) {
		self.validarSembrar(cultivo)
		terreno.registrarSembrado(cultivo)
		game.addVisual(cultivo)
	}

	method validarRegar() {
		if(not terreno.hayPlantaAqui(position)){
			self.error("no tengo nada para regar")
		}
	}

	method regar() {
		self.validarRegar()
		terreno.cultivoQueEstaAqui(position).serRegado(terreno)
	}

	method validarCosechar() {
		if(not terreno.hayPlantaAqui(position) or 
		not terreno.cultivoQueEstaAqui(position).estaCosechable()){
			self.error("No se puede cosechar en esta parcela")
		}
	}

	method cosechar() {
		self.validarCosechar()
		self.almacenarCultivo()
		terreno.cultivoQueEstaAqui(position).serCosechado()
		self.quitarDeGranja()
	}

	method quitarDeGranja() {
		terreno.cultivosSembrados().remove(terreno.cultivoQueEstaAqui(position))
	}

	method almacenarCultivo() {
		cultivosAlmacenados.add(terreno.cultivoQueEstaAqui(position))
	}

	method vender() {
		if(self.puedoVender()){
			ahorros += self.valorTotal()
			terreno.mercadoAqui(position).comprarMercaderia(self)
			cultivosAlmacenados.clear()
		} 
	
		else game.say(terreno.mercadoAqui(position), "No puede vender aqui")
		
		
	}

	method contarBienes() {
		game.say(self, "Tengo " + ahorros + " monedas, y " +
		cultivosAlmacenados.size() + " plantas para vender")
	}

	method colocarAspersor() {
		if(not terreno.hayAspersor(position)){
			const aspersor = new Aspersor(position = position)
			game.addVisual(aspersor)
			terreno.aspersores().add(aspersor)
		}
	}

	method valorTotal() {
		return cultivosAlmacenados.sum({cosa => cosa.valor()})
	}

	method puedoVender() {
		return terreno.hayMercado(position) and
		terreno.mercadoAqui(position).puedeComprar(self.valorTotal()) and 
		not cultivosAlmacenados.isEmpty()
	}

	method puedoComprar() {
		return terreno.hayMercado(position) and
			   terreno.mercadoAqui(position).puedeVender() and
			   self.tengoAhorros()
	}

	method tengoAhorros() {
		return ahorros >= terreno.mercadoAqui(position).costoTotal()
	}

	method comprar() {
		if(self.puedoComprar()) {
			cultivosAlmacenados.addAll(terreno.mercadoAqui(position).mercaderia())
			self.gastarAhorros()
			terreno.mercadoAqui(position).venderMercaderia()
		} 
		
		else game.say(self, "No puedo comprar aqui")
		
	}

	method gastarAhorros() {
		ahorros -= terreno.mercadoAqui(position).costoTotal()
	}

}

