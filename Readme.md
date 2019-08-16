# Générateur pour le site de LABARHACK

## install
~~~
git clone 
cd ./labarhack
bundle install
~~~

## developpement
Les articles doivent être déposé dans sources/articles. Attention au meta-donnée, middleman utilise frontmatters..
puis lancer avec :

~~~
middleman serve
~~~

# construction du site
~~~
middleman build
~~~

Le site est généré dans le répertoire build
/!\ il faut paramétrer http-prefix.... dans config.rb




