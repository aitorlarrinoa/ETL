# - `\d`: digit
# - `\w`: word character
# - `\W`: non-word character
# - `\s`: whitespace

tweet = "No todo es R, así que estamos pensando en asistir a este meetup sobre Julia, de la mano de @RyanairLabs... o en mandar a @joscani como enviado especial. \
El evento es online, el 2021-09-16, cosa que facilita la asistencia. \
https://meetup.com/es-ES/Travel-Labs-Madrid/events/280438963/ \
#rstatsES #Julia"

print(tweet)

import re

# all mentions
re.findall(r'@\w+', tweet)

# + The `r` is recommendable when working with strings that include `'\'`.
# + The at symbol just represents the beginning of the user name --nothing to do with regex.
# + `\w` represents a letter.
# + `+` means that we want to look for the immediate previous character (the `\w` in this case) as many times as possible --we can find one letter, two, three...

# all hashtags
# me vas a interpretar este texto que viene después teniendo en cuenta los significados intrínsecos que tienen
# cada elemento

re.findall(r'\w+', tweet)
# con el + le digo: construyeme una lista cuyos elementos sean conjuntos ....

# todas las menciones
re.findall(r'@\w+', tweet)

# todos los hashtags
re.findall(r'#\w+', tweet)

re.findall(r'[A-za-z0-9#]+$', tweet)

# all urls
# trozos de texto que empiezan por http y después vienen: letras, números, dos puntos, punto, barra y guión
re.findall(r'http[A-z0-9:./\-]+', tweet)

# si quiero extraer solo la información hasta el dominio (hasta el .com)
re.findall(r'http[A-z0-9:./\-]+.com', tweet)


re.findall(r'\s[A-Z][a-z]*', tweet)

# valid passwords
#re.search() nos devuelve u True o un False
passwords = ['Apple34!rose', 'My87hou#4$', 'abc123']

regex = r"[A-Za-z0-9!#%&*\$\.]{8,20}" 
for example in passwords:
  	# Scan the strings to find a match
    if re.search(regex, example):
        # Complete the format method to print out the result
      	print("The password {pass_example} is a valid password".format(pass_example=example))
    else:
      	print("The password {pass_example} is invalid".format(pass_example=example))     
      	
      	
      	
# ¿Cómo puedo extraer las fechas?
# el {10} indica la longitud
re.findall(r'[0-9\-]{10}', tweet)
# 4 dígitos, luego 2 y luego otros 2 dígitos
re.findall(r'\d{4}\-\d{2}\-\d{2}', tweet)
