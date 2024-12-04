-- 创建 users 表
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    password VARCHAR(100) NOT NULL,
    register TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_sign_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建 images 表
CREATE TABLE images (
    img_ID SERIAL PRIMARY KEY,
    Text_ID INT,
    user_id INT NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(100),
    feature_vector JSON,
    image_path VARCHAR(255)
);

-- 创建 texts 表
CREATE TABLE texts (
    Text_ID SERIAL PRIMARY KEY,
    img_ID INT,
    user_id INT NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(100),
    feature_vector JSON
);

-- 插入用户数据
INSERT INTO users (username, email, password, register, last_sign_in)
VALUES
('sherwen', '3378*****@**mail.com', '123456', '2024-12-03 15:21:00', '2024-12-03 15:21:00');

-- 插入图片数据
INSERT INTO images (Text_ID, user_id, created_time, category, feature_vector, image_path)
VALUES
(2, 123456, '2024-12-03 15:21:00', '用户上传', '{"vector": [0.1, 0.2, 0.3]}', '/images/user_uploaded/01.jpg'),
(NULL, 123456, '2024-12-03 15:22:00', 'AI生成', '{"vector": [0.4, 0.5, 0.6]}', '/images/ai_generated/01.jpg');

-- 插入文本数据
INSERT INTO texts (img_ID, user_id, created_time, category, feature_vector)
VALUES
(1, 123456, '2024-12-03 15:21:00', '用户上传', '{"vector": [0.1, 0.2, 0.3]}'),
(1, 123456, '2024-12-03 15:22:00', 'AI生成', '{"vector": [0.4, 0.5, 0.6]}');
