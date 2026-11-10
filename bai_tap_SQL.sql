create database bai_tap_sql;

create table if not exists "users" (
	"id" SERIAL primary key,
	"email" VARCHAR(255),
	"fullName" VARCHAR(255),
	"password" VARCHAR(255),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "food_types" (
	"id" SERIAL primary key,
	"typeName" VARCHAR(255),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "foods" (
	"id" SERIAL primary key,
	"foodName" VARCHAR(255),
	"image" VARCHAR(255),
	"price" FLOAT,
	"description" TEXT,
	"typeId" int,
	
	FOREIGN KEY ("typeId") REFERENCES "food_types"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "sub_foods" (
	"id" SERIAL primary key,
	"subName" VARCHAR(255),
	"subPrice" FLOAT,
	"foodId" int,
	
	FOREIGN KEY ("foodId") REFERENCES "foods"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "restaurants" (
	"id" SERIAL primary key,
	"resName" VARCHAR(255),
	"image" VARCHAR(255),
	"description" TEXT,
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "orders" (
	"id" SERIAL primary key,
	"userId" int,
	"foodId" int,
	"amount" int,
	"code" VARCHAR(255),
	"arrSubId" VARCHAR(255),
	
	FOREIGN KEY ("userId") REFERENCES "users"("id"),
	FOREIGN KEY ("foodId") REFERENCES "foods"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "like_res" (
	"id" SERIAL primary key,
	"userId" int,
	"resId" int,
	"dateLike" timestamp default CURRENT_TIMESTAMP,
	
	FOREIGN KEY ("userId") REFERENCES "users"("id"),
	FOREIGN KEY ("resId") REFERENCES "restaurants"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "rate_res" (
	"id" SERIAL primary key,
	"userId" int,
	"resId" int,
	"amount" int,
	"dateRate" timestamp default CURRENT_TIMESTAMP,
	
	FOREIGN KEY ("userId") REFERENCES "users"("id"),
	FOREIGN KEY ("resId") REFERENCES "restaurants"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);


INSERT into "users" ("fullName", "email", "password") VALUES
					('Le Van Nam', 'nam@gmail.com', '111'),
					('Tran Thi Lan', 'lan@gmail.com', '111'),
					('Nguyen Hoang Long', 'long@gmail.com', '111'),
					('Pham Thuy Linh', 'linh@gmail.com', '111'),
					('Doan Minh Duc', 'duc@gmail.com', '111'),
					('Vu Thi Mai', 'mai@gmail.com', '111'),
					('Dang Khoa', 'khoa@gmail.com', '111'),
					('Bui Tien Dung', 'dung@gmail.com', '111');

INSERT into "food_types" ("typeName") VALUES
					('Mon nuong'),
					('Mon nuoc'),
					('An vat'),
					('Tra sua');

INSERT into "foods" ("foodName", "price", "description", "typeId") VALUES
					('Thit ba chi nuong', 65000, 'thit tuoi', 1),
					('Bun bo Hue', 40000, 'cay nong', 2),
					('Banh trang tron', 20000, 'nhieu kho bo', 3),
					('Tra sua tran chau', 30000, 'it da', 4),
					('Ca vien chien', 15000, 'cham tuong ot', 3);

INSERT into "sub_foods" ("subName", "subPrice", "foodId") VALUES
					('Them bun', 5000, 2),
					('Them tran chau', 7000, 4),
					('Them pho mai', 10000, 1);

INSERT into "restaurants" ("resName", "description") VALUES
					('Quan Nuong BBQ', 'chuyen do nuong'),
					('Bun Bo Co Ba', 'bun bo gia truyen'),
					('An Vat Sai Gon', 'banh trang ca vien'),
					('Tra Sua Tocotoco', 'tra sua ngon');

INSERT INTO "like_res" ("userId", "resId") VALUES
						(3, 1),
						(3, 2),
						(3, 3),
						(3, 4),
						(1, 1),
						(1, 2),
						(2, 1),
						(2, 3),
						(4, 2),
						(5, 4),
						(6, 2);

INSERT INTO "rate_res" ("userId", "resId", "amount") VALUES
						(1, 2, 5),
						(3, 1, 4),
						(4, 3, 5),
						(2, 4, 3);

INSERT INTO "orders" ("userId", "foodId", "amount") VALUES
						(3, 1, 1),
						(3, 2, 2),
						(3, 3, 1),
						(3, 5, 3),
						(1, 2, 1),
						(2, 4, 2),
						(2, 1, 1),
						(5, 3, 1);



SELECT "like_res"."userId", "users"."id", "fullName", "email", COUNT("like_res"."userId") AS "Luot like"
FROM "like_res"
INNER JOIN "users" ON "like_res"."userId" = "users"."id"
GROUP BY "like_res"."userId", "users"."id"
ORDER BY "Luot like" DESC
LIMIT 5;


SELECT "like_res"."resId", "restaurants"."id", "resName", COUNT("like_res"."resId") AS "Luot like"
FROM "like_res"
INNER JOIN "restaurants" ON "like_res"."resId" = "restaurants"."id"
GROUP BY "like_res"."resId", "restaurants"."id"
ORDER BY "Luot like" DESC
LIMIT 2;


SELECT "orders"."userId", "users"."id", "fullName", "email", COUNT("orders"."userId") AS "So don dat"
FROM "orders"
INNER JOIN "users" ON "users"."id" = "orders"."userId"
GROUP BY "users"."id", "orders"."userId"
HAVING COUNT("orders"."userId") = (
	SELECT MAX(bang_dem."count")
	FROM (
		SELECT COUNT("orders"."userId")
		FROM "orders"
		GROUP BY "orders"."userId"
	) AS bang_dem
);


SELECT *
FROM "users"
LEFT JOIN "orders" ON "orders"."userId" = "users"."id"
LEFT JOIN "like_res" ON "like_res"."userId" = "users"."id"
LEFT JOIN "rate_res" ON "rate_res"."userId" = "users"."id"
WHERE "orders"."id" IS NULL 
AND "like_res"."id" IS NULL 
AND "rate_res"."id" IS NULL;