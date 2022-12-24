
DROP DATABASE IF EXISTS project;
CREATE DATABASE project CHARSET=UTF8;


USE project;

DROP TABLE IF EXISTS operation_type;

CREATE TABLE operation_type(
operation_type_id INT(20) UNSIGNED  NOT NULL,
times INT(20),
expense INT(20)
);


DROP TABLE IF EXISTS machine_type;

CREATE TABLE machine_type(
machine_type_id INT(20) UNSIGNED  NOT NULL,
operation_type_id INT(20) UNSIGNED NOT NULL
/* FOREIGN key(operation_type_id) REFERENCES operation_type(operation_type_id) */
); 



DROP TABLE IF EXISTS machine;

CREATE TABLE machine(
machine_id INT(20) UNSIGNED  NOT NULL,
machine_type_id INT(20) UNSIGNED NOT NULL,
status int (20)
/* FOREIGN KEY(machine_type_id) REFERENCES machine_type(machine_type_id) */
);



DROP TABLE IF EXISTS operation;

CREATE TABLE operation(
operation_id INT(20) UNSIGNED  NOT NULL,
operation_type_id INT(20) UNSIGNED NOT NULL
/* FOREIGN KEY(operation_type_id) REFERENCES operation_type(operation_type_id) */
);



DROP TABLE IF EXISTS chip_type;

CREATE TABLE chip_type(

chip_type_id INT(20) UNSIGNED  NOT NULL,
operation_id INT(20) UNSIGNED NOT NULL,
operation_order INT(20) UNSIGNED NOT NULL DEFAULT 0
/* FOREIGN KEY(operation_id) REFERENCES operation(operation_id) */
);


DROP TABLE IF EXISTS chip;

CREATE TABLE chip(
chip_id INT(20) UNSIGNED  NOT NULL,
chip_type_id INT(20) UNSIGNED NOT NULL
/* FOREIGN KEY(chip_type_id) REFERENCES chip_type(chip_type_id) */
);


DROP TABLE IF EXISTS package;

CREATE TABLE package(
package_id INT(20) UNSIGNED  NOT NULL,
chip_id INT(20) UNSIGNED NOT NULL
/* FOREIGN KEY(chip_id) REFERENCES chip(chip_id) */

);


DROP TABLE IF EXISTS plant;

CREATE TABLE plant(
plant_id INT(20) UNSIGNED  NOT NULL,
machine_id INT(20) UNSIGNED
/* FOREIGN KEY(machine_id) REFERENCES machine(machine_id) */
);


DROP TABLE IF EXISTS consumer;

CREATE TABLE consumer(
consumer_id INT(20) UNSIGNED  NOT NULL,
package_id INT(20) UNSIGNED,
plant_id INT(20) UNSIGNED
/* FOREIGN key(plant_id) REFERENCES plant(plant_id),
FOREIGN KEY(package_id) REFERENCES package(package_id) */
);

drop table if exists record;

create table record(
    start_time INT(20),
    end_time int(20),
    expense int(20)
) ;



-- 插入数据

insert into operation_type values
(0,0,0),
(1,6,10),
(2,66,20),
(3,60,666),
(4,20,50),
(5,20,10),
(6,20,20),
(7,30,40),
(8,40,30);

insert into operation values
(0,0),
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8);


insert into machine_type values 
(0,0),
(1,1),
(2,2),
(3,3),
(4,4),(4,5),
(5,5),(5,7),
(6,6),(6,8),
(7,7),(7,4),(7,6),
(8,8),(8,4),(8,5),(8,7);

insert into machine values
(1,1,0),(2,1,0),(3,1,0),
(4,2,0),(5,2,0);


insert into plant VALUES
(0,0),
(1,1),(1,2),(1,3),
(2,4),(2,5);

insert into chip_type values -- id op_id op_order
(0,0,0),
(1,1,0),(1,2,0), -- operation type id = 1
(2,2,0),
(3,3,0),(3,4,1),
(4,5,0),(4,4,1),
(5,8,0),(5,7,1);

insert into chip values
(0,0),
(1,1),
(2,1),
(3,1),
(4,2),
(5,3),
(6,3);

insert into record values(0,0,0);

insert into package values
(0,0),
(1,1),(1,2),(1,3),(1,4), -- type1
(2,4),(2,5);

insert into consumer values
-- (1,0,0),
-- (2,1,1);
(1,1,1),
(2,2,1); 