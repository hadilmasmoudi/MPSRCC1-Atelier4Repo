# Étape 1 : Utiliser une image Maven avec JDK 22 pour la construction
FROM maven:3.9.9-openjdk-22 AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier pom.xml et les fichiers sources dans l'image
COPY pom.xml .
COPY src ./src

# Compiler et empaqueter le projet en un fichier .jar
RUN mvn clean package -DskipTests

# Étape 2 : Utiliser une image JDK 22 légère pour exécuter l'application
FROM openjdk:22-jdk-slim

# Définir le répertoire de travail dans l'image finale
WORKDIR /app

# Copier le fichier .jar généré depuis l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port sur lequel l'application sera accessible
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["java", "-jar", "app.jar"]
