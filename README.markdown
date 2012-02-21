Juan Pedro Paredes Caballero <juampe@iquis.com>
Distribuir con licencia GPL.

jabato es un sistema de monitorización que pretende:
	Sondear de manera eficaz una serie de hosts.
	Usar diferentes metodos de sondeo (agente, script, snmp, ...).
	Emplear un Sistema de agentes con memoria de estado.
	Aprovechar al maximo la informacion obtenida del sondeo.
	Provocar alarmas de acuerdo al estado de los parametros sondeados.
	Correlacionar alarmas estableciendo jerarquias.
	Generar excepciones para una determinada alarma.
	Generar informacion histórica y gráfica de todos los parametros.

Sondear de manera eficaz una serie de hosts.
	Jabato utiliza collector para sondear una serie de hosts.
	Collector recoge la información de recolección de una tabla 
	de la base de datos (cmds) al arrancar y con la señal HUP.
	Los comandos (cmds) tienen un especificación tipo url donde se
	especifica que método de recolección hay que utilizar para ese comando
	y que parametros se necesitan para su ejecución correcta.
	Collector implementa ditcron (Dispersal-In-Time cron)
	El sondeo se dispersa en el tiempo aleatoriamente
	Por ejemplo, consideremos la ejecucion de C1 y C2 cada 5 minutos (step)
	y C3 cada 10.
	
	Un cron cásico funciona tal que así:
	TIME   0. . . .5. . . .10. . . 15. . . 20
	C1     *       *       *       *       *	T+0
	C2     *       *       *       *       *	T+0
	C3     *               *               *	T+0
	CARGA  30000000200000003000000020000000300000
	
	La carga máxima es 3 y la media por ejecución 2
	
 	Un cron disperso en el tiempo funciona tal que así
	TIME   0       5       10      15      20	Dispersión
	C1      *       *       *       *       *	T+1
	C2         *       *       *       *       *	T+4
	C3        *               *               *	T+3
	CARGA  01011000010010000101100001001000010110
	
	La carga maxima es 1 y la media por ejecución 1
	
	Se ha diseñado de esta forma para que la carga de la maquina de sondeo
	sea lo mas estable posible y asegurar por distribución de carga la
	ejecución del comando.
	
	Se tiene en en cuenta el stamp (timestamp) de ejecucion de un comando
	para su proxima ejecución.
	
	La forma de proceder de collector es, respecto a un segundo concreto,
	revisar la estructura de comandos y steps, si el stamp actual modulo 
	step es 0, entoces procedera a su ejecución (fork), huelga decir que 
	todavia	pueden quedar  pendientes entradas por revisar.Si la revision 
	de la estructura de comandos y steps, y los forks relacionados 
	dura mas de 1 segundo (stamp actual) el comando no se ejecutará
	(con sitecheck SI se ejecutará). La revisión de la estructura es O(n).

	Para asegurar mas la ejecución una vez decidido en que momento ha de
	ejecutarse collector implementa sitecheck (Shift-In-Time-Execution 
	check)
	La tecnica de comprobación desplazada, no fuerza al comando a ejecutarse
	en un determinado segundo, sino que examina un espacio temporal
	denominado shift.Por Ejemplo siendo T un timestamp de un comando:
	Con cron se mira si T corresponde al time actual
	Con ditcron se mira si T+random corresponde al time actual
	Con ditcron y sitecheck se mira si el time actual esta en
	el rango T+random+shift y T+random-shift
	
	El shift por defecto es 60 segundos.
	Si la maquina de sondeo esta realmenta cargada collector decidira
	relegar la ejecucion a 120 segundos como maximo, luego si la carga 
	continua decidirá no ejecutar el comando.
	La filosofía es "si se puede ejecutar se ejecuta en un tiempo razonable,
	sino dejará que la maquina se recupere"


	Formalizando
	Siendo un proceso que debe ejecutrar cada cierto numero de segundos.
	Siendo step el numero de segundos que se debe repetir la ejecución
	de un proceso.
	Siendo time el tiempo actual en segundos.
	Definimos r:
		r=time%step
	Obtememos una variable r que varia con el tiempo en el rango:
		[0-(step-1)]
	Tomaremos r como tiempo ciclico relativo a su step.
	Siendo rnd un numero aleatorio en el rango:
		[0-(step-1)]
	Tomaremos rnd como desplazamiento aleatorio en el tiempo.
	Definimos la funcion distacia d:
		d=min(|rnd-r|,min(rnd,r)+|max(rnd,r)-step|))
	Obtememos una variable d que varia con el tiempo en el rango:
		[0-(step/2)]
	Siendo last la fecha de la ultima ejecucion.
	Siendo shift el desplazamiento aceptable de ejecucion:
	Obtememos un rango temporal absoluto:
		[(time+shift)-(time-shift)]
	Usando r obtenemos un rango temporal relativo:
		[(r+shift)-(r-shift)]
		
	La ejecucion se realizara cuando:
		last+(shift*2)+1 < time and d<=shift
	
	Podemos ver su comportamiento en esta gráfica:
	
	. d
	- shift = 3
	X ejecución
	step = 20, rnd=6, last=0

                  1111111111          11111
      r 01234567890123456789012345678901234
   d    |   .                   .
   	|  . .                 . .
        | .   .    last=11    .   .    last=31
        |.     .             .     .
        .       .           .       .
	|        .         .         .  
        |         .       .           .
	|----------X-----.-------------X---
	|           .   .               .
	|            . .                 .
	--------------.-------------------.>
	time       |<-------step------>|
		   |<--->| shift*2+1
		      ^ d=0
	
	Otro objetivo de diseño es utilizar el step para luego alimentar
	los parametros recolectados a RRDTool, que necesita datos cada
	cierto tiempo.
	
	TODO	Ejecución a una hora concreta

