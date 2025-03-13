use final;

-- -- 이미 존재하는 테이블을 삭제 -- --
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `sale_data`;
DROP TABLE IF EXISTS `cart`;
DROP TABLE IF EXISTS `address_list`;
DROP TABLE IF EXISTS `category`;
DROP TABLE IF EXISTS `goods`;
DROP TABLE IF EXISTS `address`;
DROP TABLE IF EXISTS `member`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `shipments`;
DROP TABLE IF EXISTS `inventory`;
DROP TABLE IF EXISTS `sub_category`;
-- -------------------------- --

-- 결제기록
CREATE TABLE `payments` (
	`payment_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`orders_id`	BIGINT	NOT NULL,
	`member_no`	BIGINT	NOT NULL,
	`goods_id`	BIGINT	NOT NULL,
	`final_price`	BIGINT	NULL,
	`payment_status`	boolean	NULL,
	`payment_amount`	BIGINT	NULL,
	`payment_method`	VARCHAR(20)	NULL,
	`payment_date`	DATETIME	NULL,
	`payment_approved`	DATETIME	NULL,
    PRIMARY KEY (`payment_id`)
);

-- 장바구니
CREATE TABLE `cart` (
	`cart_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`goods_id`	BIGINT	NOT NULL,
	`member_no`	BIGINT	NOT NULL,
	`cart_quantity`	BIGINT	NULL,
	`created_at`	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`cart_id`)
);

-- 카테고리
CREATE TABLE `category` (
	`category_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`first_name`	VARCHAR(20)	NULL,
	`second_name`	VARCHAR(20)	NULL,
    PRIMARY KEY (`category_id`)
);

-- 상품
CREATE TABLE `goods` (
	`goods_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`category_id`	BIGINT	NOT NULL,
    `sub_category_id` BIGINT NOT NULL,
	`goods_name`	VARCHAR(255)	NULL,
	`goods_price`	BIGINT	NULL,
	`goods_description`	VARCHAR(255)	NULL,
	`goods_stock`	BIGINT	NULL,
	`goods_image`	VARCHAR(255)	NULL,
	`goods_updated_at`	TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	`goods_created_at`	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`goods_views`	BIGINT	NULL DEFAULT(0),
	`goods_orders`	BIGINT	NULL DEFAULT(0),
    PRIMARY KEY (`goods_id`)
);

-- 배송지 리스트
CREATE TABLE `address_list` (
	`address_list_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`member_no`	BIGINT	NOT NULL,
	`address_id`	BIGINT	NULL,
    PRIMARY KEY (`address_list_id`)
);

-- 배송지 주소
CREATE TABLE `address` (
	`address_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`member_no`	BIGINT	NOT NULL,
	`address_name`	VARCHAR(50)	NULL,
	`postcode`	VARCHAR(5)	NULL,
	`shipping_address1`	VARCHAR(255)	NULL,
	`shipping_address2`	VARCHAR(255)	NULL,
	`shipping_name`	VARCHAR(20)	NULL,
	`shipping_phone`	VARCHAR(20)	NULL,
     PRIMARY KEY (`address_id`)
);

-- 회원
CREATE TABLE `member` (
	`member_no`	BIGINT	NOT NULL AUTO_INCREMENT,
	`member_id`	VARCHAR(20)	NULL,
	`member_passwd`	VARCHAR(255)	NULL,
	`member_username`	VARCHAR(20)	NULL,
	`member_gender`	VARCHAR(5)	NULL,
	`member_nickname`	VARCHAR(20)	NULL,
	`member_phone`	VARCHAR(20)	NULL,
	`member_birthdate`	DATETIME	NULL,
	`member_role`	VARCHAR(20)	NULL,
	`member_address`	VARCHAR(255)	NULL,
	`member_created_at`	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     PRIMARY KEY (`member_no`)
);

