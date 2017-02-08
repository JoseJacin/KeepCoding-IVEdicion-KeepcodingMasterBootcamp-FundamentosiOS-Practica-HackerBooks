#Preguntas

##JSONProcessing: ¿En qué otros modos podemos trabajar a parte de *type (of: )*? ¿is, as?En la aplicación he utilizado una clave para comprobar si la aplicación se ha ejecutado con anterioridad, de esta forma se evita que se descargue de nuevo cada vez que se inicia la aplicación.

Seguro que hay formas más óptimas de realizar el manejo, pero la que he implementado es la que mejor conocía.##¿Dónde guardarías los datos como el JSON con los libros, las imágenes de portada y los archivos PDF? En este caso creo que lo más recomendable sería guardar esta información en el directorio de la aplicación para que, por ejemplo en el caso de que haya problemas con la memoria, el sistema pueda eliminarlos o tomar las medidas que crea oportunas.##¿Cómo guardaste la información de isFavoriteCómo consiguió almacenar la propiedad *isFavorite* de cada libro? ¿Conoces otras alternativas? Al contrario que en el caso de otro tipo de ficheros, esta información, al ser importante para el usuario, es preciso que el sistema no realice el borrado de los mismos en el caso en que haya problemas de rendimiento a causa de la memoria, por lo que lo recomendable es almacenar dicha información en UserDefaults. De esta forma se consigue persistir dicha información y que esté disponible en posteriores ejecuciones de la aplicación. Además, esta información es lo suficientemente pequeña como para que no suponga un riesgo en la memoria
##¿Cómo enviaste la información del Libro al *LibraryViewController*? ¿Conoces otras alternativas? El método que he usado ha sido mediante el patrón *Delegate*, haciendo al *LibraryTableViewController* el delegado de *BookViewController*.

En cuanto a posibles alternativas, dado de la clase *Book* no pertenece a *LibraryTableViewController* dicha información no se podría enviar mediante, por ejemplo *Target/Action*


##¿Por qué no es una mala opción usar el método *reloadData* de *UITableView*? ¿Hay una forma alternativa? ¿Cuándro crees que vale la pena usarlo?Las operaciones que más recursos consumen son las de descarga de datos tales como imágenes, vídeos, pdf, ... En cambio, una vez ya se han descargado, tan solo hay que cargarlos en la tabla desde la caché de la aplicación con *reloadData*.

Otra alternativa sería extender el método reloadData para que solo recargue la celda en cuestión, pero dado que es un método relativamente complicado no sería necesaria su implementación a no ser que sea extrictamente necesario.
Una segunda alternativa sería controlar las celdas que se están mostrando en el momento y solo recargar dichas celdas.##¿Cómo cambiaste el PDF del *PDFReaderViewController* cuando el usuario cambió el libro actual en el *LibraryTableViewController*?He utilizado las notificaciones, ya que *LibraryTableViewController* ya tiene asignado como delegado *BookViewController* para controlar cuándo se cambia un libro, y no es posible modificar el PDF mediante *Target/Action*.El procedimiento que se realiza cuando se cambia un libro es que *LibraryTableViewController* publica una notificación con el libro adjunto. Por otro lado, el *PDFReaderViewController* se suscribe a la notificación cada vez que se encuentra visible y se da de baja de la misma cuando ya no es visible, de esta forma, si el *PDFReaderViewController* se encuentra visible estará suscrito a la notificación, por lo que recibirá dicha notificación y volverá a cargar el *UIWebView* con el URL del nuevo libro PDF que ha llegado con la notificación.--
# Extras## a. ¿Qué funcionalidades le añadirías antes de subirla a la App Store?
Tal y como se encuentra actualmente la aplicación, es susceptible de diversas mejoras:

* Como toda aplicación que muestra una gran cantidad de datos, sería recomendable que tenga un filtro personalizado, que permita filtrar por varios valores, como por el título, los autores, etiquetas (una o varias), valoraciones (estrellas), ... * Permitir valorar los libros de una forma similar a como se realiza actualmente en la App música mediante cinco estrellas.
* Permitir que los libros se puedan añadir a listas personalizadas (se puede acceder a esta funcionalidad desde un gesto Swipe o desde el detalle del libro.
* Permitir que se pueda hacer favorito mediante el gesto Swipe
* Permitir a los usuarios tomar agregar marcadores o tomar notas sobre el libro
* Permitir hacerse usuario para poder usar una función social como por ejemplo poder realizar comentarios, recomendar libros, seguir a otros usuarios, ver qué han leído o qué están leyendo, gustos, ...
* Permitir continuidad (previo pago ya que sería una función premium) para que favoritos, marcadores, notas, preferencias, se sincronicen en todos los dispositivos en los que se loguee el usuario en cualquier momento, es decir (continuidad)
* Permitir la lectura de otros formatos de libro, permitiendo de esta forma, poder modificar preferencias como el tipo o tamaño de letra, fondo, ...
## b. ¿Qué otras versiones se te ocurren?El diseño de la aplicación es fácilmente adaptable para mostrar una gran coleccon de elementos que se encuentren en una base de datos. Actualmente (previa modificación del modelo y la modificación o ajustes de algunas funcionalidades), podría adaptarse para ser una galería de arte en la que se puede ver el título, autor, tags y la imagen de la obra. También permitiría abrir Wikipedia, y realizar pinch&zoom para ampliar la imagen de la misma.
## c. ¿Cómo podrías monetizar con HackerBooks? Algunas funciones con las que se podría obtener benefício son:

* Acceso a libros premium. Previo pago, se permitiría acceder a libros Premium (Lanzamientos, Best Seller, ...). Si no se paga, se tendría una especie de demostración en la que solo se pueda ver el principio del mismo.
* Descarga de los libros para poder verlos sin conexión
* Continuidad, es decir, poder tener la misma información (favoritos, marcadores, notas, preferencias, ...)
