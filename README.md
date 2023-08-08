# VK - System Design
Homework for [course by System Design](https://balun.courses/courses/system_design). 
VK is a social network, which provides profiles, chats, friends handling and posts (feed)

## Requirements:
Based on https://m.vk.com/press/q1-2022-results
### Functional requirements:
#### As user I can:
- view my and others profiles
- view, add and delete friends
- create posts with mediafiles
- view user's personal feed or common feed
- write messages to another users, read them, create chats
- see message readed status
- write and read comments for posts

### Non-functional requirements:
- 119 000 000 world auditory
- 100 000 000 mau/66 000 000 dau
- 468 000 000 posts and comments every month
- 1 mb max size for mediafile
- 2000 symbols max size for message
- 20 000 symbols max for post
- 4000 symbols max size of comment
- comments, posts, messages and mediafiles are stored all the time

#### On average:
- users leave 20 comments under every post
- 1 mediafile is uploded for every post
- user has 100 friends
- user has 50 followers
- user sends 5 messages every day
- user browses 10 accounts every day
- user adds or delete 2 friends every month
- user views list of smbd's friends 1 time every day
- user views 2 pages of posts every day
- user creates 2 new chats every month

## Calculations (without cache)

```
1 / 21 * 468\*10⁶ ~ 22 000 000 posts every month ~ 733 000 posts every day
468\*10⁶ - 22\*10⁶ ~ 446 000 000 comments every month ~ 15 000 000 comments every day
```

| Method  | Path  | Calculation  | RPS  |
|---|---|---|---|
|<span style="color:green">GET</span>|/profile/{id}|10 accounts * 1 day * 66\*10⁶ dau|7638|
|<span style="color:yellow">POST</span>|/profile/{id}/friend|2 friends * 100\*10⁶ mau|77|
|<span style="color:green">GET</span>|/profile/{id}/friend|1 user * 66\*10⁶ dau|764|
|<span style="color:yellow">POST</span>|/media|1 mediafile * 733\*10³ posts in a day|9|
|<span style="color:yellow">POST</span>|/post|733*10³ posts in a day|9|
|<span style="color:green">GET</span>|/post|2 pages of posts * 66\*10⁶ dau|1527|
|<span style="color:green">GET</span>|/post/{id}|<p>1 page of comments * 66\*10⁶ dau</p><p>1 post * 66\*10⁶ dau</p>|<p>764 (comments)</p><p>764 (posts)</p>|
|<span style="color:yellow">POST</span>|/post/{id}/comment|15*10⁶ comments every day|174|
|<span style="color:yellow">POST</span>|/profile/{id}/chat|2 chats every day * 100\*10⁶ mau|77|
|<span style="color:green">GET</span>|/profile/{id}/chat|1 list of chat every day * 66\*10⁶ dau|763|
|<span style="color:yellow">POST</span>|/profile/{id}/chat/{cid}/message|5 messages * 66\*10⁶ dau|3819|
|||||
|<span style="color:green">read</span>|all|7638+764+764+763+1527|11456|
|<span style="color:yellow">write</span>|all|77+9+9+174+77+3819|4165|

\* /profile/{id}/chat/{cid} only for recovering message history on a new device

Post creation traffic 9 rps * 40 kb ~ 360 kB/s

#### Messages DB
replication factor 2

write consistency level ONE (AP) or LOCAL_QUORUM (CA)

read consistency level ONE or LOCAL_QUORUM

43 TB storage needed in month (~20% data compression is possible)

2,6 PB storage for 5 years

17 wMB/s and 7 rMB/s i/o

```
3819 (4 kb size of messages) + 172 (8 kb size of  comments) ~ 4000 rps writes
172 (comments) rps reads
3819 op/sec * 4 kB  + 8 kB * 174 op/sec ~ 17 MB/s write
8 kB * 5 comments * 174 op/sec ~ 7 MB/s read
```

### Relations DB
30 rps writes

764 rps reads

11 GB storage every 100 0000 000 users 

```
15 bytes object * 100 000 000 users + 34 bytes relation * 100 000 000 users * 3 types + 41 bytes property * 5 + 128 bytes string * 5
```

### Media Storage
9 rps writes
2291 rps read

23 TB for media storage per month

1,38 PB storage for 5 year
```
1 mediafile * 9 * 1 MB
````

### Main DB
10692 read rps

95 write rps

2,6 TB storage every month
156 TB storage for 5 years

```
25 kB * 10692 rps ~ 267 rMB/s
10 kB * 95 rps ~ 1 wMB/s
```



