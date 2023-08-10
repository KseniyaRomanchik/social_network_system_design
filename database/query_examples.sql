BEGIN;
    INSERT INTO interest ("name") VALUES ('name') ON CONFLICT DO NOTHING;
    INSERT INTO interest ("name") VALUES ('name2') ON CONFLICT DO NOTHING;

    INSERT INTO "profile" 
    ("name", "login", about, photo, city) 
    VALUES 
    ('name', 'login', 'about me', 'photo.jpg', 'City')
    ON CONFLICT DO NOTHING;

    INSERT INTO profile_interest (profile_id, interest_id) VALUES(
        (SELECT id FROM "profile" WHERE "login" = 'login' LIMIT 1),
        (SELECT id FROM interest WHERE interest.name = 'name' LIMIT 1)
    ) ON CONFLICT DO NOTHING;

    INSERT INTO profile_interest (profile_id, interest_id) VALUES(
        (SELECT id FROM "profile" WHERE "login" = 'login' LIMIT 1),
        (SELECT id FROM interest WHERE interest.name = 'name2' LIMIT 1)
    ) ON CONFLICT DO NOTHING;

    INSERT INTO "post" 
    (body, profile_id, is_draft) 
    VALUES 
    ('post #1', (SELECT id FROM "profile" WHERE "login" = 'login' LIMIT 1), false);

    INSERT INTO media 
    (post_id, "type", url) 
    VALUES 
    ((SELECT id FROM post WHERE profile_id = 1 LIMIT 1), 'image', 'smth.jpg');

    INSERT INTO hashtag ("name") VALUES ('hashtag') ON CONFLICT DO NOTHING;;
    INSERT INTO hashtag ("name") VALUES ('hashtag2') ON CONFLICT DO NOTHING;;

    INSERT INTO post_hashtag (post_id, hashtag_id) VALUES(
        (SELECT id FROM post WHERE profile_id = 1 LIMIT 1),
        (SELECT id FROM hashtag WHERE "name" = 'hashtag' LIMIT 1)
    ) ON CONFLICT DO NOTHING;;

    INSERT INTO post_hashtag (post_id, hashtag_id) VALUES(
        (SELECT id FROM post WHERE profile_id = 1 LIMIT 1),
        (SELECT id FROM hashtag WHERE "name" = 'hashtag2' LIMIT 1)
    ) ON CONFLICT DO NOTHING;;

    INSERT INTO chat ("name") VALUES ('name');
    INSERT INTO chat ("name") VALUES ('name2');

    INSERT INTO chat_profile (chat_id, profile_id) VALUES(
        (SELECT id FROM chat LIMIT 1),
        (SELECT id FROM interest WHERE interest.name = 'name' LIMIT 1)
    ) ON CONFLICT DO NOTHING;

    INSERT INTO chat_profile (chat_id, profile_id) VALUES(
        (SELECT id FROM chat LIMIT 1),
        (SELECT id FROM "profile" WHERE "login" = 'login' LIMIT 1)
    ) ON CONFLICT DO NOTHING;
COMMIT;

-- GET /profile/{id}
SELECT json_build_object(
    'id', p.id, 
    'name', p.name, 
    'about', p.about, 
    'photo', p.photo, 
    'city', p.city,
    'interests', json_build_object(
        'name', i.name
    ),
    'posts', json_build_object(
        'id', post.id,
        'body', post.body,
        'likes', post.like_counter,
        'tags', json_build_object(
            'name', h.name
        )
    )
)
FROM profile AS p
LEFT JOIN profile_interest AS pi ON p.id = pi.profile_id
INNER JOIN interest AS i ON i.id = pi.interest_id
INNER join post on p.id = post.profile_id AND post.is_draft IS FALSE
LEFT join post_hashtag as ph on ph.post_id = post.id
INNER join hashtag as h on h.id = ph.hashtag_id
WHERE p.id = 1;