-- 리뷰
CREATE TABLE `reviews` (
	`review_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`member_no`	BIGINT	NOT NULL,
	`goods_id`	BIGINT	NOT NULL,
	`orders_id`	BIGINT	NOT NULL,
	`reviews_contents`	VARCHAR(255)	NULL,
	`reviews_image`	VARCHAR(255)	NULL,
	`reviews_date`	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     PRIMARY KEY (`review_id`)
);

-- 배송관리
CREATE TABLE `shipments` (
	`shipments_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`orders_id`	BIGINT	NOT NULL,
	`shipments_status`	VARCHAR(50)	NULL,
    PRIMARY KEY (`shipments_id`)
);

-- 재고
CREATE TABLE `inventory` (
	`inventory_id`	BIGINT	NOT NULL AUTO_INCREMENT,
	`goods_id`	BIGINT	NOT NULL,
	`stock_quantity`	BIGINT	NOT NULL  DEFAULT(0),
	`stock_status`	VARCHAR(20)	NULL,
	`stock_updated_at`	DATETIME	NULL,
    PRIMARY KEY (`inventory_id`)
);

-- 주문내역
CREATE TABLE `orders`(
	`orders_id` BIGINT NOT NULL AUTO_INCREMENT,
    `member_no` BIGINT NOT NULL,
    `orders_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`orders_id`)
);

-- 판매기록(전체)
CREATE TABLE `sale_data`(
	`sales_id` BIGINT NOT NULL AUTO_INCREMENT,
    `orders_id` BIGINT NOT NULL,
    `goods_id` BIGINT  NOT NULL,
    `sale_amount`  BIGINT NOT NULL,
    `sale_price`  BIGINT NOT NULL,
    `sale_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sales_id`)
);

-- 서브 카테고리 생성
CREATE TABLE `sub_category` (
    `sub_category_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `category_id` BIGINT NOT NULL,
    `sub_name` VARCHAR(50) NOT NULL,
    FOREIGN KEY (`category_id`) REFERENCES `category`(`category_id`) ON DELETE CASCADE
);

-- 외래 키 설정
-- payments 테이블
ALTER TABLE `payments`
ADD CONSTRAINT `FK_payments_orders_id` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`orders_id`),
ADD CONSTRAINT `FK_payments_member_no` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`),
ADD CONSTRAINT `FK_payments_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`);

-- sale_data 테이블
ALTER TABLE `sale_data`
ADD CONSTRAINT `FK_sale_data_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
ADD CONSTRAINT `FK_sale_data_orders_id` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`orders_id`);

-- cart 테이블
ALTER TABLE `cart`
ADD CONSTRAINT `FK_cart_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
ADD CONSTRAINT `FK_cart_member_no` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`);

-- address_list 테이블
ALTER TABLE `address_list`
ADD CONSTRAINT `FK_address_list_member_no` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`);

-- goods 테이블 (category_id 연결)
ALTER TABLE `goods`
ADD CONSTRAINT `FK_goods_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
ADD CONSTRAINT `FK_goods_sub_category_id` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_category` (`sub_category_id`);

-- address 테이블
ALTER TABLE `address`
ADD CONSTRAINT `FK_address_member_no` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`);

-- reviews 테이블
ALTER TABLE `reviews`
ADD CONSTRAINT `FK_reviews_member_no` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`),
ADD CONSTRAINT `FK_reviews_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
ADD CONSTRAINT `FK_reviews_orders_id` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`orders_id`);

-- shipments 테이블
ALTER TABLE `shipments`
ADD CONSTRAINT `FK_shipments_orders_id` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`orders_id`);

-- inventory 테이블
ALTER TABLE `inventory`
ADD CONSTRAINT `FK_inventory_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`);

-- orders 테이블
ALTER TABLE `orders`
ADD CONSTRAINT `FK_orders_member` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`);

-- sub_category 테이블
ALTER TABLE `sub_category`
ADD CONSTRAINT `FK_sub_category_category_id` FOREIGN KEY (`category_id`) REFERENCES `category`(`category_id`) ON DELETE CASCADE