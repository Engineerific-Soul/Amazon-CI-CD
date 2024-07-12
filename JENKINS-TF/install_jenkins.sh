# Update the package lists
sudo apt update -y

# Download and add the GPG key for the Adoptium repository
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc

# Add the Adoptium repository to the system's sources list
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

# Update the package lists again to include the new Adoptium repository
sudo apt update -y

# Install the Temurin 17 JDK
sudo apt install temurin-17-jdk -y

# Verify the installation of Java
/usr/bin/java --version

# Download and add the GPG key for the Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add the Jenkins repository to the system's sources list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package lists again to include the new Jenkins repository
sudo apt-get update -y

# Install Jenkins
sudo apt-get install jenkins -y

# Start the Jenkins service
sudo systemctl start jenkins

# Check the status of the Jenkins service
sudo systemctl status jenkins

# Update the package lists
sudo apt-get update

# Install Docker
sudo apt-get install docker.io -y

# Add the 'ubuntu' user to the 'docker' group
sudo usermod -aG docker ubuntu  

# Refresh the group membership for the 'docker' group
newgrp docker

# Change permissions on the Docker socket to allow all users to access it
sudo chmod 777 /var/run/docker.sock

# Run a SonarQube container using Docker
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# Install required packages for Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y

# Download and add the GPG key for the Trivy repository
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

# Add the Trivy repository to the system's sources list
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

# Update the package lists again to include the new Trivy repository
sudo apt-get update

# Install Trivy
sudo apt-get install trivy -y
