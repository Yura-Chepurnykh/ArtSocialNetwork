CREATE TYPE roles_names AS ENUM ('user', 'admin', 'moderator', 'financial analyst');

CREATE TABLE roles (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name roles_names NOT NULL UNIQUE
);

CREATE TABLE app_users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE users_with_roles (
    role_id INT NOT NULL,
    user_id INT NOT NULL,

    PRIMARY KEY(role_id, user_id),

    CONSTRAINT fk_users_with_roles_role_id
        FOREIGN KEY (role_id)
        REFERENCES roles(id),

    CONSTRAINT fk_users_with_roles_user_id
        FOREIGN KEY (user_id)
        REFERENCES app_users(id)
);

CREATE TYPE art_type AS ENUM (
    'painting',
    'sculpture',
    'drawing',
    'photography',
    'digital art',
    'ceramics',
    'wood carving'
);

CREATE TYPE movement_type as ENUM (
    'realism',
    'impressionism',
    'classicism',
    'cubism',
    'modernism'
);

CREATE TABLE artworks (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    name TEXT NOT NULL,
    path TEXT NOT NULL,
    type art_type NOT NULL,
    movement movement_type NOT NULL,

    CONSTRAINT fk_artwork_user
        FOREIGN KEY (user_id)
        REFERENCES app_users(id)
);

CREATE TABLE size2d (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    artwork_id INT NOT NULL UNIQUE,
    height NUMERIC(10, 2) NOT NULL CHECK (height > 0),
    length NUMERIC(10, 2) NOT NULL CHECK (length > 0),

    CONSTRAINT fk_size2d_artwork
        FOREIGN KEY (artwork_id)
        REFERENCES artworks(id)
);

CREATE TABLE size3d (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    artwork_id INT NOT NULL UNIQUE,
    height NUMERIC(10, 2) NOT NULL CHECK (height > 0),
    length NUMERIC(10, 2) NOT NULL CHECK (length > 0),
    depth NUMERIC(10, 2) NOT NULL CHECK (depth > 0),

    CONSTRAINT fk_size3d_artwork
        FOREIGN KEY (artwork_id)
        REFERENCES artworks(id)
);

CREATE TABLE stores (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address TEXT NOT NULL
);

CREATE TABLE orders (
    id INT GENERATED ALWAYS IDENTITY PRIMARY KEY,
    artist_id INT NOT NULL REFERENCES app_users(id),
    client_id INT NOT NULL REFERENCES app_users(id),
    store_id INT NOT NULL,
    technical_specification TEXT NOT NULL,
    order_time TIMESTAMPTZ DEFAULT NOW(),
    deadline_time TIMESTAMPTZ,

    CONSTRAINT fk_store_id
        FOREIGN KEY (store_id)
        REFERENCES stores(id)
);

CREATE TABLE purchases (
    id INT GENERATED ALWAYS IDENTITY PRIMARY KEY,
    artwork_id INT NOT NULL REFERENCES artworks(id),
    client_id INT NOT NULL REFERENCES app_users(id),
    store_id INT NOT NULL,
    purchase_time TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT fk_purchase_store_id
        FOREIGN KEY (store_id)
        REFERENCES stores(id)
);

CREATE TABLE comments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    artwork_id INT NOT NULL,
    text TEXT NOT NULL,

    CONSTRAINT fk_artwork_id
        FOREIGN KEY (artwork_id)
        REFERENCES artworks(id),

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES app_users(id)
);

CREATE TABLE likes (
    user_id INT NOT NULL,
    artwork_id INT NOT NULL,

    CONSTRAINT fk_likes_user_id
        FOREIGN KEY (user_id)
        REFERENCES app_users(id),

    CONSTRAINT fk_likes_artwork_id
        FOREIGN KEY (artwork_id)
        REFERENCES artworks(id),

    PRIMARY KEY(user_id, artwork_id)
);
