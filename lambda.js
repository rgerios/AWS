const mysql = require('mysql');

exports.handler = async (event) => {
    // Conectando ao RDS
    const connection = mysql.createConnection({
        host: process.env.RDS_HOST,
        user: process.env.RDS_USER,
        password: process.env.RDS_PASSWORD,
        database: process.env.RDS_DB
    });

    return new Promise((resolve, reject) => {
        connection.query('SELECT name FROM users WHERE id = ?', [event.userId], (error, results) => {
            if (error) {
                reject(error);
            } else {
                resolve({
                    statusCode: 200,
                    body: JSON.stringify({
                        username: results[0].name
                    })
                });
            }
        });
    });
};
