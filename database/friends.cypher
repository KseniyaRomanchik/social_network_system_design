CREATE (n1 {id: 126, name: "Name3", photo: "126.jpg"})<-[:follows]-(n2 {id: 128, name: "Name5", photo: "128.jpg"})-[:is friend]->(n0 {id: 127, name: "Name4", photo: "127.jpg"})-[:is friend]->(n2)<-[:in love]-(n0)-[:is friend]->(n1)<-[:is friend]-(n4 {id: 125, name: "Name2", photo: "125.jpg"})-[:follows]->(n3 {id: 123, name: "Name", photo: "123.jpg"})-[:follows]->({id: 124, name: "Name1", photo: "124.jpg"}),
(n1)-[:is friend]->(n0)-[:follows]->(n3)-[:follows]->(n4),
(n3)-[:follows]->(n1)-[:in love]->(n3)-[:in love]->(n1)