CREATE TABLE `courses`(
    `course_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `course_title` VARCHAR(100) NOT NULL,
    `description` TEXT NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `level` VARCHAR(50) NOT NULL COMMENT '\'beginner\', \'intermediate\', \'advanced\'',
    `duration` INT NOT NULL COMMENT 'Hours',
    `creation_date` DATE NOT NULL
);
CREATE TABLE `subscriptions`(
    `subscription_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `subscription_type` VARCHAR(20) NOT NULL COMMENT 'monthly or annual',
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT '' active ''
);
CREATE TABLE `payments`(
    `payment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `payment_date` DATE NOT NULL
);
CREATE TABLE `enrollments`(
    `enrollment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    `enrollment_date` DATE NOT NULL,
    `completion_status` VARCHAR(20) NOT NULL DEFAULT '' IN progress '' COMMENT '\'in progress\', \'completed\', \'dropped\''
);
CREATE TABLE `users`(
    `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `registration_date` DATE NOT NULL,
    `subscription_type` VARCHAR(20) NOT NULL DEFAULT 'monthly',
    `subscription_status` VARCHAR(20) NOT NULL DEFAULT 'active'
);
ALTER TABLE
    `users` ADD UNIQUE `users_email_unique`(`email`);
ALTER TABLE
    `subscriptions` ADD CONSTRAINT `subscriptions_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`user_id`);
ALTER TABLE
    `enrollments` ADD CONSTRAINT `enrollments_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`user_id`);
ALTER TABLE
    `payments` ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY(`user_id`) REFERENCES `users`(`user_id`);
ALTER TABLE
    `enrollments` ADD CONSTRAINT `enrollments_course_id_foreign` FOREIGN KEY(`course_id`) REFERENCES `courses`(`course_id`);