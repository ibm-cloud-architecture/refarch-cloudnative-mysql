# refarch-cloudnative-mysql

### Setup Inventory Database hosted on MySQL Container
This database will be managed by refarch-cloudnative-micro-inventory microservice.

1. Clone git repository.
    ```
    git clone https://github.com/ibm-cloud-architecture/refarch-cloudnative-mysql.git
    ```

2. Start MySQL container, create database `inventorydb`. This database can be connected at `<docker-host-ipaddr/hostname>:3306` as `dbuser` using `password`.
    ```
    cd refarch-cloudnative-sql
    docker run --name mysql -v $PWD/scripts:/home/scripts -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin123 -e MYSQL_USER=dbuser -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=inventorydb -w /home/scripts -d mysql:latest
    ```

3. Create `items` table and load sample data.
    ```
    docker exec -it mysql sh load-data.sh
    ```

4. Verify, there should be 12 rows in the table.
    ```
    docker exec -it mysql bash
    mysql -u dbuser -ppassword inventorydb
    mysql> select * from items;
    ```
   
Inventory database setup is complete.  