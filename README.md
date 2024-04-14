# Docker Compose Environment Setup

This project implements a Docker Compose environment with Laravel, Nginx, MySQL, and an optional Random HTTP Docker image.

### Dockerfiles

- **composer.dockerfile**: Dockerfile for setting up a Composer container.
- **nginx.dockerfile**: Dockerfile for configuring an Nginx container.
- **php.dockerfile**: Dockerfile for configuring a PHP-FPM container.

### Env

- **mysql.env**: Environment variables for MySQL database configuration.

### Nginx

- **nginx.conf**: Nginx server configuration for routing requests to the Laravel application and the random http docker image.

### Src (Development Phase)

- This directory is automatically populated with your Laravel application source code thanks to the bind mounts defined in the `docker-compose.yaml` file. During the development phase, any modifications you make to your application code will be immediately visible in the running containers.

- The bind mounts ensure that the Laravel application source code is synchronized with the containers, allowing you to see live changes without needing manual intervention.

### docker-compose.yaml

- Configuration file for Docker Compose that defines the services and containers for your development environment. This file is configured for a development phase of a project.

## Prerequisites

Before you get started, ensure you have the following prerequisites installed on your system:

- Docker
- Docker Compose (separate installation for Linux users)

## Environment Setup

Follow these steps to set up your Laravel development environment using Docker:

1. Clone this repository to your local machine.

2. Configure your Laravel application to use the MySQL database. You can do this by modifying your Laravel application's `.env` file with the database credentials specified in the `mysql.env` file. (Data will not persist since there are no volumes).

3. Create the laravel project:

    ```bash    
    docker-compose run --rm composer create-project --prefer-dist laravel/laravel:^8.0 .
     ```

4. Open src/.env in your editor and change the configuration lines for the database connection as follows:

- DB_DATABASE=homestead
- DB_USERNAME=homestead
- DB_PASSWORD=secret

5. Open src/routes/web.php and copy this php code:

   ```php
      <?php

   // Import necessary Laravel classes
   use Illuminate\Support\Facades\DB;
   use Illuminate\Support\Facades\Route;

   // Define a GET route for the root path ('/')
   Route::get('/', function () {
      try {
         // Attempt to retrieve data from the database to assert database connection
         $data = DB::table('info')->first();
         return response()->json($data);  // Return the retrieved data as JSON response
      } catch (\Exception $e) {
         // Handle any database connection errors
         return response()->json(['error' => 'Follow README.md DataBase Configuration intstructions to populate the MySQL database'], 500);
      }
   });
   ```

The "'info'" string is the tables name that it will be created in a following step.

## Run Tests

1. Build the Docker containers using `--build` to make sure you are getting the latest image and start the development environment using the following command:

    ```bash
    docker-compose up --build server
     ```

2. Update the DNS of your localhost to "devops.test":


- Updating the Hosts File (Windows)

   Open Notepad as Administrator:
      Right-click on the Notepad application in the Start menu.
       Select "Run as administrator" to open Notepad with administrative privileges.

   Open the Hosts File:
      In Notepad, go to File > Open.
      Navigate to C:\Windows\System32\drivers\etc.
      Change the file type to "All Files" to see the hosts file.
      Select the hosts file and click "Open".

   Edit the Hosts File:
      
   Add a new line at the end of the hosts file:
      
      <nginx_container_ip_address> devops.test
      

   Getting the docker conatainer's IP Address
             
   ```bash
   docker ps
   ```

   ```bash
   docker inspect <container id>
   ```
         
   Replace `<nginx_container_ip_address>` with the actual IP address of your Docker container running Nginx.

   Example:
   http://172.17.0.2 devops.test

   Save the Hosts File:
   After adding the line, save the hosts file (File > Save).

- Updating the Hosts File (macOS/Linux)

   Open Terminal:
   Open Terminal from the Applications or Utilities folder (macOS) or use the default terminal (Linux).

   Edit the Hosts File:
   Open the hosts file using a text editor with sudo privileges:

   ```bash
   sudo nano /etc/hosts
   ```

   Add an Entry to the Hosts File:

   Add a new line at the end of the hosts file:

      
      <nginx_container_ip_address> devops.test
      
   Getting the docker conatainer's IP Address
             
   ```bash
   docker ps
   ```

   ```bash
   docker inspect <container id>
   ```

   Replace `<nginx_container_ip_address>` with the actual IP address of your Docker container running Nginx.

   Example:
   172.17.0.2 devops.test
   Save and Exit:
   Press Ctrl + X to exit nano.
   Type Y to confirm changes.
   Press Enter to save the hosts file.



- Updating the Hosts File (Windows using WSL)

   Go to your wsl terminal

   ```bash
   ip addr show
   ```

   Look for an interface like eth0 or eth1 (usually named eth0 in WSL) and find the associated IP address. It will typically be in the range of 172.16.x.x, 172.17.x.x, 172.18.x.x, or 172.19.x.x depending on the WSL network configuration.

   Locate the ip address of your wsl virtual machine.

   Open Notepad as Administrator:
   Right-click on the Notepad application in the Start menu.
   Select "Run as administrator" to open Notepad with administrative privileges.

   Open the Hosts File:
   In Notepad, go to File > Open.
   Navigate to C:\Windows\System32\drivers\etc.
   Change the file type to "All Files" to see the hosts file.
   Select the hosts file and click "Open".

   Edit the Hosts File:
   Add a new line at the end of the hosts file:

      
      <nginx_container_ip_address> devops.test
      

   Getting teh docker conatainer's IP Address
             
   ```bash
   docker ps
   ```

   ```bash
   docker inspect <container id>
   ```

   Replace `<nginx_container_ip_address>` with the actual IP address of your Docker container running Nginx.

   Example:
   http://172.17.0.2 devops.test
            
   After adding the line, save the hosts file (File > Save).

3. Once the containers are up and running, you can access your Laravel application in your web browser at http://devops.test:8000. Additionally, the path http://devops.test:8000/thiio/ (**this last slash is very important to get access**) will proxy to an httpd image.


## DataBase Configuration

### Populate de MySQL database

1. Locate the container id and get inside the MySQL container:

   ```bash   
   docker ps
   ```

   ```bash
   docker exec -ti <mysql-container-id> bash
   ```

2. Once inside the container authenticate to the database utilizing the envirnoment variables declared  in the Environment Setup step:

   ```mysql
   mysql -u homestead -p
      user:homestead
      pswd: secret
   ```

3. Change to our application database:

   ```mysql
   show databases;
   ```

   ```mysql
   use homestead;
   ```

4. Create a table. **This table name must match the string table's name declared in number 5 in the Environment Setup configuration**.

   ```mysql
   create table info (name varchar(20), lastname varchar(20), age int(2));
   ```

   ```mysql
   show tables;
   ```

   ```mysql
   desc info;
   ```

5. Populate the table with random info:

   ```mysql
   insert into info values ('juan','perez','30');
   ```

   ```mysql
   select * from info;
   ```


### Notes:

- Ensure Docker and Docker Compose are installed on your system.
- The MySQL database will be available on port 3306.
- The Laravel application uses PHP-FPM on port 9000.
- Nginx serves the Laravel application at http://devops.test.
- Requests to http://devops.test/thiio are proxied to the Random HTTP service.

