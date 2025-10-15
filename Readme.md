# Premissas

- ✓ Autocontido 
- ✓ Desenvolvimento/Homologação/Produção juntos (faltam algumas definições)
- ✓ Controle dos certificados SSL automático 
- ✓ Possibilidade de subir por blocos
- ✓ Suporte a Single Page Application
- ✓ HTTP3 (falta testar, mas está anuncionado)
- ✓ Autoatualização (carece testes profundos)
- Logs
- Monitoramento

# Instalação do servidor

## Ambiente de homologação/produção

- Ubuntu 24.04 server com instalação minima (minimized) + ssh
- Instalação extra Docker + ufw

## Ambiente de desenvolvimento

Pode ser Ubuntu ou WSL2

Quando WSL2 incluir em /etc/wsl.conf
```
[automount]
options = "metadata"
```

## Instalar Docker

Seguindo manual
https://docs.docker.com/engine/install/ubuntu/

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# não pode ser rootless
sudo groupadd docker
sudo usermod -aG docker $USER

sudo apt install ufw
sudo ufw allow from 192.168.3.0/24 to any proto tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 443/udp
sudo ufw enable

sudo reboot
```

## Configurações do ambiente

```
git clone https://github.com/dioubernardo/ecossistema
cd ecossistema 
cp .env.exemplo .env
bash scripts/update.sh
```

### Para desenvolvimento autorizar certificadora

Após executar pela primeira vez será gerado um certificado (certs/rootCA.crt) que deve ser instalado

- Linux: ```sudo cp certs/rootCA.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates```
- Mac: ```sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain certs/rootCA.crt```
- Windows: clicar duas vezes em certs/rootCA.crt → Instalar Certificado → Autoridades de Certificação Raiz Confiáveis

# Para rodar

Execução normal
```
docker compose up -d
```

Execução de baterias de teste ou outros scripts manuais
```
docker compose run --rm psvo-test
```

# Autodeploy

```
sudo apt install cron
sudo systemctl enable cron
sudo systemctl start cron

cd ecossistema
echo "*/5 * * * * root $(pwd)/scripts/autodeploy.sh >> /var/log/autodeploy.log 2>&1" | sudo tee -a /etc/crontab
```
Obs: Houve uma tentativa via container que estava OK porem com problema no docker compose up, por rodar no contexto do container e não no host https://github.com/dioubernardo/ecossistema/commit/2e50ef64cb617c7977cbcc2192770f75ab1f66bc

## Memórias
- Tive que mexer no DNS do docker porque não estava rodando npm install no psvo