Usar diferentes metodos de sondeo (agente, script, snmp, ...).
	El esquema general de cmd tipo xml es el siguiente
	<pull>
		<type></type>
		<step></step>
		<params>
			<param>
				<name></name>
				<id></id>
				<min></max>
			</param>
		. . .
		</params>
		<hosts>
			<host>
				<params>
					<param>
						<name></name>
						<id></id>
						<min></min>
						<max></max>
						<sev></sev>
						<ttl></ttl>
						<class></class>
						<msg></msg>
						. . .
					</param>
					. . . 
				</params>
			</host>
			. . .
		</hosts>
	</pull>
	
	Los tipos de cmds tipo url son los siguientes:
	
		snmp://host@community/name1=oid1(min,max,sev,ttl,class,msg)&name2=oid2 ... :step
			SNMPget al host@community
			nameX referencia del OID para el retorno
			oidX OID del parametro a recoger
			Alarmas (opcional)
			min es el valor minimo que debe tener el parametro
			max es el valor maximo que debe tener el parametro
			sev es la severidad
			ttl es la duración de la alarma (-1 permanete)
			msg es el mensaje informativo de la alarma
			Ejecucion cada step segundos
		agent://agent/param1=data1&param2=data2 ... :step
			Agente jabato hecho en perl
			agent nombre del agente
			paramX nombre de los paramtros
			dataX parametros
			Retorno
			El agente retorna una cadena tipo
			#name1=value1&name2=value2...
			Alarmas
			El agente retorna una cadena tipo
			#!name1=value1:sys:sev:ttl:class:msg&...
		script://script/param1=data1&param2=data2...:step
			Script o ejecutable hecho en cualquier lenguaje
			script nombre del script o comando
			paramX nombre de los paramtros
			dataX parametros
			Retorno
			El script retorna una cadena tipo
			#name1=value1&name2=value2...
			Alarmas
			El script retorna una cadena tipo
			#!name1=value1:sys:sev:ttl:class:msg&...
		
	Veamos un ejemplo:
		agent://fs/hosts=ac0,ac1,ac2,ac3:900
	Utiliza el agente fs (filesystem remoto por rcmd agents/fs) 
	cada 900 segundos; espera que se le pase el parametro hosts
	con una lista de hosts para sondear (ac0,ac1,ac2,ac3)
	Por motivos de depuración, si exite el fichero agents/fs.cfg tomará
	los parametros de este fichero e ignorará los pasados por url.

	Para que los agentes puedan utilizar ssh para el metodo rcmd
	hay que depositar la clave privada ssh "id_dsa" en el directorio ssh. 
	La clave publica debera estar introducida en el authorized_keys de las
	maquinas a sondear.

Emplear un sistema de agentes con memoria de estado.
	El sistema de agentes de jabato esta basado en el esquema computacional
	clásico entrada de parametros, cálculo respecto a un estado y salida.
	Los agentes son scripts que se van a ejecutar para varios hosts y
	deben ser realizados en perl.
	Estos van a residir en el directorio agents.
	El ejecutable agent se encarga de poner el entorno adecuado
	y llamar al agente
	La entrada de parametros para el agente le llega por
	el hash %param, un parametro puete tener varios valores estos
	estaran separados por comas.
	Los parametros se recogen de la base de datos de la tabla cmds, si
	el fichero agent.cfg existe se utilizan los parametros que se indiquen
	(esto es para depurar agentes).
	El proceso de cálculo depende de lo que se quiera hacer
	primero sondear un host y luego comparar los parametros con valores
	estables para decidir si lanzar una alarma o no.
	A veces es necesario saber el valor historico de un parametros
	para procesar su evolucion, para ello necesitamos guardar el estado.
	El hash %static es restaurado desde la ultima ejecucion (agent.stc), 
	permite guardar variables entre ejecuciones.
	La salida se realiza por la cadena $oparam, que se encarga
	de hacer saber los parametros recolectados y si hay alguna alarma
	para algun parámetro
	
Aprovechar al maximo la informacion recolectada.
	Según cual sea el método de recolección la información de los parametros
	recogidas sera guardada en una base de datos round robin, de manera que 
	podemos llevar una evolución de un determinado parametro a lo largo del 	tiempo. Para generar las bases de datos se utiliza rrdtool y las bases
	de datos se guardan en rrd cada una con su id de parámetro
	
Generar alarmas de acuerdo al estado de los parametros recogidos
	Los métodos de sondeo llevan un mecanismo de generación de alarmas.
	Las alarmas pueden llevar unos niveles de gravedad y asociar
	cierta severidad.
	
Correlacionar alarmas estableciendo jerarquias.
	Usar un correlacionador de alarmas que descarte alarmas mas severas
	si por ejemplo falla la conectividad

Generar excepciones para una determinada alarma.
	Dependiendo de la alarma generada puede que nos interese realizar
	cierta accion. 
	
Generar informacion historica y grafica de todos los parametros recogidos.
	Teniendo una base de daros rrd para cda parámetro podemos generar
	graficas atendiendo a varios parámetros a la vez
	
Generar informes
	Generacion de informes gráficaos a partir de la sbases de datos rrd
	se pueden mezclar heterogeneamente todo tipo de parámetros para
        observar evoluciones conjuntas; por ejemplo espacio de memoria 
	disponible y contrastar con accesos a una aplicacion web.

