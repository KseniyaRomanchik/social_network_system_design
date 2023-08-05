# VK - System Design
Homework for [course by System Design](https://balun.courses/courses/system_design). 
VK is a social network, which provides profiles, chats, friends handling and posts (feed)

100 mil mau, 66 mil dau
50% mau = dau
471 mil posts and comments per month
448 mil comments leaved per month
23 mil posts created per month
330 mil messages written per day

on average:
1 account friends are viewed per day
10 accounts user browses per day
20 comments leaved under every post
1 media file is uploaded per 1 post
2 chats user reads per day
2 new chats user creates per month
2 pages of posts user reads per day
100 friends user has

max size of mediafile 1mb
max size of message 2000 symbols
max size of post 20000 symbols
max size of comment 4000 symbols

comments, posts, messages and mediafiles should be stored all the time


7638+764+1527+763+1527 ~ 12219 read rps
30+9+9+172+77+3819 ~ 4116 write rps

3819 + 172 rps writes to cassandra
30 rps writes to neo4j
764 rps reads from neo4j

23 tb for media storage per month
1 tb for main storage in month
4 + 1.5 tb for cassandra storage per month (-20% compression 4.4 tb)
311 gb per month or 1 tb for every 100 mil of users for neo4j storage

