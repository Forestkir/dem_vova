CREATE DATABASE IF NOT EXISTS toys_2026;
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
    price DECIMAL(10, 2) NOT NULL,
    supplier_id INT UNSIGNED,
    manufacturer_id INT UNSIGNED,
    category_id INT UNSIGNED,
    discount_percent TINYINT UNSIGNED DEFAULT 0,
    stock_quantity INT NOT NULL DEFAULT 0,
    description_text TEXT,
    photo_file VARCHAR(120),
    CONSTRAINT fk_prod_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_prod_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id),
    CONSTRAINT fk_prod_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pickup_points (
    pickup_point_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_statuses (
    status_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders (
    order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number INT UNSIGNED NOT NULL UNIQUE,
    article_text TEXT,
    order_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    pickup_point_id INT UNSIGNED NOT NULL,
    client_user_id INT UNSIGNED,
    pickup_code INT UNSIGNED NOT NULL,
    status_id TINYINT UNSIGNED NOT NULL,
    CONSTRAINT fk_order_pickup FOREIGN KEY (pickup_point_id) REFERENCES pickup_points(pickup_point_id),
    CONSTRAINT fk_order_user FOREIGN KEY (client_user_id) REFERENCES users(user_id),
    CONSTRAINT fk_order_status FOREIGN KEY (status_id) REFERENCES order_statuses(status_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
    order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ROLES
INSERT INTO roles (role_id, role_name) VALUES (1, 'Гость'), (2, 'Авторизированный клиент'), (3, 'Менеджер'), (4, 'Администратор');

-- USERS
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (1, 4, 'Ворсин Петр Евгеньевич', '94d5ous@gmail.com', 'uzWC67');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (2, 4, 'Старикова Елена Павловна', 'uth4iz@mail.com', '2L6KZG');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (3, 4, 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (4, 3, 'Михайлюк Анна Вячеславовна', '1diph5e@tutanota.com', '8ntwUp');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (5, 3, 'Ситдикова Елена Анатольевна', 'tjde7c@yahoo.com', 'YOyhfR');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (6, 3, 'Никифорова Весения Николаевна', 'wpmrc3do@tutanota.com', 'RSbvHv');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (7, 2, 'Степанов Михаил Артёмович', '5d4zbu@tutanota.com', 'rwVDh9');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (8, 2, 'Ворсин Петр Евгеньевич', 'ptec8ym@yahoo.com', 'LdNyos');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (9, 2, 'Старикова Елена Павловна', '1qz4kw@mail.com', 'gynQMT');
INSERT INTO users (user_id, role_id, full_name, login, password_plain) VALUES (10, 2, 'Сазонов Руслан Германович', '4np6se@mail.com', 'AtnDjr');

-- CATEGORIES
INSERT INTO categories (category_id, name) VALUES (1, 'Игровой набор');
INSERT INTO categories (category_id, name) VALUES (2, 'Конструктор');
INSERT INTO categories (category_id, name) VALUES (3, 'Детский музыкальный инструмент');
INSERT INTO categories (category_id, name) VALUES (4, 'Машинка');
-- MANUFACTURERS
INSERT INTO manufacturers (manufacturer_id, name) VALUES (1, 'Pikeshop');
INSERT INTO manufacturers (manufacturer_id, name) VALUES (2, 'Playbig');
INSERT INTO manufacturers (manufacturer_id, name) VALUES (3, 'Knauf');
INSERT INTO manufacturers (manufacturer_id, name) VALUES (4, 'CHILITOY');
INSERT INTO manufacturers (manufacturer_id, name) VALUES (5, 'Vinylon');
-- SUPPLIERS
INSERT INTO suppliers (supplier_id, name) VALUES (1, 'ABSпластик');
INSERT INTO suppliers (supplier_id, name) VALUES (2, 'BambiniFelici');
INSERT INTO suppliers (supplier_id, name) VALUES (3, 'Junion');
-- PRODUCTS
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (1, 'PMEZMH', 'Детский игровой набор машинок Щенячий патруль / Dogs mini . 9 героев + 9 инерфионных машинок', 'шт.', 1414, 1, 1, 1, 22, 50, 'Детский набор машинок с героями мультсериала «Щенячий патруль» подойдет как для мальчиков, так и для девочек. В детский набор входит 9 фигурок щенков спасателей.', '1.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (2, 'BPV4MM', 'Конструктор Гарри Поттер Сова Букля 630 деталей совместим с lego harry potter, лего совместимый)', 'шт.', 771, 1, 2, 2, 15, 26, 'Коллекционная модель Букля состоит из множества потрясающих элементов, а также специального механизма внутри. С его помощью можно плавно поднимать-опускать крылья птицы.', '2.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (3, 'JVL42J', 'Музыкальные инструменты для детей, ксилофон, барабаны, развивающие игрушки, игрушки для детей', 'шт.', 2750, 2, 2, 3, 15, 0, 'Откройте мир музыки для вашего ребенка с этой уникальной игрушкой! Это многофункциональное музыкальное чудо объединяет в себе всё, что нужно для творческого развития.', '3.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (4, 'F895RB', 'Машинка игрушка диско шар светящаяся музыкальная', 'шт.', 368, 1, 3, 4, 6, 7, 'Светящаяся музыкальная машина с диско шаром переливается разными цветами, играет ритмичные мелодии, объезжает препятствия и крутится, поэтому с ней точно не будет скучно.', '4.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (5, '3XBOTN', 'Игровой набор Hot Wheels Action Loop Cyclone Challenge Track, с машинкой и удобным хранением, HTK16', 'шт.', 3426, 2, 3, 1, 10, 21, 'Игровой набор Hot Wheels Action Loop Cyclone Challenge Track - это уникальная игра, которая позволит вам испытать себя и своих друзей в скорости и ловкости. Этот набор состоит из металлической дорожки с циклоном, которая создает потрясающий эффект и добавляет дополнительную сложность в игру.', '5.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (6, '3L7RCZ', 'Игровой набор с деревянными машинками Стройплощадка Кран-Паркс, Junion', 'шт.', 7400, 3, 3, 1, 15, 0, 'Игровой набор «Стройплощадка Кран-Паркс Junion» — это большая игрушечная парковка с деревянными машинками и настоящим подъёмным краном, придуманная в Яндексе настоящими родителями.', '6.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (7, 'S72AM3', 'Синтезатор детский с микрофоном 61 клавиша', 'шт.', 1749, 3, 4, 3, 10, 35, 'Откройте для ребенка дверь в мир музыки с детским синтезатором! Этот компактный инструмент с микрофоном станет верным другом для юных музыкантов, помогая им развивать творческий потенциал и получать удовольствие от игры.', '7.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (8, '2G3280', 'Деревянный игровой набор JUNION Стройплощадка "Кран-Паркс" с подъёмным, строительным краном и машинками, 18 предметов, подвижные элементы', 'шт.', 1624, 3, 5, 1, 9, 20, 'Игровой набор «Стройплощадка Кран-Паркс Junion» — это большая игрушечная парковка с деревянными машинками и настоящим подъёмным краном, придуманная в Яндексе настоящими родителями.', '8.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (9, 'MIO8YV', 'Музыкальная игрушка интерактивная Пульт, детский прорезыватель для малышей', 'шт.', 305, 2, 5, 3, 9, 31, 'Музыкальная игрушка интерактивная Пульт, детский прорезыватель для малышей', '9.jpg');
INSERT INTO products (product_id, article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, description_text, photo_file) VALUES (10, 'UER2QD', 'Большой набор опытов и экспериментов для детей 14 в 1', 'шт.', 2506, 2, 5, 1, 8, 27, 'Большой набор опытов и экспериментов для детей 14 в 1', '10.jpg');

-- PICKUP POINTS
INSERT INTO pickup_points (pickup_point_id, address) VALUES (1, '420151, г. Лесной, ул. Вишневая, 32');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (2, '125061, г. Лесной, ул. Подгорная, 8');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (3, '630370, г. Лесной, ул. Шоссейная, 24');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (4, '400562, г. Лесной, ул. Зеленая, 32');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (5, '614510, г. Лесной, ул. Маяковского, 47');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (6, '410542, г. Лесной, ул. Светлая, 46');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (7, '620839, г. Лесной, ул. Цветочная, 8');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (8, '443890, г. Лесной, ул. Коммунистическая, 1');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (9, '603379, г. Лесной, ул. Спортивная, 46');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (10, '603721, г. Лесной, ул. Гоголя, 41');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (11, '410172, г. Лесной, ул. Северная, 13');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (12, '614611, г. Лесной, ул. Молодежная, 50');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (13, '454311, г.Лесной, ул. Новая, 19');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (14, '660007, г.Лесной, ул. Октябрьская, 19');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (15, '603036, г. Лесной, ул. Садовая, 4');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (16, '394060, г.Лесной, ул. Фрунзе, 43');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (17, '410661, г. Лесной, ул. Школьная, 50');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (18, '625590, г. Лесной, ул. Коммунистическая, 20');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (19, '625683, г. Лесной, ул. 8 Марта');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (20, '450983, г.Лесной, ул. Комсомольская, 26');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (21, '394782, г. Лесной, ул. Чехова, 3');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (22, '603002, г. Лесной, ул. Дзержинского, 28');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (23, '450558, г. Лесной, ул. Набережная, 30');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (24, '344288, г. Лесной, ул. Чехова, 1');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (25, '614164, г.Лесной,  ул. Степная, 30');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (26, '394242, г. Лесной, ул. Коммунистическая, 43');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (27, '660540, г. Лесной, ул. Солнечная, 25');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (28, '125837, г. Лесной, ул. Шоссейная, 40');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (29, '125703, г. Лесной, ул. Партизанская, 49');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (30, '625283, г. Лесной, ул. Победы, 46');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (31, '614753, г. Лесной, ул. Полевая, 35');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (32, '426030, г. Лесной, ул. Маяковского, 44');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (33, '450375, г. Лесной ул. Клубная, 44');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (34, '625560, г. Лесной, ул. Некрасова, 12');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (35, '630201, г. Лесной, ул. Комсомольская, 17');
INSERT INTO pickup_points (pickup_point_id, address) VALUES (36, '190949, г. Лесной, ул. Мичурина, 26');

-- ORDER STATUSES
INSERT INTO order_statuses (status_id, status_name) VALUES (1, 'Завершен');
INSERT INTO order_statuses (status_id, status_name) VALUES (2, 'Новый');
-- ORDERS & ORDER ITEMS
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (1, 1, 'PMEZMH, 2, BPV4MM, 2', '2025-02-27', '2025-04-20', 1, 7, 901, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 1, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 2, 2);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (2, 2, 'JVL42J, 1, F895RB, 1', '2024-09-28', '2025-04-21', 11, 8, 902, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (2, 3, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (2, 4, 1);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (3, 3, '3XBOTN, 10, 3L7RCZ, 10', '2025-03-21', '2025-04-22', 2, 9, 903, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (3, 5, 10);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (3, 6, 10);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (4, 4, 'S72AM3, 5, 2G3280, 4', '2025-02-20', '2025-04-23', 11, 10, 904, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (4, 7, 5);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (4, 8, 4);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (5, 5, 'MIO8YV, 2, UER2QD, 2', '2025-03-17', '2025-04-24', 2, 7, 905, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (5, 9, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (5, 10, 2);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (6, 6, 'PMEZMH, 2, BPV4MM, 2', '2025-03-01', '2025-04-25', 15, 8, 906, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (6, 1, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (6, 2, 2);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (7, 7, 'JVL42J, 1, F895RB, 1', '2025-02-30', '2025-04-26', 3, 9, 907, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (7, 3, 1);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (7, 4, 1);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (8, 8, '3XBOTN, 10, 3L7RCZ, 10', '2025-03-31', '2025-04-27', 19, 10, 908, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (8, 5, 10);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (8, 6, 10);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (9, 9, 'S72AM3, 5, 2G3280, 4', '2025-04-02', '2025-04-28', 5, 9, 909, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (9, 7, 5);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (9, 8, 4);
INSERT INTO orders (order_id, order_number, article_text, order_date, delivery_date, pickup_point_id, client_user_id, pickup_code, status_id) VALUES (10, 10, 'MIO8YV, 2, UER2QD, 2', '2025-04-03', '2025-04-29', 19, 10, 910, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (10, 9, 2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (10, 10, 2);