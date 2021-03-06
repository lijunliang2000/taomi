import QtQuick 1.0

ListModel {
    id: shopcarModel
    Component.onCompleted: loadItemsData()
    Component.onDestruction: saveItemsData()
    function loadItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                //tx.executeSql('DROP TABLE shopcarOrder');
                // Create the database if it doesn't already exist
                //
                tx.executeSql('CREATE TABLE IF NOT EXISTS shopcarOrder(orderNO INTEGER key, suborderNO INTEGER, name TEXT, image TEXT, price REAL, num INTEGER)');
                var rs = tx.executeSql('SELECT * FROM shopcarOrder');
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        shopcarModel.append({"orderNO": item.orderNO,
                                             "suborderNO": item.suborderNO,
                                             "name": item.name,
                                             "image": item.image,
                                             "price": item.price,
                                             "num": item.num});
                        index++;
                    }
                }
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('DROP TABLE shopcarOrder');
                tx.executeSql('CREATE TABLE IF NOT EXISTS shopcarOrder(orderNO INTEGER key, suborderNO INTEGER, name TEXT, image TEXT, price REAL, num INTEGER)');
                var index = 0;
                while (index < shopcarModel.count) {
                    var item = shopcarModel.get(index);
                    tx.executeSql('INSERT INTO shopcarOrder VALUES(?,?,?,?,?,?)', [item.orderNO, item.suborderNO, item.name, item.image, item.price, item.num]);
                    index++;
                }
            }
        )
    }
}
