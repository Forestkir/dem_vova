USE toys_2026;

SET NAMES utf8mb4;

CREATE TABLE roles (
    role_id TINYINT UNSIGNED PRIMARY KEY,
    role_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id TINYINT UNSIGNED NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    login VARCHAR(120) NOT NULL UNIQUE,
    password_plain VARCHAR(120) NOT NULL,
    CONSTRAINT fk_users_roles
        FOREIGN KEY (role_id) REFERENCES roles(role_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE manufacturers (
    manufacturer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE suppliers (
    supplier_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    article VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    unit_name VARCHAR(20) NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
    supplier_id INT UNSIGNED NOT NULL,
    manufacturer_id INT UNSIGNED NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL CHECK (discount_percent >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    description_text TEXT NULL,
    photo_file VARCHAR(255) NULL,
    CONSTRAINT fk_products_suppliers
        FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_products_manufacturers
        FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pickup_points (
    pickup_point_id INT UNSIGNED PRIMARY KEY,
    address_text VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_statuses (
    status_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders (
    order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number INT UNSIGNED NOT NULL UNIQUE,
    article_text VARCHAR(255) NOT NULL,
    order_date DATE NULL,
    delivery_date DATE NULL,
    pickup_point_id INT UNSIGNED NOT NULL,
    client_user_id INT UNSIGNED NULL,
    pickup_code INT UNSIGNED NOT NULL,
    status_id TINYINT UNSIGNED NOT NULL,
    CONSTRAINT fk_orders_pickup_points
        FOREIGN KEY (pickup_point_id) REFERENCES pickup_points(pickup_point_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_users
        FOREIGN KEY (client_user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_orders_statuses
        FOREIGN KEY (status_id) REFERENCES order_statuses(status_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
    order_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uk_order_product UNIQUE (order_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_status ON orders(status_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

CREATE TABLE users_import_raw (
    role_name VARCHAR(100),
    full_name VARCHAR(200),
    login_text VARCHAR(120),
    password_text VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products_import_raw (
    article_text VARCHAR(60),
    name_text VARCHAR(200),
    unit_text VARCHAR(20),
    price_text VARCHAR(40),
    supplier_text VARCHAR(120),
    manufacturer_text VARCHAR(120),
    category_text VARCHAR(120),
    discount_text VARCHAR(40),
    stock_text VARCHAR(40),
    description_text TEXT,
    photo_text VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pickup_points_import_raw (
    raw_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address_text VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders_import_raw (
    raw_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number_text VARCHAR(40),
    articles_text VARCHAR(255),
    order_date_text VARCHAR(40),
    delivery_date_text VARCHAR(40),
    pickup_point_text VARCHAR(40),
    client_fio_text VARCHAR(200),
    pickup_code_text VARCHAR(40),
    status_text VARCHAR(80)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ===========================================
-- ВСТАВКА ДАННЫХ В RAW ТАБЛИЦЫ (ИМИТАЦИЯ ИМПОРТА CSV)
-- ===========================================

-- ИМПОРТ: user_import.csv
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Администратор', 'Ворсин Петр Евгеньевич', '94d5ous@gmail.com', 'uzWC67');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Администратор', 'Старикова Елена Павловна', 'uth4iz@mail.com', '2L6KZG');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Администратор', 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Менеджер', 'Михайлюк Анна Вячеславовна', '1diph5e@tutanota.com', '8ntwUp');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Менеджер', 'Ситдикова Елена Анатольевна', 'tjde7c@yahoo.com', 'YOyhfR');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Менеджер', 'Никифорова Весения Николаевна', 'wpmrc3do@tutanota.com', 'RSbvHv');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Авторизированный клиент', 'Степанов Михаил Артёмович', '5d4zbu@tutanota.com', 'rwVDh9');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Авторизированный клиент', 'Ворсин Петр Евгеньевич', 'ptec8ym@yahoo.com', 'LdNyos');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Авторизированный клиент', 'Старикова Елена Павловна', '1qz4kw@mail.com', 'gynQMT');
INSERT INTO users_import_raw (role_name, full_name, login_text, password_text) VALUES ('Авторизированный клиент', 'Сазонов Руслан Германович', '4np6se@mail.com', 'AtnDjr');

-- ИМПОРТ: Tovar.csv
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('PMEZMH', 'Детский игровой набор машинок Щенячий патруль / Dogs mini . 9 героев + 9 инерфионных машинок', 'шт.', '1 414', 'Pikeshop', 'ABSпластик', 'Игровой набор', '22', '50', 'Детский набор машинок с героями мультсериала «Щенячий патруль» подойдет как для мальчиков, так и для девочек. В детский набор входит 9 фигурок щенков спасателей.', '1.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('BPV4MM', 'Конструктор Гарри Поттер Сова Букля 630 деталей совместим с lego harry potter, лего совместимый)', 'шт.', '771', 'Playbig', 'ABSпластик', 'Конструктор', '15', '26', 'Коллекционная модель Букля состоит из множества потрясающих элементов, а также специального механизма внутри. С его помощью можно плавно поднимать-опускать крылья птицы.', '2.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('JVL42J', 'Музыкальные инструменты для детей, ксилофон, барабаны, развивающие игрушки, игрушки для детей', 'шт.', '2750', 'Playbig', 'BambiniFelici', 'Детский музыкальный инструмент', '15', '0', 'Откройте мир музыки для вашего ребенка с этой уникальной игрушкой! Это многофункциональное музыкальное чудо объединяет в себе всё, что нужно для творческого развития.', '3.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('F895RB', 'Машинка игрушка диско шар светящаяся музыкальная', 'шт.', '368', 'Knauf', 'ABSпластик', 'Машинка', '6', '7', 'Светящаяся музыкальная машина с диско шаром переливается разными цветами, играет ритмичные мелодии, объезжает препятствия и крутится, поэтому с ней точно не будет скучно.', '4.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('3XBOTN', 'Игровой набор Hot Wheels Action Loop Cyclone Challenge Track, с машинкой и удобным хранением, HTK16', 'шт.', '3426', 'Knauf', 'BambiniFelici', 'Игровой набор', '10', '21', 'Игровой набор Hot Wheels Action Loop Cyclone Challenge Track - это уникальная игра, которая позволит вам испытать себя и своих друзей в скорости и ловкости. Этот набор состоит из металлической дорожки с циклоном, которая создает потрясающий эффект и добавляет дополнительную сложность в игру.', '5.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('3L7RCZ', 'Игровой набор с деревянными машинками Стройплощадка Кран-Паркс, Junion', 'шт.', '7400', 'Knauf', 'Junion', 'Игровой набор', '15', '0', 'Игровой набор «Стройплощадка Кран-Паркс Junion» — это большая игрушечная парковка с деревянными машинками и настоящим подъёмным краном, придуманная в Яндексе настоящими родителями.', '6.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('S72AM3', 'Синтезатор детский с микрофоном 61 клавиша', 'шт.', '1749', 'CHILITOY', 'Junion', 'Детский музыкальный инструмент', '10', '35', 'Откройте для ребенка дверь в мир музыки с детским синтезатором! Этот компактный инструмент с микрофоном станет верным другом для юных музыкантов, помогая им развивать творческий потенциал и получать удовольствие от игры.', '7.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('2G3280', 'Деревянный игровой набор JUNION Стройплощадка "Кран-Паркс" с подъёмным, строительным краном и машинками, 18 предметов, подвижные элементы', 'шт.', '1624', 'Vinylon', 'Junion', 'Игровой набор', '9', '20', 'Игровой набор «Стройплощадка Кран-Паркс Junion» — это большая игрушечная парковка с деревянными машинками и настоящим подъёмным краном, придуманная в Яндексе настоящими родителями.', '8.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('MIO8YV', 'Музыкальная игрушка интерактивная Пульт, детский прорезыватель для малышей', 'шт.', '305', 'Vinylon', 'BambiniFelici', 'Детский музыкальный инструмент', '9', '31', 'Музыкальная игрушка интерактивная Пульт, детский прорезыватель для малышей', '9.jpg');
INSERT INTO products_import_raw (article_text, name_text, unit_text, price_text, supplier_text, manufacturer_text, category_text, discount_text, stock_text, description_text, photo_text) VALUES ('UER2QD', 'Большой набор опытов и экспериментов для детей 14 в 1', 'шт.', '2506', 'Vinylon', 'BambiniFelici', 'Игровой набор', '8', '27', 'Большой набор опытов и экспериментов для детей 14 в 1', '10.jpg');

-- ИМПОРТ: Пункты выдачи_import.csv
INSERT INTO pickup_points_import_raw (address_text) VALUES ('420151, г. Лесной, ул. Вишневая, 32');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('125061, г. Лесной, ул. Подгорная, 8');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('630370, г. Лесной, ул. Шоссейная, 24');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('400562, г. Лесной, ул. Зеленая, 32');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('614510, г. Лесной, ул. Маяковского, 47');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('410542, г. Лесной, ул. Светлая, 46');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('620839, г. Лесной, ул. Цветочная, 8');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('443890, г. Лесной, ул. Коммунистическая, 1');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('603379, г. Лесной, ул. Спортивная, 46');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('603721, г. Лесной, ул. Гоголя, 41');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('410172, г. Лесной, ул. Северная, 13');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('614611, г. Лесной, ул. Молодежная, 50');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('454311, г.Лесной, ул. Новая, 19');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('660007, г.Лесной, ул. Октябрьская, 19');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('603036, г. Лесной, ул. Садовая, 4');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('394060, г.Лесной, ул. Фрунзе, 43');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('410661, г. Лесной, ул. Школьная, 50');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('625590, г. Лесной, ул. Коммунистическая, 20');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('625683, г. Лесной, ул. 8 Марта');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('450983, г.Лесной, ул. Комсомольская, 26');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('394782, г. Лесной, ул. Чехова, 3');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('603002, г. Лесной, ул. Дзержинского, 28');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('450558, г. Лесной, ул. Набережная, 30');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('344288, г. Лесной, ул. Чехова, 1');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('614164, г.Лесной,  ул. Степная, 30');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('394242, г. Лесной, ул. Коммунистическая, 43');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('660540, г. Лесной, ул. Солнечная, 25');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('125837, г. Лесной, ул. Шоссейная, 40');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('125703, г. Лесной, ул. Партизанская, 49');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('625283, г. Лесной, ул. Победы, 46');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('614753, г. Лесной, ул. Полевая, 35');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('426030, г. Лесной, ул. Маяковского, 44');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('450375, г. Лесной ул. Клубная, 44');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('625560, г. Лесной, ул. Некрасова, 12');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('630201, г. Лесной, ул. Комсомольская, 17');
INSERT INTO pickup_points_import_raw (address_text) VALUES ('190949, г. Лесной, ул. Мичурина, 26');

-- ИМПОРТ: Заказ_import.csv
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('1', 'PMEZMH, 2, BPV4MM, 2', '27.02.2025', '20.04.2025', '1', 'Степанов Михаил Артёмович', '901', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('2', 'JVL42J, 1, F895RB, 1', '28.09.2024', '21.04.2025', '11', 'Ворсин Петр Евгеньевич', '902', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('3', '3XBOTN, 10, 3L7RCZ, 10', '21.03.2025', '22.04.2025', '2', 'Старикова Елена Павловна', '903', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('4', 'S72AM3, 5, 2G3280, 4', '20.02.2025', '23.04.2025', '11', 'Сазонов Руслан Германович', '904', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('5', 'MIO8YV, 2, UER2QD, 2', '17.03.2025', '24.04.2025', '2', 'Степанов Михаил Артёмович', '905', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('6', 'PMEZMH, 2, BPV4MM, 2', '01.03.2025', '25.04.2025', '15', 'Ворсин Петр Евгеньевич', '906', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('7', 'JVL42J, 1, F895RB, 1', '30.02.2025', '26.04.2025', '3', 'Старикова Елена Павловна', '907', 'Завершен');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('8', '3XBOTN, 10, 3L7RCZ, 10', '31.03.2025', '27.04.2025', '19', 'Сазонов Руслан Германович', '908', 'Новый');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('9', 'S72AM3, 5, 2G3280, 4', '02.04.2025', '28.04.2025', '5', 'Старикова Елена Павловна', '909', 'Новый');
INSERT INTO orders_import_raw (order_number_text, articles_text, order_date_text, delivery_date_text, pickup_point_text, client_fio_text, pickup_code_text, status_text) VALUES ('10', 'MIO8YV, 2, UER2QD, 2', '03.04.2025', '29.04.2025', '19', 'Сазонов Руслан Германович', '910', 'Новый');


-- ===========================================
-- ПЕРЕНОС ДАННЫХ ИЗ RAW В ЧИСТОВЫЕ ТАБЛИЦЫ (2-move.sql)
-- ===========================================

INSERT INTO roles (role_id, role_name) VALUES
(1, 'Гость'),
(2, 'Авторизированный клиент'),
(3, 'Менеджер'),
(4, 'Администратор');

INSERT INTO users (role_id, full_name, login, password_plain)
SELECT
    CASE
        WHEN role_name LIKE '%Администратор%' THEN 4
        WHEN role_name LIKE '%Менеджер%' THEN 3
        ELSE 2
    END AS role_id,
    TRIM(full_name),
    TRIM(login_text),
    TRIM(REPLACE(password_text, '\r', ''))
FROM users_import_raw
WHERE TRIM(login_text) <> '';

INSERT INTO categories (name)
SELECT DISTINCT TRIM(category_text)
FROM products_import_raw
WHERE TRIM(category_text) <> '';

INSERT INTO manufacturers (name)
SELECT DISTINCT TRIM(manufacturer_text)
FROM products_import_raw
WHERE TRIM(manufacturer_text) <> '';

INSERT INTO suppliers (name)
SELECT DISTINCT TRIM(supplier_text)
FROM products_import_raw
WHERE TRIM(supplier_text) <> '';

INSERT INTO products (
    article, name, unit_name, price,
    supplier_id, manufacturer_id, category_id,
    discount_percent, stock_quantity, description_text, photo_file
)
SELECT
    TRIM(p.article_text),
    TRIM(p.name_text),
    TRIM(p.unit_text),
    CAST(REPLACE(TRIM(p.price_text), ',', '.') AS DECIMAL(12,2)),
    s.supplier_id,
    m.manufacturer_id,
    c.category_id,
    CAST(REPLACE(TRIM(p.discount_text), ',', '.') AS DECIMAL(5,2)),
    CAST(TRIM(p.stock_text) AS UNSIGNED),
    NULLIF(TRIM(p.description_text), ''),
    NULLIF(TRIM(REPLACE(p.photo_text, '\r', '')), '')
FROM products_import_raw p
JOIN suppliers s ON s.name = TRIM(p.supplier_text)
JOIN manufacturers m ON m.name = TRIM(p.manufacturer_text)
JOIN categories c ON c.name = TRIM(p.category_text)
WHERE TRIM(p.article_text) <> '';

INSERT INTO pickup_points (pickup_point_id, address_text)
SELECT raw_id, TRIM(REPLACE(address_text, '\r', ''))
FROM pickup_points_import_raw
WHERE TRIM(REPLACE(address_text, '\r', '')) <> ''
ORDER BY raw_id;

INSERT INTO order_statuses (status_name)
SELECT DISTINCT TRIM(REPLACE(status_text, '\r', ''))
FROM orders_import_raw
WHERE TRIM(REPLACE(status_text, '\r', '')) <> '';

INSERT INTO orders (
    order_number, article_text, order_date, delivery_date,
    pickup_point_id, client_user_id, pickup_code, status_id
)
SELECT
    CAST(TRIM(o.order_number_text) AS UNSIGNED),
    TRIM(o.articles_text),
    STR_TO_DATE(TRIM(o.order_date_text), '%d.%m.%Y'),
    STR_TO_DATE(TRIM(o.delivery_date_text), '%d.%m.%Y'),
    CAST(TRIM(o.pickup_point_text) AS UNSIGNED),
    u.user_id,
    CAST(TRIM(o.pickup_code_text) AS UNSIGNED),
    st.status_id
FROM orders_import_raw o
LEFT JOIN users u
    ON u.full_name = TRIM(o.client_fio_text)
    AND u.role_id = 2
LEFT JOIN order_statuses st
    ON st.status_name = REPLACE(TRIM(o.status_text), '\r', '')
WHERE TRIM(o.order_number_text) <> '';

INSERT INTO order_items (order_id, product_id, quantity)
SELECT
    o.order_id,
    pr.product_id,
    CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 2), ',', -1)) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr
    ON pr.article = TRIM(SUBSTRING_INDEX(o.article_text, ',', 1))
WHERE TRIM(o.article_text) <> ''

UNION ALL

SELECT
    o.order_id,
    pr.product_id,
    CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 4), ',', -1)) AS UNSIGNED) AS qty
FROM orders o
JOIN products pr
    ON pr.article = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.article_text, ',', 3), ',', -1))
WHERE TRIM(o.article_text) <> '';