-- 创建用户表
CREATE TABLE users (
    user_id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    register TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_sign_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建图片存储表
CREATE TABLE images (
    img_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(50) CHECK (category IN ('user_upload', 'ai_generated')),
    feature_vector JSONB,
    image_path VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 创建文本存储表
CREATE TABLE texts (
    text_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(50) CHECK (category IN ('user_input', 'ai_generated')),
    feature_vector JSONB,
    content TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 创建图片文本关联表
CREATE TABLE image_text_relations (
    id SERIAL PRIMARY KEY,
    img_id VARCHAR(255) NOT NULL,
    text_id VARCHAR(255) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (img_id) REFERENCES images(img_id),
    FOREIGN KEY (text_id) REFERENCES texts(text_id)
);

-- 创建索引
CREATE INDEX idx_images_user_id ON images(user_id);
CREATE INDEX idx_texts_user_id ON texts(user_id);
CREATE INDEX idx_relations_img_id ON image_text_relations(img_id);
CREATE INDEX idx_relations_text_id ON image_text_relations(text_id); 