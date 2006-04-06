Para que jabato puede funcionar es necesario el siguiente software
apache
libapache-mod-perl
mysql-client
perl
librrds-perl
libapache-dbi-perl
libxml-sablot-perl

Creamos la base de datos
mysqadmin create jabato
Usa el sigiente comando para dar permisos al usuario jabato en la base de
datos jabato para localhost, usando un password
mysql_setpermission
mysql jabato < jabato.sql

Entrar en el directorio donde hemos instalado jabato (/opt/jabato por ej)
./setup
con esto configuramos el acceso a base de datos
Para el interfaz web si hemos cambiado el directorio /opt/jabato
hay que actualizar apache.conf al nuevo path luego
cp apache.conf /etc/apache/conf.d/jabato.conf


