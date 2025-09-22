# Etapa 1: Build da aplicação
FROM node:20 AS builder

WORKDIR /app

# Copiar configs do npm
COPY package*.json ./

# Instalar dependências
RUN npm install --legacy-peer-deps

# Copiar o resto do código
COPY . .

# Gerar build de produção
RUN npm run build

# Etapa 2: Servir com Nginx
FROM nginx:alpine

# Remover arquivos padrão do nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiar build para o nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiar config customizada do nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
