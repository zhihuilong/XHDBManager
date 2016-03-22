-- ----------------------------
--  Table for user
-- ----------------------------
DROP TABLE IF EXISTS "user";
CREATE TABLE "user" (
"id" varchar not null primary key,
"name" varchar not null,
"age" int not null
);
