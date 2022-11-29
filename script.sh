
#!/bin/bash
RESPOSTA=5 

# update / upgrade
fazerUpdate(){
  sudo apt update && sudo apt upgrade
}

instalarDocker() {

  sudo apt install docker.io -y
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo docker pull mysql:8.0
  sudo docker run -d -p 3306:3306 --name MagnaDB -e "MYSQL_DATABASE=magna" -e "MYSQL_ROOT_PASSWORD=magna123" mysql:8.0
  sudo docker exec -it MagnaDB bash mysql -u root -p -B -N -e"

  create dabatase magna;
  use magna;

  CREATE TABLE Empresa (
    id_empresa int primary key auto_increment,
    nome_empresa varchar(50),
    CNPJ char(14),
    telefone varchar(20)
  );

  CREATE TABLE Servidor (
    id_servidor int primary key auto_increment,
    fk_empresa int,
    foreign key (fk_empresa) references Empresa (id_empresa),
    qtd_nucleos_fisicos int,
    qtd_nucleos_logicos int,
    max_utilizacao_cpu double,
    max_utilizacao_ram double,
    total_armazenamento_disco1 bigint,
    total_armazenamento_disco2 bigint,
    total_armazenamento_disco3 bigint,
    total_armazenamento_disco4 bigint,
    Cidade varchar(100)
  );

  CREATE TABLE RegistroServer (
    id_registro int primary key auto_increment,
    fk_servidor int,
    foreign key (fk_servidor) references Servidor (id_servidor),
    qtd_processos int,
    qtd_threads int,
    cpu_em_uso double,
    ram_em_uso bigint,
    disco_em_uso_1 bigint,
    disco_em_uso_2 bigint,
    disco_em_uso_3 bigint,
    disco_em_uso_4 bigint,
    dt_registro datetime
  );

  CREATE TABLE Usuario (
    id_usuario int primary key auto_increment,
    fk_empresa int,
    foreign key (fk_empresa) references Empresa(id_empresa),
    nome_usuario varchar(50),
    email varchar(50),
    senha varchar(50),
    primeiro_acesso tinyint,
    acesso_ao_swing tinyint
  );"
}

# verificando versão do java
verificarVersao() {
  VERSION="$(java -version 2>&1 | grep version | cut -d '"' -f2)"
  if [ $VERSION ];
  then
    echo "Cliente possui java instalado: {$VERSION}"
  else
    echo "Cliente não possui java instalado"
  fi
}


# baixando o java

baixarJava() {
  java -version
  if [ $? -eq 0 ];
    then 
      echo "O Java está instalado instalado"
    else 
      echo "Você não possui o Java"
      echo "Deseja instala-lo? (s/n)"
      read inst
    if [ \”$inst\” == \”s\” ];
      then sudo apt install default-jre -y
    fi  
  fi
}

# baixando jar 
baixarJar() {
  git clone https://github.com/Magna-Security/backend-swing.git 
  
  
}

executarJar() {
  cd backend-swing

    git checkout dev

    # entrando nas pastas
    cd data-colector/target

    # executando o java
    java -jar data-colector-1.0-SNAPSHOT-jar-with-dependencies.jar
}




while [ $RESPOSTA -ne "0" ]; do
  echo
  echo "======================================"
  echo "1 - Versão do Java                   |"
  echo "2 - Instalar o Java                  |"
  echo "3 - Baixar Jar                       |"
  echo "4 - Fazer um update                  |"
  echo "5 - Instalar o Docker                |"
  echo "6 - Executar o Jar                   |"
  echo "0 - Sair                             |"
  echo "======================================"
  read RESPOSTA
  echo ""

  
  if [ $RESPOSTA -eq 1 ]
  then
    verificarVersao
  elif [ $RESPOSTA -eq "2" ] 
    then baixarJava
  elif [ $RESPOSTA -eq "3" ] 
    then baixarJar
  elif [ $RESPOSTA -eq "4" ] 
  then fazerUpdate
  elif [ $RESPOSTA -eq "5" ]
  then 
    instalarDocker
  elif [ $RESPOSTA -eq "6" ]
  then executarJar
  elif [ $RESPOSTA -eq "0" ] 
  then
    echo "Saindo"
    exit
  else
    echo "Valor inválido"
  fi
done

