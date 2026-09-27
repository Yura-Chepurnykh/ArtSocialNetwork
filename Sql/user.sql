CREATE TYPE role_name AS ENUM ('user', 'admin', 'moderator', 'financal_analyst');

CREATE TABLE role (
    id GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name role_name NOT NULL UNIQUE
);

CREATE TABLE user (
    id GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_wt_roles (
    id INT REFERENCES role(id),
    id INT REFERENCES user(id),
    PRIMARY KEY(role_id, user_id)
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
    'Realism',
    'Impressionism',
    'Classicism',
    'Cubism',
    'Modernism'
);

CREATE TABLE size2d (
    id ALWAYS GENERATED AS IDENTITY PRIMARY KEY,

    CONSTRAINT fk_size2d_artwork
        FOREIGN KEY (artwork_id)
        REFERENCES artwork(id),

    height NUMERIC(10, 2) NOT NULL,
    length NUMERIC(10, 2) NOT NULL
);

CREATE TABLE size2d (
    id ALWAYS GENERATED AS IDENTITY PRIMARY KEY,

    CONSTRAINT fk_size3d_artwork
        FOREIGN KEY (artwork_id)
        REFERENCES artwork(id),

    height NUMERIC(10, 2) NOT NULL,
    length NUMERIC(10, 2) NOT NULL,
    width NUMERIC(10, 2) NOT NULL
);

CREATE TABLE artwork (
    id GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255),
    type art_type NOT NULL,
    movement movement_type NOT NULL,
    sizes GENERATED ALWAYS AS (
        CASE
            WHEN
                art_type = 'painting' OR
                art_type = 'drawing'

            THEN size2d
            ELSE size3d
        END
    ) STORED

    CONSTRAINT fk_artwork_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
)
