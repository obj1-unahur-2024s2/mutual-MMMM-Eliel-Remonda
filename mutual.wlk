class Actividad{
  const property idiomas = []
  var property dias
  method implicaEsfuerzo()
  method sirveParaBroncearse()
  method esInteresante(){
    return idiomas.size() > 1
  }
  method esRecomendada(unSocio){
    return self.esInteresante() and unSocio.leAtrae(self) and not unSocio.actividades().contains(self)
  }
}

class ViajeAPlaya inherits Actividad{
  const largoPlaya
  override method dias() = largoPlaya / 500

  override method sirveParaBroncearse() = true

  override method implicaEsfuerzo() = largoPlaya > 1200

  override method esInteresante(){
  
  }
}

class ExcursionACiudad inherits Actividad{
  var property cantAtracciones
  override method dias() = cantAtracciones / 2

  override method sirveParaBroncearse() = false

  override method implicaEsfuerzo() = cantAtracciones.between(5, 8)

  override method esInteresante(){
    return super() or cantAtracciones == 5

  }
}

class ExcursioACiudadTropital inherits ExcursionACiudad{
  override method dias() = super() + 1
  override method sirveParaBroncearse() = true
}

class SalidaDeTrekking inherits Actividad{
  const kilometros
  const diasDeSol

  override method dias() = kilometros / 50
  override method implicaEsfuerzo() = kilometros > 80
  override method sirveParaBroncearse() = diasDeSol > 200 or 
    (diasDeSol.between(100, 200) and kilometros > 120)

  override method esInteresante(){
    return super() and diasDeSol > 140
  }
}

class ClasesDeGimnacia inherits Actividad{
  method initialize(){
    idiomas.clear()
    idiomas.add("español")
  
  }
  override method dias() = 1
  override method implicaEsfuerzo() = true
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio){
    return unSocio.edad().between(20, 30)
  }
}

class TallerLiterario inherits Actividad{
  const property libros = []
  method idiomasUsados(){
    return libros.map({l => l.indioma()})
  }
  override method dias() = libros.size() > 1
  override method implicaEsfuerzo(){
    return libros.any({l => l.cantPaginas() > 500}) or 
    (libros.size() > 1 and libros.map({ l => l.nombreAutor().asSet().size() == 1}))
  }
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio){
    return unSocio.idiomas().size() > 1
  }
}

class Libro{
  const property idioma
  const property cantPaginas
  const property nombreAutor  
}

class Socio{
  var edad
  const property idiomas = []
  const property actividades = []
  const maximoActividad

  method cumplirAnios(){
    edad += 1
  }
  method edad() = edad
  method esAdoradorDelSol(){
    return actividades.all({a => a.sirveParaBroncearse()})
  }
  method activiadesForzadas(){
    return actividades.filter({a => a.implicaEsfuerzo()})
  }

  method registrarActividad(unaActividad){
    if (actividades.size() == maximoActividad){
      self.error("cantidad maxima de actividades alcanzada")
    }
    actividades.add(unaActividad)
  }
  method leAtrae(unaActividad)
}

class SocioTranquilo inherits Socio{
  override method leAtrae(unaActividad){
    maximoActividad >= 4
  }
}

class SocioCoherente inherits Socio{
  override method leAtrae(unaActividad){
    return if (self.esAdoradorDelSol()){
      unaActividad.sirveParaBroncearse()}
    else{ unaActividad.implicaEsfuerzo()}
  }
}

class SocioRelajado inherits Socio{
  override method leAtrae(unaActividad){
    return not idiomas.intersectio(unaActividad.idiomas()).isEmpty()
  }
}