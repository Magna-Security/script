#!/bin/bash
echo "Bem vindo ao Instalador do Magna :)"
    sleep 3
echo "Vamos começar ?"

echo "Antes de tudo, vamos adicionar uma senha padrão!"
sudo passwd ubuntu

    sleep 5
echo "Primeiro, vamos fazer algumas atualizações..."
sudo apt update && sudo apt upgrade 

echo "Gostaria de instalar uma interface gráfica ? (s/n)"
read inst
if [ \"$inst\" == \"s\" ];
then
sudo apt-get install xrdp lxde-core lxde tigervnc-standalone-server -y
else 
    sleep 5
echo "Certo, vamos continuar!"
fi

    sleep 3
echo "Vamos fazer a instalação dos containers!"

sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull mysql:8.0
sudo docker run -d -p 3306:3306 --name AnimixDocker -e "MYSQL_DATABASE=magna" -e "MYSQL_ROOT_PASSWORD=trigo1102" mysql:8.0
sudo docker exec -it AnimixDocker mysql --protocol tcp -u root -p -B -N -e "

    use magna;

CREATE TABLE IF NOT EXISTS Empresa (
    id_empresa int primary key auto_increment,
    nome_empresa varchar(50),
    CNPJ char(14),
    telefone varchar(20)
);



insert into Empresa values(null, 'Teste', '11111111111111', '11111111111');



CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario int primary key auto_increment,
    fk_empresa int,
    foreign key (fk_empresa) references Empresa (id_empresa),
    tipo_usuario varchar(50),
    constraint chk_tipoUsuario check (tipo_usuario in('gerente', 'tecnico', 'suporte')),
    nome_usuario varchar(50),
    email varchar(50),
    senha varchar(50),
    primeiro_acesso tinyint,
    acesso_ao_swing tinyint
);



insert into usuario (fk_empresa, tipo_usuario, nome_usuario, email, senha) values (1, 'gerente', 'Usuario Teste', '@.com', '123');



CREATE TABLE IF NOT EXISTS Servidor (
    id_servidor int primary key auto_increment,
    nome_servidor varchar(200),
    fk_empresa int,
    foreign key (fk_empresa) references Empresa (id_empresa),
    cidade varchar(100),
    qtd_nucleos_fisicos int,
    qtd_nucleos_logicos int,
    max_utilizacao_cpu decimal(10, 2),
    qtd_memoria_ram bigint,
    max_utilizacao_ram decimal(10, 2),
    total_armazenamento_disco_1 bigint,
    total_armazenamento_disco_2 bigint,
    total_armazenamento_disco_3 bigint,
    total_armazenamento_disco_4 bigint
);



insert into servidor values (null, 'Servidor Teste', 1, 'São Paulo', 4, 8, 80, 1000000000, 80, 8000000000, 8000000000, 8000000000, 8000000000);



CREATE TABLE IF NOT EXISTS RegistroServer (
    id_dado int primary key auto_increment,
    fk_servidor int,
    foreign key (fk_servidor) references Servidor (id_servidor),
    qtd_processos int,
    qtd_threads int,
    cpu_em_uso decimal(10, 2),
    ram_em_uso bigint,
    disco_em_uso_1 bigint,
    disco_em_uso_2 bigint,
    disco_em_uso_3 bigint,
    disco_em_uso_4 bigint,
    dt_registro datetime
);
"
echo "Agora, vamos instalar o Container que conterá o java para executar uma aplicação Animix :)"
    sleep 3

java -version
if [ $? -eq 0 ];
then
echo "java instalado"
sudo apt install default-jre -y
    sleep 3
git clone https://github.com/Magna-Security/backend-swing.git
cd backend-swing
git checkout console

sudo docker build -t dockerfile .
sudo docker run -d -t --rm --name containerjava dockerfile

else
echo "java nao instalado"
echo "gostaria de instalar o java em sua Máquina Virtual? (s/n)"
read inst
if [ \"$inst\" == \"s\" ];
then
sudo apt install default-jre -y
git clone https://github.com/Magna-Security/backend-swing.git
cd backend-swing
git checkout console

sudo docker build -t dockerfile .
sudo docker run -d -t --name containerjava dockerfile

fi
fi