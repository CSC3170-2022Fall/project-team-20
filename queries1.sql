/* USE project; */
/* 
insert into consumer values
(3,1,1);

update consumer set `plant_id`=1 where `consumer_id`=2; */
/* select sum(operation_type.times) from */
/* select sum(times) from operation_type;

select sum(times) from operation_type
 where operation_type_id != 0 and operation_type_id
in (select operation.operation_type_id from operation where operation_id in(select operation_id from chip_type where chip_type_id = 2)); */


-- get chip type time
/* DROP FUNCTION IF EXISTS get_chip_type_time;

DELIMITER //
CREATE FUNCTION get_chip_type_time(id INT) 
RETURNS INT(20)
DETERMINISTIC
BEGIN
RETURN (

select sum(times) from operation_type
where operation_type_id != 0 and operation_type_id
in (select operation.operation_type_id from operation where operation_id in(select operation_id from chip_type where chip_type_id = id))

);
END//

DELIMITER ; */



DROP FUNCTION IF EXISTS get_chip_type_time;

DELIMITER //
CREATE FUNCTION get_chip_type_time(cid INT) 
RETURNS INT(20)
DETERMINISTIC
BEGIN
DECLARE result int;
select sum(times) into result from operation_type
where operation_type_id != 0 and operation_type_id
in (select operation.operation_type_id from operation where operation_id in (select operation_id from chip_type where chip_type_id = cid));
RETURN result;
END//

DELIMITER ;



DROP FUNCTION IF EXISTS get_chip_type_expense;

DELIMITER //
CREATE FUNCTION get_chip_type_expense(cid INT) 
RETURNS INT(20)
DETERMINISTIC
BEGIN
DECLARE result int;
select sum(expense) into result from operation_type
where operation_type_id != 0 and operation_type_id
in (select operation.operation_type_id from operation where operation_id in (select operation_id from chip_type where chip_type_id = cid));
RETURN result;
END//

DELIMITER ;


/* select count(*) from (select chip_type_id from chip where chip_id in (select package.chip_id from package where package_id = 1) ) as test; */

DROP procedure IF EXISTS get_package_time;
DELIMITER //
create procedure get_package_time(pid int)
BEGIN
    -- 声明变量
    DECLARE cid INT;
    DECLARE done INT default 0;
    DECLARE tmp INT ;
-- 创建游标，并设置游标所指的数据（这里设置ID不为1是因为ID为1的是总的大类）
    DECLARE totaltimes int default 0;
    DECLARE cur CURSOR for
        select chip_type_id from chip where chip_id in (select package.chip_id from package where package_id = pid);
-- 游标执行aaaaaaa完，即遍历结束。设置done的值为1
    DECLARE CONTINUE HANDLER for not FOUND set done = 1;
-- 开启游标a
    open cur;
    update record set start_time = end_time;
-- 执行循环
    posLoop:
    LOOP
        -- 如果done的值为1，即遍历结束，结束循环
        FETCH cur INTO tmp;
        IF done = 1 THEN
            /* select totaltimes from record; */
            /* update end_time =  totaltimes from record; */
            update record set end_time = start_time + totaltimes;
            /* update start_time  = start_time + end_time from record; */
            /* update record set start_time = start_time + end_time; */
            LEAVE posLoop;
-- 注意，if语句需要添加END IF结束IF
        END IF;
        SET totaltimes = totaltimes + get_chip_type_time(tmp);

-- 从游标中取出cid
-- 关闭循环
    END LOOP posLoop;
-- 关闭游标
    CLOSE cur;
-- 关闭分隔标记
END //
DELIMITER ;



DROP procedure IF EXISTS get_package_expense;
DELIMITER //
create procedure get_package_expense(pid int)
BEGIN
    -- 声明变量
    DECLARE cid INT;
    DECLARE done INT default 0;
    DECLARE tmp INT ;
-- 创建游标，并设置游标所指的数据（这里设置ID不为1是因为ID为1的是总的大类）
    DECLARE totaltimes int default 0;
    DECLARE cur CURSOR for
        select chip_type_id from chip where chip_id in (select package.chip_id from package where package_id = pid);
-- 游标执行aaaaaaa完，即遍历结束。设置done的值为1
    DECLARE CONTINUE HANDLER for not FOUND set done = 1;
-- 开启游标a
    open cur;

-- 执行循环
    posLoop:
    LOOP
        -- 如果done的值为1，即遍历结束，结束循环
        FETCH cur INTO tmp;
        IF done = 1 THEN
            /* select totaltimes from record; */
            /* update end_time =  totaltimes from record; */
            update record set expense = totaltimes;
            /* update start_time  = start_time + end_time from record; */
            /* update record set start_time = start_time + end_time; */
            LEAVE posLoop;
-- 注意，if语句需要添加END IF结束IF
        END IF;
        SET totaltimes = totaltimes + get_chip_type_expense(tmp);

-- 从游标中取出cid
-- 关闭循环
    END LOOP posLoop;
-- 关闭游标
    CLOSE cur;
-- 关闭分隔标记
END //
DELIMITER ;



DROP procedure IF EXISTS reset;

DELIMITER //
CREATE procedure reset( )
DETERMINISTIC
BEGIN
update record set start_time = 0;
update record set end_time = 0;
update record set expense = 0;
END//

DELIMITER ;





DROP procedure IF EXISTS get_time_expense;

DELIMITER //
CREATE procedure get_time_expense(ptid INT) 

DETERMINISTIC
BEGIN


set @i := 1;
while @i <= ptid DO
    call get_package_time(@i);
    call get_package_expense(@i);
    set @i := @i + 1;
end while;
select * from record;
call reset();

END//

DELIMITER ;


call get_time_expense(1);
