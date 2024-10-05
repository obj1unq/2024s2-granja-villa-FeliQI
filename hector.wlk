import wollok.game.*
import cultivos.*
import objetos.*

// Me quede despierto toda la noche, no funciona nada, me rindo Isa :(

object hector {
	var property position = game.origin()
	const property image = "player.png"
	const property terreno = granja
	const cultivosAlmacenados = []
	var ahorros = 0

	method validarSembrar(cultivo) {
		if(terreno.hayUnaPlantaAqui(position)){
			self.error("Ya hay un cultivo sembrado en esta parcela")
		}
	}

	method sembrar(cultivo) {
		self.validarSembrar(cultivo)
		terreno.registrarSembrado(cultivo)
		game.addVisual(cultivo)
	}

	method validarRegar() {
		if(not terreno.hayUnaPlantaAqui(position)){
			self.error("no tengo nada para regar")
		}
	}

	method regar() {
		self.validarRegar()
		terreno.cultivoQueEstaAqui(position).serRegado(terreno)
	}

	method validarCosechar() {
		if(not terreno.hayUnaPlantaAqui(position) or 
		not terreno.cultivoQueEstaAqui(position).estaCosechable()){
			self.error("No se puede cosechar en esta parcela")
		}
	}

	method cosechar() {
		self.validarCosechar()
		self.almacenarCultivo()
		terreno.cultivoQueEstaAqui().serCosechado()
		
	}

	method almacenarCultivo() {
		cultivosAlmacenados.add(terreno.cultivoQueEstaAqui())
	}

	method vender() {
		ahorros += cultivosAlmacenados.sum({cosa => cosa.valor()})
		cultivosAlmacenados.removeAll()
	}

	method contarBienes() {
		game.say(self, "Tengo " + ahorros + " monedas, y " +
		cultivosAlmacenados.size() + " plantas para vender")
	}

	method colocarAspersor() {
		const aspersor = new Aspersor(position = position)
		game.addVisual(aspersor)
	}

	method verificarMercado() {

	}

	method venderMercaderia() {
		self.verificarMercado()
		

	}
}

